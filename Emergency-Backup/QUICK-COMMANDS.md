# Quick Commands Cheatsheet

**Copy-paste these directly into Terminal when you need help**

---

## 🚨 Emergency: Gateway Down

```bash
# Check status
openclaw status

# Restart gateway
openclaw gateway restart

# If restart fails, try this
openclaw gateway stop
sleep 3
openclaw gateway start

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
# Stop everything
openclaw gateway stop
sleep 5

# Check nothing is running
ps aux | grep openclaw

# Start fresh
openclaw gateway start

# Verify
openclaw status
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
- Workspace: `~/Obsidian-Vault/openclaw/`
- Web UI: `http://127.0.0.1:18789/`

---

**Updated:** 2026-02-15
