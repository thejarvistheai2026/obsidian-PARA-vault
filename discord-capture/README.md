# Discord Retrospective Capture System

**Status:** ✅ Active  
**Deployed:** 2026-03-07  
**Bot:** the-observer#9526  

## Overview

Captures Discord messages in real-time and generates AI-powered retrospectives twice weekly. Provides insights into conversations, friction points, and improvements.

## Architecture

```
Discord Server → Bot.js → raw/YYYY-MM-DD.jsonl → Retro Generator → memory/discord-retro/
```

## Components

### 1. Discord Bot (bot.js)
- **Location:** `discord-capture/bot.js`
- **Process:** Continuous capture
- **Output:** `raw/YYYY-MM-DD.jsonl`
- **Captured:** All messages in monitored channels

### 2. Retro Generator (generate-retro.sh)
- **Schedule:** Sun/Thu @ 22:00
- **Trigger:** LaunchAgent
- **AI:** Ollama (kimi-k2.5:cloud)
- **Output:** `memory/discord-retro/YYYY-MM-DD.md`

### 3. LaunchAgent
- **File:** `.launchagents/ai.thejarvis.openclaw.discord-retro.plist`
- **Schedule:** Sunday & Thursday @ 22:00
- **Script:** `discord-capture/run-retro.sh`

## Captured Data Format

Each message stored as JSONL:
```json
{
  "timestamp": "2026-03-07T16:11:55.314Z",
  "channel_id": "1472959543880454284",
  "channel_name": "general",
  "author": "francovarriano",
  "content": "message text",
  "type": "message"
}
```

## Retro Output Format

Generated retrospectives include:

### Summary
- Channels active
- Total messages
- Topics covered

### Conversations
- Context (what was discussed)
- Resolution (what was decided)
- Friction (challenges/ambiguities)
- Learning (key takeaways)

### Friction Points
- List of repeated clarifications
- Communication issues identified

### Decisions Made
- ✅ Confirmed decisions with context

### Improvements to Try
- [ ] Actionable suggestions

## Setup Commands

```bash
# Install dependencies
cd discord-capture && npm install

# Configure
cp .env.example .env
# Edit: DISCORD_TOKEN=your_token

# Start capture
node bot.js

# Test retro (manual)
./test-retro.sh
```

## Bot Configuration

**Required Permissions:**
- View Channels
- Read Message History
- Message Content Intent (Privileged Gateway Intent)

**Role:** Bot-Observer (or assigned role with read permissions)

## Schedule

| Day | Time | Event |
|-----|------|-------|
| Daily | 24/7 | Message capture |
| Sunday | 22:00 | Retro generation |
| Thursday | 22:00 | Retro generation |

## Files

```
discord-capture/
├── bot.js              # Discord listener
├── generate-retro.sh   # AI retro generator
├── test-retro.sh       # Manual testing
├── setup.sh            # One-time setup
├── package.json        # Node dependencies
├── config.json         # Bot config
├── .env.example        # Token template
├── .gitignore          # Excludes .env and captures
├── README.md           # This file
├── IMPLEMENTATION.md   # Technical details
├── raw/                # Captured messages
└── retro.log           # Generation logs

memory/discord-retro/   # Generated retros
```

## Management Commands

```bash
# Check if bot is running
ps aux | grep "node bot.js" | grep -v grep

# Restart bot
pkill -f "node bot.js"
cd discord-capture && node bot.js &

# Check LaunchAgent
launchctl list | grep discord-retro

# Force retro generation
./test-retro.sh

# View latest retro
cat memory/discord-retro/$(date +%Y-%m-%d).md
```

## Dependencies

- Node.js v18+
- discord.js
- Ollama (kimi-k2.5:cloud)
- jq (for JSON processing)

## Notes

- Bot only captures, never sends messages
- Raw data kept in workspace (not committed)
- Retros are committed to git
- Uses local Ollama for privacy
- Configured for "The Factory" Discord server

## Troubleshooting

### Bot not capturing
1. Check bot is running: `ps aux | grep bot.js`
2. Verify permissions in Discord
3. Check Message Content Intent is enabled
4. Ensure bot has channel access via role

### Retro not generating
1. Check Ollama: `ollama list`
2. Verify model: `ollama pull kimi-k2.5:cloud`
3. Check LaunchAgent: `launchctl list | grep discord`
4. Manually run: `./test-retro.sh`

## Related Systems

- Daily Status Report — includes Discord Bot status
- Newsletter System — separate Sun/Thu schedule
- Daily Backup — includes retro files

---
**Last Updated:** 2026-03-07
