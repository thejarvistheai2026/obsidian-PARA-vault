/**
 * Discord Historical Message Backfill
 * Fetches message history from all accessible channels
 * Run: node backfill-channel.js [days_back]
 * Default: 30 days
 */

const { Client, GatewayIntentBits } = require('discord.js');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const RAW_DIR = './raw';
const DAYS_BACK = parseInt(process.argv[2]) || 30;
const BATCH_SIZE = 100; // Discord max
const RATE_LIMIT_DELAY = 1000; // 1 second between batches

if (!fs.existsSync(RAW_DIR)) {
  fs.mkdirSync(RAW_DIR, { recursive: true });
}

const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent
  ]
});

function getDateFilename(date) {
  return path.join(RAW_DIR, `${date.toISOString().split('T')[0]}.jsonl`);
}

function appendToDateFile(date, data) {
  const filename = getDateFilename(date);
  const line = JSON.stringify(data) + '\n';
  fs.appendFileSync(filename, line);
}

async function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function fetchChannelHistory(channel, cutoffDate) {
  console.log(`📁 Backfilling #${channel.name}...`);
  
  let lastId = null;
  let fetched = 0;
  let hasMore = true;
  
  while (hasMore) {
    const options = { limit: BATCH_SIZE };
    if (lastId) options.before = lastId;
    
    try {
      const messages = await channel.messages.fetch(options);
      
      if (messages.size === 0) {
        hasMore = false;
        break;
      }
      
      for (const [_, message] of messages) {
        // Stop if message is older than cutoff
        if (message.createdAt < cutoffDate) {
          hasMore = false;
          break;
        }
        
        const data = {
          timestamp: message.createdAt.toISOString(),
          channel_id: message.channel.id,
          channel_name: message.channel.name || 'dm',
          guild_id: message.guild?.id || null,
          guild_name: message.guild?.name || null,
          message_id: message.id,
          author_id: message.author.id,
          author: message.author.username,
          author_bot: message.author.bot,
          content: message.content,
          type: 'historical',
          mentions_me: false,
          reply_to_me: message.reference?.messageId ? true : false,
          thread_id: message.thread?.id || null
        };
        
        appendToDateFile(message.createdAt, data);
        fetched++;
        lastId = message.id;
      }
      
      console.log(`  ✓ Fetched ${fetched} messages from #${channel.name}`);
      
      // Rate limit protection
      await sleep(RATE_LIMIT_DELAY);
      
    } catch (error) {
      console.error(`  ✗ Error in #${channel.name}:`, error.message);
      if (error.code === 50001) {
        console.log(`  ⚠️ No access to #${channel.name}, skipping...`);
        return fetched;
      }
      hasMore = false;
    }
  }
  
  return fetched;
}

client.on('ready', async () => {
  console.log(`✓ Logged in as ${client.user.tag}`);
  console.log(`⏳ Fetching last ${DAYS_BACK} days of history...`);
  console.log('─'.repeat(50));
  
  const cutoffDate = new Date();
  cutoffDate.setDate(cutoffDate.getDate() - DAYS_BACK);
  
  let totalFetched = 0;
  
  // Get all guilds the bot is in
  for (const [_, guild] of client.guilds.cache) {
    console.log(`\n🏠 Server: ${guild.name}`);
    console.log(`   Channels: ${guild.channels.cache.size}`);
    
    // Filter to text channels only
    const textChannels = guild.channels.cache.filter(
      ch => ch.isTextBased() && !ch.isThread()
    );
    
    for (const [_, channel] of textChannels) {
      const fetched = await fetchChannelHistory(channel, cutoffDate);
      totalFetched += fetched;
      
      if (fetched > 0) {
        console.log(`   ✓ #${channel.name}: ${fetched} messages`);
      }
    }
  }
  
  console.log('\n' + '─'.repeat(50));
  console.log(`✅ Backfill complete! Total: ${totalFetched} messages`);
  console.log(`📂 Files: ${RAW_DIR}/YYYY-MM-DD.jsonl`);
  process.exit(0);
});

if (!process.env.DISCORD_TOKEN) {
  console.error('❌ DISCORD_TOKEN not set');
  process.exit(1);
}

client.login(process.env.DISCORD_TOKEN);