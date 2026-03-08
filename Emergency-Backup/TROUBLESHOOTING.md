# TROUBLESHOOTING.md - Emergency Recovery Guide

**Your Setup:** OpenClaw running on Mac mini M4 (macOS 26.3)  
**Your Name:** Franco  
**Your AI:** Jarvis (that's me!)  
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

## 🗣️ Alternative Ways to Reach Jarvis

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

## 🤖 Discord Bot Issues

### Bot not responding/capturing
```bash
# Check if bot is running
ps aux | grep "discord-capture/bot"

# If not running, restart
cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/discord-capture"
node bot.js &
disown

# Check logs
tail -f discord-capture/bot.log
```

### Discrawl issues (backup capture)
```bash
cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/3. code/discrawl"

# Check status
./bin/discrawl status

# If tail mode stopped, restart
./bin/discrawl tail --repair-every 30m &
disown

# Check logs
tail -f tail.log
```

---

## 🔍 QMD Search Issues

### QMD not responding
```bash
# Check if index exists
qmd status

# Update index
qmd update

# If corrupted, full rebuild
qmd embed -f
```

### Out of memory during re-embedding
```bash
# Check available memory
free -h

# If low on memory, close other apps first
# Re-embedding loads three models (~2GB total)
```

---

## 📊 Status Report Issues

### Daily status not sending
```bash
# Check LaunchAgent
launchctl list | grep daily-status

# Reload if needed
launchctl unload ~/Library/LaunchAgents/ai.thejarvis.openclaw.daily-status.plist
launchctl load ~/Library/LaunchAgents/ai.thejarvis.openclaw.daily-status.plist

# Test manually
cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/.scripts"
./daily-status-report.sh
```

---

## 💾 Git Backup Issues

### Backup failing
```bash
# Check LaunchAgent
launchctl list | grep daily-backup

# View logs
tail -50 /tmp/openclaw-backup.log

# Test manually
cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/.scripts"
./daily-backup.sh
```

---

## 📋 System Info (Give This to Other AIs)

**OpenClaw Version:** 2026.2.14  
**Install Type:** Homebrew (pnpm)  
**Node Version:** 22.22.0  
**Go Version:** 1.26.1  
**OS:** macOS 26.3 (Darwin), arm64  
**Gateway Port:** 18789 (local loopback)  
**Workspace:** `/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/`  
**Vault Root:** `/Users/jarvis/Mac-Mini-Obsidian-Vault/`  
**Config:** `~/.openclaw/openclaw.json`  
**Logs:** `/tmp/openclaw/openclaw-YYYY-MM-DD.log`  
**Backup Log:** `/tmp/openclaw-backup.log`  
**Daily Status Log:** `/tmp/daily-status-report.log`  
**Model:** Claude Sonnet 4.5 / Kimi K2.5 (Ollama)  

**Channels Configured:**
- iMessage (via `imsg` CLI, paired: +16138893035)
- Discord (bot: the-observer#9526)

**Active Systems:**
- Discord Observer Bot (PID 68868, 24/7 capture)
- Discrawl Archive (PID 74447, 2,539+ messages)
- QMD Search (388 files, 2,342 vectors)
- Daily Status Reports (07:00 iMessage)
- Daily Git Backup (23:00)
- Discord Retro (Sun/Thu @ 22:00)

**Skills Installed:**
- gws (Google Workspace: 38 skills)
- imsg (iMessage)
- weather
- healthcheck
- skill-creator

---

## 🚨 Critical: Gateway Service Got Uninstalled

### ⚠️ What Happened (Documented 2026-03-08)
When debugging Discord config, I ran these commands to restart the gateway:
```bash
openclaw gateway stop    # ❌ This UNLOADS the LaunchAgent!
openclaw gateway start   # ❌ This starts manually, NOT as a service
```

**Result:** The service was unregistered from macOS. Every time the system restarted or the service crashed, it wouldn't auto-recover. Gateway showed as "not loaded" in status.

### ✅ The Fix
```bash
# Re-install the LaunchAgent (one-time fix)
openclaw gateway install

# Verify service status
launchctl list | grep openclaw

# Restart properly
openclaw gateway restart
```

### 📝 Lesson Learned
**For config changes, ONLY use:**
```bash
openclaw gateway restart   # ✅ Keeps LaunchAgent registered
```

**NEVER use:**
```bash
openclaw gateway stop     # ❌ Unloads the service!
openclaw gateway start    # ❌ Runs manually, not as service

# These break auto-start on boot and auto-restart on crash
```

**Correct pattern:**
1. Edit config
2. `openclaw gateway restart`
3. Done

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
- Model: Claude Sonnet 4.5 / Kimi K2.5 (Ollama)
- Channels: iMessage (working), Webchat (primary)
- Active: Discord bot (PID 68868), Discrawl (PID 74447), QMD, Daily backups
- I'm not a developer - need step-by-step terminal commands
```

Then explain your problem.

---

## 🧰 Useful Commands

### Check what's running
```bash
ps aux | grep openclaw
ps aux | grep discord
ps aux | grep discrawl
```

### View live logs
```bash
# OpenClaw
tail -f /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log

# QMD
tail -f "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/memory/qmd-logs/$(date +%Y-%m-%d).log"

# Discord bot
tail -f "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/discord-capture/bot.log"

tail -f "/Users/jarvis/Mac-Mini-Obsidian-Vault/3. code/discrawl/tail.log"
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
1. Text me from your iPhone: "hey jarvis, openclaw web ui is down, help"
2. I'll respond via iMessage and help you debug

---

**Updated:** 2026-03-08  
**By:** Jarvis (your AI buddy)
