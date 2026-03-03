# OpenClaw Commands Cheat Sheet

**Quick Reference for Franco's Mac Mini Setup**  
**Last Updated:** 2026-02-15

---

## 📍 Where Everything Lives

### Core OpenClaw Files
**Program installation:**
```
/opt/homebrew/lib/node_modules/openclaw/
```

**Your config & data:**
```
~/.openclaw/
```
This folder contains:
- `openclaw.json` - Main config (API keys, tokens, settings)
- `workspace/` - Your agent files (AGENTS.md, SOUL.md, etc.)
- `agents/main/` - Session history & agent state

**Daily logs:**
```
/tmp/openclaw/openclaw-YYYY-MM-DD.log
```

---

## 🔍 Opening Files in Finder & Cursor

### Open OpenClaw Config Folder in Finder
```bash
open ~/.openclaw/
```

### Open Workspace in Finder
```bash
open ~/.openclaw/workspace/
```

### Open Config File in Cursor (Code Editor)
```bash
cursor ~/.openclaw/openclaw.json
```

### Open Entire Workspace in Cursor
```bash
cursor ~/.openclaw/workspace/
```

### Open Today's Log in Cursor
```bash
cursor /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
```

### Quick Navigation
```bash
# Jump to OpenClaw directory in terminal
cd ~/.openclaw/

# List everything
ls -la

# Open multiple things at once
open ~/.openclaw/ && cursor ~/.openclaw/openclaw.json
```

---

## 🚀 Essential Commands

### Check Status
```bash
openclaw status
```
Shows: gateway status, channels, sessions, memory

### Restart Gateway
```bash
openclaw gateway restart
```
Fixes most issues when web UI disconnects

### Stop & Start Gateway
```bash
openclaw gateway stop
openclaw gateway start
```
Use when restart doesn't work

### Access Web UI
```bash
open http://127.0.0.1:18789/
```
Opens the web chat interface in your browser

---

## 📂 Important File Locations

### Main Config File (contains all settings, tokens, API keys)
```bash
~/.openclaw/openclaw.json
```
**⚠️ SENSITIVE** - Contains bot tokens, API keys, auth tokens

### View Config
```bash
cat ~/.openclaw/openclaw.json
```

### Edit Config (use with caution!)
```bash
nano ~/.openclaw/openclaw.json
```
**Always backup first!**

### Backup Config Before Editing
```bash
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup
```

### Restore from Backup
```bash
cp ~/.openclaw/openclaw.json.backup ~/.openclaw/openclaw.json
openclaw gateway restart
```

---

## 📝 Logs & Debugging

### Today's Log File
```bash
/tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
```

### View Recent Logs (last 50 lines)
```bash
tail -50 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
```

### View Live Logs (watch in real-time)
```bash
tail -f /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
```
Press `Ctrl+C` to stop

### Search Logs for Errors
```bash
grep -i "error\|invalid\|failed" /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log | tail -20
```

### Check Discord Logs
```bash
grep -i discord /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log | tail -20
```

---

## 🗂️ Where OpenClaw Lives

### OpenClaw Installation
```bash
/opt/homebrew/lib/node_modules/openclaw/
```
This is where the main program lives (installed via Homebrew)

### OpenClaw Home Directory
```bash
~/.openclaw/
```
Contains config, agents, sessions, workspace

### Workspace (your files: AGENTS.md, SOUL.md, etc.)
```bash
~/.openclaw/workspace/
```

### List Workspace Files
```bash
ls -la ~/.openclaw/workspace/
```

### Agent Directory (sessions, history)
```bash
~/.openclaw/agents/main/
```

### Session Storage
```bash
~/.openclaw/agents/main/sessions/
```

---

## 🔍 What's Running?

### Check if Gateway is Running
```bash
ps aux | grep openclaw-gateway | grep -v grep
```
Shows process ID (PID) and memory usage

### Check Port 18789 (Gateway Port)
```bash
lsof -i :18789
```
Shows what's using the gateway port

### Kill Stuck Gateway Process
```bash
# First, get the PID from ps aux command above
kill -9 <PID>
# Then restart
openclaw gateway start
```

---

## 📡 Channels & Services

### Check Channel Status
```bash
openclaw status | grep -A 10 "Channels"
```
Shows: iMessage, Discord, etc. and their status

