# TROUBLESHOOTING.md - Emergency Recovery Guide

**Your Setup:** OpenClaw running on Mac mini M4 (macOS 26.3)  
**Your Name:** Franco  
**Your AI:** Javis (that's me!)  
**Location:** `/Users/jarvis/.openclaw/`

---

## ⚡ EMERGENCY ROLLBACK - Model Switch Gone Wrong

**If you just changed models and now OpenClaw won't respond:**

### Instant Fix (copy-paste this)
```bash
openclaw gateway stop
sleep 2
openclaw gateway start
```

### If that doesn't work - Force rollback to Claude Sonnet
```bash
# Open config in editor
cursor ~/.openclaw/openclaw.json

# Find the line that says "primary": "ollama/..."
# Change it to:
"primary": "anthropic/claude-sonnet-4-5"

# Save and restart
openclaw gateway restart
```

### Ultra-Simple Rollback (Terminal Only)
```bash
# Edit config manually
nano ~/.openclaw/openclaw.json

# Use arrow keys to find: "primary": "ollama/..."
# Change to: "primary": "anthropic/claude-sonnet-4-5"
# Press: Ctrl+X, then Y, then Enter

# Restart
openclaw gateway restart
```

---

## 🔄 Before Attempting Any Fix

**Follow our Standard Operating Procedure:**

1. **Let me explain** what broke and how we'll fix it
2. **Let me test** the fix in isolation first  
3. **You confirm "go"** before I touch anything
4. **I implement** with proper backups
5. **We validate** together

**Quick mode:** If it's urgent, say "skip SOP, just fix it"

**See:** `SOP-WORKFLOW.md` for full details

---

## 🔄 Before Attempting Any Fix

**Follow our Standard Operating Procedure:**

```
📋 Explain → 🔍 Research → 🧪 Test → ✅ You confirm "go" → 🔧 Implement → 🎯 Validate
```

**Before touching anything:**
1. Let me explain what's broken and my plan
2. **Let me research** official docs/proven sources
3. Let me test the approach first
4. **You say "go"** before I execute
5. I implement with backups
6. We validate together

**Quick mode:** Say "skip SOP, just fix it"

**See:** `SOP-WORKFLOW.md` for full details

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

## 🛡️ Model Switching Safety Protocol

**NEVER change models without these steps first:**

### Before ANY Model Change

1. **Backup your config**
```bash
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup
```

2. **Test the model exists**
```bash
# For Ollama models
ollama list

# For Ollama models with tags (like :cloud)
# Create a clean alias first
ollama cp model-name:tag model-name

# Example: ollama cp kimi-k2.5:cloud kimi
```

3. **Write rollback command in a safe place**
Create `~/Desktop/ROLLBACK.txt` with:
```bash
# EMERGENCY: If model switch breaks OpenClaw
cursor ~/.openclaw/openclaw.json
# Change "primary": "..." to "primary": "anthropic/claude-sonnet-4-5"
openclaw gateway restart
```

4. **Only then apply the change**

### ⚠️ Config File Safety Rules

**NEVER DELETE `openclaw.json`** - Even if it seems broken, it can be fixed. Deleting it wipes:
- All API keys & tokens
- All channel configurations (Discord, iMessage)
- All your settings

**Always edit, never delete.**

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

2. **Discord** (if we get it working)
   - Server ID: 1467505736090386557
   - App ID: 1472606548797948146

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
**Workspace:** `/Users/jarvis/.openclaw/workspace`  
**Config:** `~/.openclaw/openclaw.json`  
**Logs:** `/tmp/openclaw/openclaw-YYYY-MM-DD.log`  
**Model:** Claude Sonnet 4.5 (anthropic/claude-sonnet-4-5)  

**Channels Configured:**
- iMessage (via `imsg` CLI, paired: +16138893035)
- Discord (attempting setup)

**Skills Installed:**
- gog (Google Workspace: Gmail, Calendar, Drive)
- imsg (iMessage)
- weather
- healthcheck
- skill-creator

---

## 🆘 When Sharing With ChatGPT/Claude

### CRITICAL: Before Following ANY Advice

**If another AI suggests:**
- ❌ Deleting `openclaw.json`
- ❌ Removing the `~/.openclaw/` folder
- ❌ "Start fresh" or "clean install"

**DON'T DO IT.** Text Javis via iMessage first: +16138893035

**Safe to do:**
- ✅ View config: `cat ~/.openclaw/openclaw.json`
- ✅ Edit config: `cursor ~/.openclaw/openclaw.json`
- ✅ Backup config: `cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup`
- ✅ View logs: `tail -f /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log`
- ✅ Restart gateway: `openclaw gateway restart`

### Info Block to Share

**Copy this block:**

```
I'm running OpenClaw 2026.2.14 on a Mac mini M4 (macOS 26.3, arm64).
- Gateway: local loopback on port 18789
- Config: ~/.openclaw/openclaw.json
- Workspace: /Users/jarvis/.openclaw/workspace
- Logs: /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
- Model: Claude Sonnet 4.5 (default)
- Channels: iMessage (working), Discord (setup in progress)
- I'm not a developer - need step-by-step terminal commands

⚠️ IMPORTANT: Do not suggest deleting config files. I need to edit/fix, not delete.
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
