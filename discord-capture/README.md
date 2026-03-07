# Discord Retrospective Capture System

## Purpose
Capture Discord interactions in real-time, generate AI-powered retrospectives twice weekly (Sunday/Thursday).

## Architecture

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│ Discord Server  │────▶│ Listener Bot     │────▶│ Raw JSONL Files │
│ (24/7 capture) │     │ (discord-capture/) │     │ (daily append)  │
└─────────────────┘     └──────────────────┘     └─────────────────┘
                              │                           │
                              └──────────┐                │
                                         ▼                ▼
                              ┌──────────────────┐     ┌─────────────────┐
                              │ Retro Generator  │────▶│ Obsidian Memory │
                              │ (Sun/Thu @22:00) │     │ (twice weekly)  │
                              └──────────────────┘     └─────────────────┘
```

## Components

### 1. Listener Bot (`bot.js`)
Real-time Discord message capture. Node.js service using `discord.js`.

**Captured:**
- Messages I send
- Messages @mentioning me
- Messages replying to me
- All messages in monitored channels

**Storage:** `raw/YYYY-MM-DD.jsonl` (newline-delimited JSON)

**Run:** `node bot.js` (runs continuously)

### 2. Retro Generator (`generate-retro.sh`)
Twice-weekly processing via Ollama.

**Trigger:** LaunchAgent (Sun/Thu @22:00)

**Process:**
1. Collect raw JSONL since last run
2. Call Ollama (kimi-k2.5) to summarize
3. Generate retro markdown
4. Update marker file

**Output:** `memory/discord-retro/YYYY-MM-DD.md`

### 3. LaunchAgent
`com.openclaw.discord-retro.plist`

## Prerequisites

1. **Node.js** (v18+): `brew install node`
2. **jq** (JSON processing): `brew install jq` 
3. **Ollama**: `brew install ollama && ollama serve && ollama pull kimi-k2.5`

## Setup

One-command setup:

```bash
cd ~/Mac-Mini-Obsidian-Vault/1.\ openclaw/discord-capture
./setup.sh
```

Or manual:

1. Install dependencies: `npm install`
2. Copy `.env.example` to `.env` and fill in Discord bot token
3. Update `config.json` with your bot's Discord user ID
4. Invite bot to server (needs message read permissions)
5. Start listener: `node bot.js`
6. Load LaunchAgent: `launchctl load ~/Library/LaunchAgents/ai.thejarvis.openclaw.discord-retro.plist`

## File Structure

```
discord-capture/
├── bot.js                    # Discord listener
├── generate-retro.sh         # Retro generator
├── package.json              # Node deps
├── .env.example              # Template
├── config.json               # Channel/mapping config
├── README.md                 # This file
├── raw/                      # Captured messages
│   └── YYYY-MM-DD.jsonl
└── marker.json               # Last run timestamp

memory/discord-retro/         # Generated retros
└── YYYY-MM-DD.md
```

## Format

### Raw Message (JSONL)
```jsonl
{"timestamp":"2026-03-07T10:36:00Z","channel_id":"123","channel_name":"general","author":"Jarvis (AI)","content":"Got it — adjusted architecture","type":"bot_message","message_id":"456"}
```

### Retro Output (Markdown)
See template in generate-retro.sh

## Maintenance

- Raw files: Archive or delete old ones after retro generation
- Marker file: Auto-updated, don't manually edit
- Logs: Bot writes to stdout/stderr, consider redirection

---
Built 2026-03-07
