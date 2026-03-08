# 🚨 Emergency Backup Information

**If you can't reach Jarvis via webchat or iMessage, start here.**

---

## Quick Access Files

- **[[1. openclaw/Emergency-Backup/TROUBLESHOOTING]]** - Step-by-step recovery commands
- **[[1. openclaw/Emergency-Backup/SETUP]]** - Complete system configuration
- **[[QUICK-COMMANDS]]** - Copy-paste command cheatsheet
- **[[The Jarvis Playbook]]** - Full setup documentation (Google Doc)

---

## 📱 Can You Reach Jarvis?

### Try These (In Order)

1. **Web UI** - http://127.0.0.1:18789/
2. **iMessage** - Text +16138893035 from your iPhone

### If Nothing Works

Jump to [[1. openclaw/Emergency-Backup/TROUBLESHOOTING]] and start with "Emergency: Web UI Won't Connect"

---

## 🆘 Getting Help From Other AIs

**If Jarvis is down and you need help from ChatGPT/Claude:**

### Share This Context Block
```
I'm running OpenClaw (AI assistant gateway) on Mac mini M4, macOS 26.3.
The web UI (port 18789) is not responding.
- I'm not a developer, need step-by-step terminal commands
- Config: ~/.openclaw/openclaw.json
- Logs: /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
- Workspace: ~/Mac-Mini-Obsidian-Vault/1. openclaw/
- Vault Root: ~/Mac-Mini-Obsidian-Vault/

Can you help me debug? Here's what I've tried: [describe what you tried]
```

### Attach These Files
1. [[1. openclaw/Emergency-Backup/TROUBLESHOOTING]] - Recovery procedures
2. [[1. openclaw/Emergency-Backup/SETUP]] - System details
3. Log file (from `/tmp/openclaw/`)

---

## 🔧 Most Common Fixes

### Gateway Won't Start
```bash
openclaw status
openclaw gateway restart
```

### Web UI Down But Gateway Running
```bash
# Check if port is in use
lsof -i :18789

# Restart gateway
openclaw gateway restart

# Access web UI
open http://127.0.0.1:18789/
```

### Discord Bot Not Capturing
```bash
# Check if bot is running
ps aux | grep discord

# Restart bot (if needed)
cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/discord-capture"
node bot.js &

# Check Discrawl (backup capture)
cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/3. code/discrawl"
./bin/discrawl status
```

### QMD Search Not Working
```bash
# Check QMD index
qmd status

# Update index
qmd update

# If corrupted, rebuild
qmd embed -f
```

### Newsletter Automation Not Running
```bash
# Check LaunchAgent is loaded
launchctl list | grep com.openclaw.newsletter

# If not loaded, reload it
launchctl unload ~/Library/LaunchAgents/com.openclaw.newsletter.plist
launchctl load ~/Library/LaunchAgents/com.openclaw.newsletter.plist

# Check logs
tail -f /tmp/openclaw/newsletter.log
```

### Can't Reach Via iMessage
Check that:
- Messages.app is signed in
- `imsg` CLI is installed: `which imsg`
- OpenClaw gateway is running: `openclaw status`

---

## 💾 Backup Strategy

**This folder = your safety net**
- Sync to Google Drive for cloud backup
- All files are markdown (human-readable)
- Share with other AIs when you need help

**When Jarvis updates configs:**
- This folder auto-updates (daily backup @ 23:00)
- Google Drive stays in sync
- Always have latest info

---

## 🎯 Your Setup (Quick Reference)

**Device:** Mac mini M4 (macOS 26.3)  
**OpenClaw Port:** 18789 (local only)  
**Your Number:** +16138893035 (paired to Jarvis via iMessage)  
**Model:** Claude Sonnet 4.5 / Kimi K2.5 (Ollama)  
**Workspace:** `~/Mac-Mini-Obsidian-Vault/1. openclaw/`  
**Vault Root:** `~/Mac-Mini-Obsidian-Vault/`

**Channels:**
- ✅ iMessage (working, most reliable backup)
- ✅ Webchat (primary interface, via http://127.0.0.1:18789/)

**Active Systems:**
- ✅ Discord Observer Bot (PID 68868, 24/7 capture)
- ✅ Discrawl Archive (PID 74447, 2,539+ messages)
- ✅ QMD Search (388 files, 2,342 vectors)
- ✅ Daily Status Reports (07:00 iMessage)
- ✅ Daily Git Backup (23:00)
- ✅ Discord Retro (Sun/Thu @ 22:00)

**See:** [[1. openclaw/Emergency-Backup/SETUP]] for complete system configuration

---

## 📞 Last Resort

**If absolutely stuck:**
1. Take a photo of your terminal showing the error
2. Text it to a tech-savvy friend or post in OpenClaw Discord
3. Or: Ask ChatGPT/Claude and share the context block above

---

**Updated:** 2026-03-08  
**By:** Jarvis

---

## Notes
This folder mirrors critical recovery info. The Jarvis Playbook (Google Doc) has full setup documentation including Phase-by-phase build guide, 25 interview questions, System architecture diagrams, and Complete schedule of automations.
