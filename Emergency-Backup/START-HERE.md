# 🚨 START HERE - Javis Won't Respond

**Take a breath. This happens sometimes. We'll fix it.**

---

## Step 1: Try iMessage First

Text your iPhone number: **+16138893035**

Send: "hey javis, are you there?"

**If Javis responds via iMessage → You're good! Ask me to help fix the web UI.**

---

## Step 2: Check If Gateway Is Running

Open **Terminal** and copy-paste this:

```bash
openclaw status
```

**What you might see:**

### ✅ "Gateway: running"
Gateway is up but web UI isn't connecting.

**Fix:**
```bash
openclaw gateway restart
```

Then refresh your browser: http://127.0.0.1:18789/

---

### ❌ "Gateway: stopped" or errors
Gateway crashed or stopped.

**Fix:**
```bash
openclaw gateway start
```

Wait 10 seconds, then open: http://127.0.0.1:18789/

---

### ⚠️ "Command not found: openclaw"
Path issue (rare).

**Fix:**
```bash
/opt/homebrew/bin/openclaw status
```

If that works, your PATH is broken. Text another AI (ChatGPT) for help.

---

## Step 3: Still Not Working?

### Check the logs
```bash
tail -50 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
```

Look for lines with **"ERROR"** or **"FAIL"** - these tell you what's wrong.

---

## Step 4: Get Help From Another AI

**If you're stuck, ask ChatGPT or Claude:**

**Paste this:**
```
I can't reach my OpenClaw AI assistant (Javis). 
Running on Mac mini M4, macOS 26.3.
I'm not a developer - need step-by-step help.

I tried:
- Web UI (http://127.0.0.1:18789/) - not loading
- iMessage (+16138893035) - no response
- openclaw status showed: [paste what you saw]

Here are my logs: [paste output from: tail -50 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log]

Can you help me restart it?
```

---

## Quick Wins (Try These)

### Restart Everything
```bash
openclaw gateway stop
sleep 3
openclaw gateway start
```

### Check Port 18789
```bash
lsof -i :18789
```
If something is using it, kill it:
```bash
kill -9 [PID from above]
openclaw gateway start
```

---

## Important File Locations

If someone is helping you, they'll ask for these:

- **Config:** `~/.openclaw/openclaw.json`
- **Logs:** `/tmp/openclaw/openclaw-$(date +%Y-%m-%d).log`
- **Workspace:** `~/Obsidian-Vault/openclaw/`

---

## More Help

- **[[QUICK-COMMANDS]]** - Copy-paste commands
- **[[1. openclaw/Emergency-Backup/TROUBLESHOOTING]]** - Detailed recovery guide
- **[[1. openclaw/Emergency-Backup/SETUP]]** - Complete system config

---

## Last Resort

**Reboot your Mac.**

Sometimes that's all it takes. OpenClaw will auto-start after reboot.

---

**Remember: This folder is synced to Google Drive. You can access it even if your Mac is down.**

---

**Updated:** 2026-02-15  
**By:** Javis (while I was still working 😊)