### Test iMessage
```bash
imsg chats --limit 5
```
Lists recent iMessage conversations

### Check Gmail
```bash
gog gmail search 'newer_than:1d' --max 5 --account jarvistheai2026@gmail.com
```
Shows recent emails

---

## 🛠️ Gateway Service Management

### Gateway Service Status
```bash
launchctl list | grep openclaw
```

### Stop Gateway Service
```bash
launchctl bootout gui/$(id -u)/ai.openclaw.gateway
```

### Start Gateway Service
```bash
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/ai.openclaw.gateway.plist
```

### Service Config File
```bash
~/Library/LaunchAgents/ai.openclaw.gateway.plist
```

---

## 🔧 Configuration Commands

### Validate Config
```bash
openclaw config get
```
Checks if config is valid JSON

### Get a Config Value
```bash
openclaw config get channels.discord.token
```

### Check OpenClaw Version
```bash
openclaw --version
```

### Update OpenClaw
```bash
openclaw update
```

---

## 🆘 Emergency Recovery

### Quick Fix (90% of problems)
```bash
openclaw gateway restart
```

### Deep Restart (when quick fix fails)
```bash
openclaw gateway stop
sleep 3
kill -9 $(ps aux | grep openclaw-gateway | grep -v grep | awk '{print $2}')
sleep 2
openclaw gateway start
```

### Check for Config Errors
```bash
grep -i "invalid\|error" /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log | tail -10
```

### Fix Config Permissions
```bash
chmod 600 ~/.openclaw/openclaw.json
```

---

## 📱 Alternative Contact Methods

### When Web UI is Down

1. **iMessage:** Text Javis at +16138893035
2. **Discord:** Message in server 1467505736090386557 (when working)
3. **Terminal:** Use commands above to restart

---

## 🔐 Security Notes

### Files with Sensitive Data
- `~/.openclaw/openclaw.json` - API keys, bot tokens, passwords
- Environment variables - May contain secrets

### Check File Permissions
```bash
ls -la ~/.openclaw/openclaw.json
```
Should show: `-rw-------` (600 permissions = owner only)

### Fix Permissions if Needed
```bash
chmod 600 ~/.openclaw/openclaw.json
```

---

## 📊 System Info

### Your Setup
- **Device:** Mac mini M4
- **OS:** macOS 26.3 (arm64)
- **Node:** v22.22.0
- **Gateway Port:** 18789 (localhost only)
- **Model:** Claude Sonnet 4.5

### Key Binaries
- `openclaw` → `/opt/homebrew/bin/openclaw`
- `gog` (Gmail/Drive) → `/opt/homebrew/bin/gog`
- `imsg` (iMessage) → `/opt/homebrew/bin/imsg`
- `node` → `/opt/homebrew/bin/node`

### Check Binary Locations
```bash
which openclaw
which gog
which imsg
```

---

## 💡 Pro Tips

### Open Everything at Once
```bash
# Open web UI + view logs
open http://127.0.0.1:18789/ && tail -f /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
```

### Quick Status Check
```bash
openclaw status && echo "---" && ps aux | grep openclaw-gateway | grep -v grep
```

### Search Logs for Specific Text
```bash
grep -i "discord\|imessage\|error" /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log | tail -30
```

### Copy Config to Desktop (for backup)
```bash
cp ~/.openclaw/openclaw.json ~/Desktop/openclaw-backup-$(date +%Y-%m-%d).json
```

---

## 🔗 Useful Links

- **Web UI:** http://127.0.0.1:18789/
- **Docs:** https://docs.openclaw.ai
- **GitHub:** https://github.com/openclaw/openclaw
- **Discord:** https://discord.com/invite/clawd
- **Skills:** https://clawhub.com

---

## 📋 Copy-Paste Block for ChatGPT/Claude

```
I'm running OpenClaw 2026.2.14 on Mac mini M4 (macOS 26.3).
- Config: ~/.openclaw/openclaw.json
- Logs: /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
- Gateway: http://127.0.0.1:18789/
- Workspace: ~/.openclaw/workspace/

My problem: [describe your issue here]
```

---

**Created by:** Javis  
**Date:** 2026-02-15  
**For:** Franco's OpenClaw Setup
