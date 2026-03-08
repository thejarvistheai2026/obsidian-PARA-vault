# Quick Commands Cheatsheet

**Copy-paste these directly into Terminal when you need help**

---

## 🚨 Emergency: Gateway Down

```bash
# Check status
openclaw status

# ✅ CORRECT WAY: Restart gateway (keeps LaunchAgent registered)
openclaw gateway restart

# ❌ WRONG WAY - Don't use these during normal operation:
# openclaw gateway stop    # This UNLOADS the LaunchAgent!
# openclaw gateway start   # This runs manually, not as a service
# Only use stop/start for debugging, then run `openclaw gateway install` to fix

# If you accidentally used stop/start, fix with:
openclaw gateway install   # Re-install LaunchAgent
openclaw gateway restart

# Access web UI
open http://127.0.0.1:18789/
```

---

## 📋 Check Logs

```bash
# View last 50 lines
tail -50 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log

# Search for errors
grep -i "error" /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log | tail -20

# Live tail (watch logs in real-time)
tail -f /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
```

---

## 🔌 Port Issues

```bash
# Check what's using port 18789
lsof -i :18789

# Kill process (replace PID with number from above)
kill -9 PID

# Restart gateway
openclaw gateway start
```

---

## ⚙️ Config

```bash
# View config
openclaw config get

# Backup config before changes
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup

# Restore from backup
cp ~/.openclaw/openclaw.json.backup ~/.openclaw/openclaw.json
openclaw gateway restart
```

---

## 📱 iMessage Check

```bash
# Check if imsg CLI is installed
which imsg

# Send test message to yourself
imsg send +16138893035 "Test from terminal"

# List recent chats
imsg list --limit 10
```

---

## 🐛 Debug Info (Share With Other AIs)

```bash
# System info
uname -a
node --version
openclaw --version

# Gateway status
openclaw status

# Recent logs with errors
grep -i "error\|fail\|crash" /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log | tail -30
```

---

## 🔄 Nuclear Option (Full Restart)

```bash
# ⚠️ DANGER: This will UNLOAD the LaunchAgent!
# Only use this for debugging, then re-install the service

# Stop everything
openclaw gateway stop
sleep 5

# Check nothing is running
ps aux | grep openclaw

# Start fresh
openclaw gateway start

# 🔧 CRITICAL: Re-install the service so it auto-starts on boot
openclaw gateway install

# Verify
openclaw status

# After this, use `openclaw gateway restart` for future restarts
```

---

## 🛠️ LaunchAgent (macOS Service)

```bash
# Unload service
launchctl bootout gui/$(id -u)/ai.openclaw.gateway

# Reload service
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/ai.openclaw.gateway.plist

# Check service status
launchctl list | grep openclaw
```

---

## 💡 Tips

- **Always backup config before editing:** `cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup`
- **Check logs first:** Most issues show up in logs
- **Restart fixes 90%:** `openclaw gateway restart`
- **Use iMessage as backup:** If web UI is down, text Javis at +16138893035

---

**Quick Reference Paths:**
- Config: `~/.openclaw/openclaw.json`
- Logs: `/tmp/openclaw/openclaw-YYYY-MM-DD.log`
- Workspace: `~/Mac-Mini-Obsidian-Vault/1. openclaw/`
- Vault Root: `~/Mac-Mini-Obsidian-Vault/`
- Web UI: `http://127.0.0.1:18789/`
- Backup Log: `/tmp/openclaw-backup.log`
- Newsletter Log: `/tmp/openclaw/newsletter.log`
- Daily Status Log: `/tmp/daily-status-report.log`

---

## 🤖 Discord Bot System

### Check Discord Bot Status
```bash
ps aux | grep "discord-capture/bot"
```

### Restart Discord Bot
```bash
cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/discord-capture"
node bot.js &
disown
```

### Check Discord Logs
```bash
tail -50 "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/discord-capture/bot.log"
```

### Run Discord Retro Manually
```bash
cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/discord-capture"
./generate-retro.sh
```

---

## 📚 Discrawl Archive

### Check Discrawl Status
```bash
cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/3. code/discrawl"
./bin/discrawl status
```

### Search Discord Archive
```bash
cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/3. code/discrawl"
./bin/discrawl search "your keyword"
```

### Restart Discrawl Tail
```bash
cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/3. code/discrawl"
./bin/discrawl tail --repair-every 30m &
disown
```

### Check Discrawl Logs
```bash
tail -50 "/Users/jarvis/Mac-Mini-Obsidian-Vault/3. code/discrawl/tail.log"
```

---

## 🔍 QMD Search

### Check QMD Status
```bash
qmd status
```

### Update QMD Index
```bash
qmd update
```

### Search QMD
```bash
# Keyword search
qmd search "keyword" -c brain

# Semantic search
qmd vsearch "concept" -c brain

# Query with LLM re-ranking
qmd query "your question" -c crm
```

### Full Re-embedding (Sunday maintenance)
```bash
qmd embed -f
```

### Check QMD Logs
```bash
tail -50 "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/memory/qmd-logs/$(date +%Y-%m-%d).log"
```

---

## 📊 Daily Status Report

### Check LaunchAgent Status
```bash
launchctl list | grep daily-status
```

### Reload Daily Status Agent
```bash
launchctl unload ~/Library/LaunchAgents/ai.thejarvis.openclaw.daily-status.plist
launchctl load ~/Library/LaunchAgents/ai.thejarvis.openclaw.daily-status.plist
```

### Run Status Report Manually
```bash
cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/.scripts"
./daily-status-report.sh
```

### Check Status Report Logs
```bash
tail -50 /tmp/daily-status-report.log
```

---

## 📧 Newsletter System

### Check if LaunchAgent is loaded
```bash
launchctl list | grep com.openclaw.newsletter
```

### Reload Newsletter Agent
```bash
launchctl unload ~/Library/LaunchAgents/com.openclaw.newsletter.plist
launchctl load ~/Library/LaunchAgents/com.openclaw.newsletter.plist
```

### Check Newsletter Logs
```bash
# Latest log
tail -50 /tmp/openclaw/newsletter.log

# Recent errors
tail -50 /tmp/openclaw/newsletter-error.log

# Specific date
tail -50 /tmp/openclaw/newsletter-$(date +%Y-%m-%d).log
```

### Run Newsletter Manually
```bash
cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/3. code/newsletter-system"
./scripts/run-scheduled.sh
```

---

**Updated:** 2026-03-08
