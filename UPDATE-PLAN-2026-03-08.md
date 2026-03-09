# OpenClaw Safe Update Plan

**Date:** 2026-03-08  
**Current Version:** 2026.2.14  
**Target Version:** 2026.3.7 (available)  
**Install Type:** pnpm/npm global  
**Channel:** stable

---

## ⚠️ Pre-Flight Checklist

Before we touch anything:

- [ ] All automation systems running normally
- [ ] Config backed up successfully
- [ ] Rollback plan documented
- [ ] iMessage backup channel confirmed working
- [ ] Time allocated (30-60 minutes)
- [ ] Franco is available for testing

---

## Phase 1: Full Backup (Before Update)

### 1.1 Config Backup
```bash
# Create timestamped backup
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup.20260308-$(date +%H%M%S)

# Verify backup
ls -la ~/.openclaw/openclaw.json.backup.*
```

### 1.2 Credentials Backup
```bash
# Backup credentials directory
tar czf ~/.openclaw/credentials-backup-$(date +%Y%m%d).tar.gz ~/.openclaw/credentials/ ~/.openclaw/identity/

# Verify backup
ls -la ~/.openclaw/credentials-backup-*.tar.gz
```

### 1.3 Workspace Backup
```bash
# Already backed up via daily git backup @ 23:00
# Verify last backup was successful
cd ~/Mac-Mini-Obsidian-Vault/1. openclaw && git log --oneline -5
```

### 1.4 System State Snapshot
```bash
# Record current state
openclaw status > /tmp/pre-update-status.txt
openclaw update status > /tmp/pre-update-channel.txt
openclaw doctor > /tmp/pre-update-doctor.txt 2>&1
```

---

## Phase 2: Safest Update Path

### Option A: Using `openclaw update` (Recommended)
```bash
# This will:
# 1. Update via pnpm/npm
# 2. Run doctor
# 3. Restart gateway by default

# Step 1: Backup is already done above

# Step 2: Run update with no-restart first (safer)
openclaw update --no-restart --yes

# Step 3: Verify update succeeded
openclaw --version

# Step 4: Run doctor to check health
openclaw doctor

# Step 5: If doctor looks good, restart gateway
openclaw gateway restart

# Step 6: Verify gateway running
openclaw status
```

### Option B: Manual NPM Update (if Option A fails)
```bash
# Alternative manual approach
openclaw gateway stop
sleep 5

# Update via pnpm
pnpm add -g openclaw@latest

# Or via npm if pnpm not working
npm i -g openclaw@latest

# Run doctor
openclaw doctor

# Restart
openclaw gateway restart

# Verify
openclaw status
openclaw --version
```

### Option C: Re-run Installer (nuclear option)
```bash
# If all else fails, re-run the installer
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard
openclaw doctor
openclaw gateway restart
```

---

## Phase 3: Post-Update Verification

### Core Functionality
- [ ] Gateway running: `openclaw status`
- [ ] Version correct: `openclaw --version` (should show 2026.3.7)
- [ ] No config errors in logs: `tail -50 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log`

### Channel Testing
- [ ] Webchat accessible: http://127.0.0.1:18789/
- [ ] iMessage still working (send test message)
- [ ] Discord bot still responding

### System Tests
- [ ] Can start new session
- [ ] Tools load correctly
- [ ] Skills working (test one: `weather`)

---

## Phase 4: Automation System Verification

### 4.1 Check All LaunchAgents Still Loaded
```bash
launchctl list | grep -E "(openclaw|jarvis)"
```

Expected:
- ai.openclaw.gateway
- ai.thejarvis.openclaw.daily-backup
- ai.thejarvis.openclaw.daily-status
- ai.thejarvis.openclaw.discord-retro
- ai.thejarvis.openclaw.discrawl-tail
- ai.thejarvis.openclaw.qmd-maint

### 4.2 Verify Automation Scripts Still Work
```bash
# Test Discord bot
ps aux | grep "discord-capture/bot.js"

# Test Discrawl
ps aux | grep "discrawl tail"

# Test QMD
qmd status
```

### 4.3 Verify Config Perserved
```bash
# Check all critical settings
grep -E "(discord|imessage|agent)" ~/.openclaw/openclaw.json | head -20
```

---

## Rollback Plan (If Things Go Wrong)

### Immediate Rollback
```bash
# Option 1: Pin to previous version
npm i -g openclaw@2026.2.14
openclaw gateway restart

# Option 2: Restore config backup
cp ~/.openclaw/openclaw.json.backup.20260308-XXXXXX ~/.openclaw/openclaw.json
openclaw gateway restart

# Option 3: Stop and use iMessage to get help
openclaw gateway stop
# Text +16138893035 for backup assistance
```

### Full Restoration Steps
```bash
# If complete failure:
# 1. Stop gateway
openclaw gateway stop

# 2. Restore from backup
cp ~/.openclaw/openclaw.json.backup.20260308-XXXXXX ~/.openclaw/openclaw.json

# 3. Reinstall previous version
npm i -g openclaw@2026.2.14

# 4. Run doctor
openclaw doctor

# 5. Restart
openclaw gateway restart

# 6. Verify
openclaw status
```

---

## Testing Sandbox Strategy

Since this is a critical production system, here's the safest approach:

### Before Starting:
1. Complete all backups (Phase 1)
2. Document current working state
3. Notify Franco that update is starting
4. Have iMessage ready as backup

### During Update:
1. Use `--no-restart` flag first
2. Verify new version installed
3. Check doctor output
4. Only then restart gateway
5. Test webchat immediately
6. Verify iMessage still works

### After Update:
1. Wait 10 minutes for any startup issues
2. Check logs for errors
3. Verify all automation still running
4. Confirm Discord bot, Discrawl, QMD operational

---

## Known Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Config migration failure | Backup exists, can restore |
| Gateway won't restart | iMessage backup, can restart manually |
| Discord bot breaks | LaunchAgent will auto-restart it |
| LaunchAgents lost | Documented list above, can reload |
| Skills stop working | Run `openclaw doctor --fix` |

---

## Decision: NOW or LATER?

### Update NOW if:
- Franco has 30-60 minutes available
- No critical tasks pending
- iMessage confirmed working
- All backups complete

### Update LATER if:
- Franco's focused on other work
- Any uncertainty about time
- Want to schedule for low-usage period (late evening)

### My Recommendation:
Given we have:
- ✅ Complete backup system
- ✅ iMessage backup channel
- ✅ Documented rollback
- ✅ All automation running well

We can proceed **NOW** with the safetest option (`openclaw update --no-restart`).

---

## Execute Update

**When ready, run:**

```bash
# Step 1: Backup (already done)
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup.20260308-$(date +%H%M%S)

# Step 2: Update without restart
openclaw update --no-restart --yes

# Step 3: Verify version
openclaw --version

# Step 4: Run doctor
openclaw doctor

# Step 5: If all good, restart
openclaw gateway restart

# Step 6: Final verification
openclaw status
```

---

**Prepared by:** Jarvis  
**Date:** 2026-03-08  
**Current Status:** Ready to proceed when Franco confirms
