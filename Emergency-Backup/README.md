# 🚨 Emergency Backup Information

**If you can't reach Javis via webchat or iMessage, start here.**

---

## Quick Access Files

- **[[1. openclaw/Emergency-Backup/TROUBLESHOOTING]]** - Step-by-step recovery commands
- **[[1. openclaw/Emergency-Backup/SETUP]]** - Complete system configuration
- **[[QUICK-COMMANDS]]** - Copy-paste command cheatsheet

---

## 📱 Can You Reach Javis?

### Try These (In Order)

1. **Web UI** - http://127.0.0.1:18789/
2. **iMessage** - Text +16138893035 from your iPhone
3. **Discord** - (if configured) Server 1467505736090386557

### If Nothing Works

Jump to [[1. openclaw/Emergency-Backup/TROUBLESHOOTING]] and start with "Emergency: Web UI Won't Connect"

---

## 🆘 Getting Help From Other AIs

**If Javis is down and you need help from ChatGPT/Claude:**

### Share This Context Block
```
I'm running OpenClaw (AI assistant gateway) on Mac mini M4, macOS 26.3.
The web UI (port 18789) is not responding.
- I'm not a developer, need step-by-step terminal commands
- Config: ~/.openclaw/openclaw.json
- Logs: /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
- Workspace: ~/Obsidian-Vault/openclaw/

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

**When Javis updates configs:**
- This folder auto-updates
- Google Drive stays in sync
- Always have latest info

---

## 🎯 Your Setup (Quick Reference)

**Device:** Mac mini M4 (macOS 26.3)  
**OpenClaw Port:** 18789 (local only)  
**Your Number:** +16138893035 (paired to Javis via iMessage)  
**Model:** Claude Sonnet 4.5  
**Workspace:** ~/Obsidian-Vault/openclaw/

**Channels:**
- ✅ iMessage (working, most reliable backup)
- ⚠️ Discord (setup in progress)

---

## 📞 Last Resort

**If absolutely stuck:**
1. Take a photo of your terminal showing the error
2. Text it to a tech-savvy friend or post in OpenClaw Discord
3. Or: Ask ChatGPT/Claude and share the context block above

---

**Updated:** 2026-02-15  
**By:** Javis

---

## Notes
This folder mirrors critical recovery info to Google Drive. Keep it synced!
