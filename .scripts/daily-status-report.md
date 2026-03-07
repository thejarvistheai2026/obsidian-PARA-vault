# Daily Status Report System

**Status:** ✅ Active  
**Deployed:** 2026-03-07  
**Schedule:** Daily @ 08:00  
**Recipient:** +16138893035 (iMessage)  

## Overview

Automated daily iMessage with system health status. Reports on all running services, last run times, and upcoming jobs.

## Architecture

```
LaunchAgent @ 08:00 → daily-status-report.sh → iMessage → Franco
```

## Components

### 1. Status Report Script
- **Location:** `.scripts/daily-status-report.sh`
- **Sends to:** +16138893035 (Franco's iPhone)
- **Format:** Plain text iMessage

### 2. LaunchAgent
- **File:** `.launchagents/ai.thejarvis.openclaw.daily-status.plist`
- **Schedule:** Daily @ 08:00
- **Logs:** `daily-status.log`, `daily-status.error`

## Report Contents

### System Health Checks
- 🤖 Discord Bot (running/stopped + PID)
- 📥 Last Discord Capture (today/date/count)
- 📰 Newsletter (completed/running/idle)
- 💬 Discord Retro (completed/running/idle)
- 💾 Daily Backup (today/last run)
- 🌐 OpenClaw Gateway (running/check)

### Schedule Overview
- Shows all job times
- Highlights today's scheduled jobs

## Sample Report

```
Daily System Status - Saturday, Mar 7

Discord Bot: ✅ Running (PID: 68868)
Last Capture: ✅ Today (2 msgs)

Newsletter: ⏸️ Idle
   (Not scheduled)

Discord Retro: ⏸️ Idle
   (Not scheduled)

Daily Backup: ✅ Enabled

OpenClaw Gateway: ✅ Running

Next Jobs:
- Newsletter: Sun/Thu @ 09:00
- Discord Retro: Sun/Thu @ 22:00  
- This Report: Daily @ 08:00

Reply STOP to pause reports.
```

## Files

```
.launchagents/ai.thejarvis.openclaw.daily-status.plist  # LaunchAgent
.scripts/daily-status-report.sh                          # Report script
memory/daily-reports/YYYY-MM-DD-status.txt              # Archive
```

## Management Commands

```bash
# Check LaunchAgent
launchctl list | grep daily-status

# Force run now
cd ~/Mac-Mini-Obsidian-Vault/1.\ openclaw/.scripts && bash daily-status-report.sh

# View logs
tail -20 ~/Mac-Mini-Obsidian-Vault/1.\ openclaw/daily-status.log
tail -20 ~/Mac-Mini-Obsidian-Vault/1.\ openclaw/daily-status.error
```

## Dependencies

- iMessage CLI (`imsg` via Homebrew)
- Full Disk Access + Automation permissions (Messages.app)
- Paired iPhone: +16138893035

## Complete Schedule

| Time | Sun | Mon | Tue | Wed | Thu | Fri | Sat |
|------|-----|-----|-----|-----|-----|-----|-----|
| **08:00** | 📊 Status | 📊 Status | 📊 Status | 📊 Status | 📊 Status | 📊 Status | 📊 Status |
| **09:00** | 📰 News | | | | 📰 News | | |
| **22:00** | 💬 Retro | | | | 💬 Retro | | |
| **23:00** | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup |

## Related Systems

- Discord Retro System — monitored
- Newsletter System — monitored
- Daily Backup — monitored
- OpenClaw Gateway — monitored

---
**Last Updated:** 2026-03-07
