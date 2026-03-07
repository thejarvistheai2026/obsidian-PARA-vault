# TROUBLESHOOTING.md - Emergency Recovery Guide

**Your Setup:** OpenClaw running on Mac mini M4 (macOS 26.3)  
**Your Name:** Franco  
**Your AI:** Javis (that's me!)  
**Workspace:** `/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/`  
**Vault Root:** `/Users/jarvis/Mac-Mini-Obsidian-Vault/`

---

## 🚨 Emergency: Web UI Won't Connect

### Step 1: Check if gateway is running
```bash
openclaw status
```

### Step 2: If it says "stopped" or shows errors
```bash
openclaw gateway restart
```

### Step 3: If restart fails, try this
```bash
openclaw gateway stop
sleep 3
openclaw gateway start
```

### Step 4: Access the web UI
Open in browser: **http://127.0.0.1:18789/**

---

## 🔌 Gateway Keeps Crashing

### Check logs for errors
```bash
tail -50 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
```

### Look for "Invalid config" errors
```bash
grep -i "invalid\|error" /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log | tail -20
```

### If config is broken, validate it
```bash
openclaw config get
```

If you see errors, the config file is corrupted. Your config is at:
```
~/.openclaw/openclaw.json
```

---

## 📱 Alternative Ways to Reach Javis

**When the web UI is down, you can reach me via:**

1. **iMessage** (paired: +16138893035)
   - Just text me from your iPhone
   - No special commands needed

---

## 🔧 Common Fixes

### Gateway won't start (port in use)
```bash
# Find what's using port 18789
lsof -i :18789

# Kill it (replace PID with the number you see)
kill -9 PID

# Restart gateway
openclaw gateway start
```

### Config file permissions error
```bash
chmod 600 ~/.openclaw/openclaw.json
```

### Gateway service stuck
```bash
launchctl bootout gui/$(id -u)/ai.openclaw.gateway
sleep 2
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/ai.openclaw.gateway.plist
```

---

## 📋 System Info (Give This to Other AIs)

**OpenClaw Version:** 2026.2.14  
**Install Type:** Homebrew (pnpm)  
**Node Version:** 22.22.0  
**OS:** macOS 26.3 (Darwin), arm64  
**Gateway Port:** 18789 (local loopback)  
**Workspace:** `/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/`  
**Vault Root:** `/Users/jarvis/Mac-Mini-Obsidian-Vault/`  
**Config:** `~/.openclaw/openclaw.json`  
**Logs:** `/tmp/openclaw/openclaw-YYYY-MM-DD.log`  
**Backup Log:** `/tmp/openclaw-backup.log`  
**Newsletter Log:** `/tmp/openclaw/newsletter.log`  
**Model:** Claude Kimi K2.5 (ollama/kimi-k2.5:cloud)  

**Channels Configured:**
- iMessage (via `imsg` CLI, paired: +16138893035)

**Skills Installed:**
- gws (Google Workspace: Gmail, Drive, Calendar, Sheets, Docs, Chat, Meet - replaces gog)
- imsg (iMessage)
- weather
- healthcheck
- skill-creator

---

## 🆘 When Sharing With ChatGPT/Claude

**Copy this block:**

```
I'm running OpenClaw 2026.2.14 on a Mac mini M4 (macOS 26.3, arm64).
- Gateway: local loopback on port 18789
- Config: ~/.openclaw/openclaw.json
- Workspace: /Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/
- Vault Root: /Users/jarvis/Mac-Mini-Obsidian-Vault/
- Logs: /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
- Backup Log: /tmp/openclaw-backup.log
- Newsletter Log: /tmp/openclaw/newsletter.log
- Model: Claude Kimi K2.5 (ollama/kimi-k2.5:cloud)
- Channels: iMessage (working), Webchat (primary)
- I'm not a developer - need step-by-step terminal commands
```

Then explain your problem.

---

## 🧰 Useful Commands

### Check what's running
```bash
ps aux | grep openclaw
```

### View live logs
```bash
tail -f /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
```

### Check channel status
```bash
openclaw status | grep -A 10 "Channels"
```

### Restart everything cleanly
```bash
openclaw gateway stop && sleep 3 && openclaw gateway start
```

---

## 💾 Backup Your Config Before Changes

**Always backup before editing config:**
```bash
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup
```

**Restore from backup if something breaks:**
```bash
cp ~/.openclaw/openclaw.json.backup ~/.openclaw/openclaw.json
openclaw gateway restart
```

---

## 📞 Last Resort: Reach Me Via iMessage

If nothing works:
1. Text me from your iPhone: "hey javis, openclaw web ui is down, help"
2. I'll respond via iMessage and help you debug

---

**Updated:** 2026-02-15  
**By:** Javis (your AI buddy)
