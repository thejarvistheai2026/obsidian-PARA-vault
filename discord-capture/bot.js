/**
 * Discord Retrospective Capture Bot
 * Real-time message capture to JSONL files
 * Run: node bot.js
 */

const { Client, GatewayIntentBits, Partials } = require('discord.js');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

// Load config
const config = JSON.parse(fs.readFileSync('./config.json', 'utf8'));

// Ensure directories exist
const RAW_DIR = config.storage.rawDir || './raw';
if (!fs.existsSync(RAW_DIR)) {
  fs.mkdirSync(RAW_DIR, { recursive: true });
}

// Discord client with required intents
const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent,
    GatewayIntentBits.GuildMessageReactions
  ],
  partials: [Partials.Message, Partials.Channel, Partials.Reaction]
});

// Get today's filename
function getTodayFilename() {
  const date = new Date().toISOString().split('T')[0];
  return path.join(RAW_DIR, `${date}.jsonl`);
}

// Append message to JSONL file
function captureMessage(message, type = 'message') {
  const data = {
    timestamp: new Date().toISOString(),
    channel_id: message.channel.id,
    channel_name: message.channel.name || 'dm',
    guild_id: message.guild?.id || null,
    guild_name: message.guild?.name || null,
    message_id: message.id,
    author_id: message.author.id,
    author: message.author.username,
    author_bot: message.author.bot,
    content: message.content,
    type: type,
    mentions_me: message.mentions.users.has(config.botUserId) || 
                 message.mentions.roles.some(r => message.guild?.members?.me?.roles?.cache?.has(r.id)),
    reply_to_me: message.reference?.messageId ? true : false,
    thread_id: message.thread?.id || null
  };

  const line = JSON.stringify(data) + '\n';
  fs.appendFileSync(getTodayFilename(), line);
  
  console.log(`[${new Date().toLocaleTimeString()}] Captured: ${type} in #${data.channel_name} by ${data.author}`);
}

// Events
client.on('ready', () => {
  console.log(`✓ Bot logged in as ${client.user.tag}`);
  console.log(`✓ Capturing to: ${RAW_DIR}/YYYY-MM-DD.jsonl`);
  console.log(`✓ Server: ${client.guilds.cache.first()?.name || 'No servers'}`);
  console.log('─'.repeat(50));
});

client.on('messageCreate', (message) => {
  console.log('[DEBUG] Received message from ' + message.author.username + ' in #' + message.channel.name);
  // Skip if DMs and not configured
  if (!message.guild && !config.capture.allMessages) return;
  
  // Determine message type
  let type = 'message';
  
  if (message.author.id === client.user.id) {
    type = 'bot_message';
  } else if (message.author.bot) {
    type = 'bot_mention';
  }
  
  // Check if it's a reply to the bot
  if (message.reference?.messageId) {
    const referenced = message.channel.messages.cache.get(message.reference.messageId);
    if (referenced?.author?.id === client.user.id) {
      type = 'reply_to_bot';
    }
  }
  
  // Check if bot is mentioned
  const mentionsMe = message.mentions.users.has(client.user.id);
  
  // Capture logic
  const shouldCapture = 
    (config.capture.allMessages) ||
    (config.capture.botMessages && message.author.bot) ||
    (config.capture.mentions && mentionsMe) ||
    (config.capture.replies && type === 'reply_to_bot') ||
    (message.author.id === client.user.id);
  
  if (shouldCapture) {
    captureMessage(message, type);
  }
});

// Error handling
client.on('error', (error) => {
  console.error('Discord client error:', error);
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});

// Start
if (!process.env.DISCORD_TOKEN) {
  console.error('❌ DISCORD_TOKEN not set. Copy .env.example to .env and add your token.');
  process.exit(1);
}

client.login(process.env.DISCORD_TOKEN);
