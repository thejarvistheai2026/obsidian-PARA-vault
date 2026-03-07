# Discord Retrospective System - Implementation Summary

## What Was Built

### Architecture
1. **Real-time Listener** (`bot.js`): Node.js Discord bot that captures messages continuously
2. **Retro Generator** (`generate-retro.sh`): Shell script using Ollama for AI summarization
3. **LaunchAgent** (`ai.thejarvis.openclaw.discord-retro.plist`): Runs retro generation Sun/Thu @ 22:00
4. **Setup Script** (`setup.sh`): One-command initialization

### File Structure
```
discord-capture/
├── bot.js                    # Discord listener (runs 24/7)
├── generate-retro.sh         # AI retro generator (Sun/Thu)
├── test-retro.sh             # Manual test script
├── setup.sh                  # One-time setup
├── package.json              # Node dependencies
├── .env.example              # Environment template
├── config.json               # Bot configuration
├── README.md                 # Documentation
├── raw/                      # Daily JSONL captures
└── marker.json               # Last run tracking

../memory/discord-retro/      # Generated retros
```

### Capture Logic
Captures messages where:
- I send a message
- Someone @mentions me
- Someone replies to my message
- Any message (configurable)

Stores as JSONL with timestamp, channel, author, content, message type.

### Retro Generation
Uses Ollama (kimi-k2.5) to analyze collected messages and generate:
- Summary of channels/messages/topics
- Structured conversations with context/resolution/friction/learning
- Friction points list
- Decisions made
- Improvements to try

## Next Steps

### 1. Discord Bot Setup (Required)

**Create Bot:**
1. Go to https://discord.com/developers/applications
2. Click "New Application" → give it a name
3. Go to "Bot" section → "Reset Token" → copy token
4. Go to "Privileged Gateway Intents" → enable "Message Content Intent"
5. Go to "OAuth2" → "URL Generator"
   - Scopes: `bot`, `applications.commands`
   - Bot Permissions: `Read Messages/View Channels`, `Read Message History`
6. Copy the generated URL → open in browser → invite to your server

**Configure:**
1. `cd ~/Mac-Mini-Obsidian-Vault/1.\ openclaw/discord-capture`
2. `./setup.sh` (or `npm install`)
3. Edit `.env`: `DISCORD_TOKEN=your_token_here`
4. Edit `config.json`: Set `botUserId` (from OAuth2 → Client ID)

**Start Listener:**
```bash
node bot.js
```

Runs in foreground. Use `screen`, `tmux`, or `nohup` for background:
```bash
nohup node bot.js > discord.log 2>&1 &
disown
```

### 2. Install LaunchAgent

```bash
launchctl load ~/Library/LaunchAgents/ai.thejarvis.openclaw.discord-retro.plist
launchctl list | grep discord-retro
```

Verify it loads:
```bash
launchctl list | grep ai.thejarvis.openclaw.discord-retro
```

### 3. Test Retro Generation

```bash
cd ~/Mac-Mini-Obsidian-Vault/1.\ openclaw/discord-capture
./test-retro.sh
```

This runs the retro generator manually against whatever raw data exists.

### 4. First Run Schedule

- **Daily capture:** Continuous once bot.js runs
- **First retro:** Next Sunday or Thursday at 22:00
- **Check output:** `memory/discord-retro/YYYY-MM-DD.md`

## Status

| Component | Status | Notes |
|-----------|--------|-------|
| Listener script | ✅ Ready | Needs Discord token |
| Retro generator | ✅ Ready | Needs Ollama running |
| LaunchAgent | ✅ Ready | Needs loading |
| Setup script | ✅ Ready | One-command init |
| Test script | ✅ Ready | For manual testing |

## Questions to Answer

1. **Discord Token:** Do you have one or need to create?
2. **Ollama:** Is it installed and running? (`ollama list` to check)
3. **jq:** Is it installed? (`brew install jq`)
4. **Node:** Is it installed? (`node --version`)

## Troubleshooting

**"Discord token not set"**
→ Copy `.env.example` to `.env`, add token

**"Ollama connection refused"**
→ Run `ollama serve` in another terminal

**"jq: command not found"**
→ Run `brew install jq`

**"Module not found"**
→ Run `npm install` in the discord-capture directory

**LaunchAgent not running**
```bash
launchctl unload ~/Library/LaunchAgents/ai.thejarvis.openclaw.discord-retro.plist
launchctl load ~/Library/LaunchAgents/ai.thejarvis.openclaw.discord-retro.plist
```

Check logs:
```bash
tail -f ~/Mac-Mini-Obsidian-Vault/1.\ openclaw/discord-capture/retro.error
```

## Output Example

After first retro runs, you'll get:

```markdown
# Discord Retro - 2026-03-09

**Period:** 2026-03-07 to 2026-03-09
**Generated:** Sun Mar  9 22:00:00 UTC 2026
**Model:** kimi-k2.5

## Summary
- Channels active: general (45), coding (12)
- Total messages: 57
- Topics covered: Bot setup, Newsletter debugging

## Conversations

### Topic: Discord Retrospective Pipeline (#general)
- **Context:** Discussed architecture for capturing Discord to vault
- **Resolution:** Built bot.js + generate-retro.sh + LaunchAgent system
- **Friction:** Token setup instructions scattered
- **Learning:** Provide clear step-by-step Discord bot setup

## Friction Points
1. Docs need explicit "create app" flow

## Decisions Made
- ✅ Run retros Sun/Thu @ 22:00
- ✅ Use Ollama kimi-k2.5 for summarization

## Improvements to Try
- [ ] Create video walkthrough of Discord bot setup
```

---
Built 2026-03-07
