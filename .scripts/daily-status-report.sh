#!/usr/bin/env bash
#
# Daily Status Report - Sends system health summary via iMessage
# Run via LaunchAgent daily @ 08:00
#

set -e

# Phone number to text (Franco)
RECIPIENT="+16138893035"

# System paths
OPENCLAW_DIR="/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw"
NEWSLETTER_DIR="/Users/jarvis/Mac-Mini-Obsidian-Vault/3. code/newsletter-system"
BACKUP_LOG="/tmp/openclaw-backup.log"
NEWSLETTER_LOG="/tmp/openclaw/newsletter.log"
RETRO_LOG="${OPENCLAW_DIR}/discord-capture/retro.log"

# Get today's date
TODAY=$(date +%Y-%m-%d)
DAY_OF_WEEK=$(date +%u)  # 1=Monday, 7=Sunday
DAY_NAME=$(date +%A)

# Function to check if job ran today - simplified for BSD stat
check_ran_tODAY() {
    local log_file="$1"
    if [[ -f "$log_file" ]]; then
        # Get modification time in YYYY-MM-DD format using ls instead
        local mod_time
        mod_time=$(ls -ld "$log_file" | awk '{print $6, $7, $8}')
        # Convert to date - this is approximate
        if [[ "$mod_time" == *"$(date +'%b')"*"$(date +'%e')"* ]]; then
            echo "✅ Today"
        else
            echo "⚠️ Last run: $mod_time"
        fi
    else
        echo "❌ No log"
    fi
}

# Check Discord Bot Status
BOT_PID=$(pgrep -f "node.*bot.js" || echo "")
if [[ -n "$BOT_PID" ]]; then
    BOT_STATUS="✅ Running (PID: $BOT_PID)"
else
    BOT_STATUS="❌ Stopped"
fi

# Check last Discord capture
LAST_CAPTURE="None"
if [[ -d "${OPENCLAW_DIR}/discord-capture/raw" ]]; then
    latest_file=$(ls -t "${OPENCLAW_DIR}/discord-capture/raw/" 2>/dev/null | grep "\.jsonl$" | head -1)
    if [[ -n "$latest_file" ]]; then
        CAPTURE_DATE=$(echo "$latest_file" | sed 's/\.jsonl$//')
        if [[ "$CAPTURE_DATE" == "$TODAY" ]]; then
            MSG_COUNT=$(wc -l < "${OPENCLAW_DIR}/discord-capture/raw/$latest_file" 2>/dev/null || echo "0")
            LAST_CAPTURE="✅ Today ($MSG_COUNT msgs)"
        else
            LAST_CAPTURE="⚠️ $CAPTURE_DATE"
        fi
    fi
fi

# Check Newsletter (only relevant Sun/Thu)
if [[ "$DAY_OF_WEEK" == "7" ]] || [[ "$DAY_OF_WEEK" == "4" ]]; then
    NEWSLETTER_TODAY="Scheduled today @ 09:00"
    NEWSLETTER_STATUS="⏳ Pending"
else
    NEWSLETTER_TODAY="Not scheduled"
    NEWSLETTER_STATUS="⏸️ Idle"
fi

# Check Discord Retro (only relevant Sun/Thu)
if [[ "$DAY_OF_WEEK" == "7" ]] || [[ "$DAY_OF_WEEK" == "4" ]]; then
    RETRO_TODAY="Scheduled today @ 22:00"
    RETRO_STATUS="⏳ Pending"
else
    RETRO_TODAY="Not scheduled"
    RETRO_STATUS="⏸️ Idle"
fi

# Check Daily Backup - simplified
if [[ -f "$BACKUP_LOG" ]]; then
    BACKUP_STATUS="✅ Enabled"
else
    BACKUP_STATUS="⚠️ Check"
fi

# Check OpenClaw Gateway
GATEWAY_PID=$(launchctl list | grep "ai.openclaw.gateway" | awk '{print $1}')
if [[ -n "$GATEWAY_PID" ]] && [[ "$GATEWAY_PID" != "-" ]]; then
    GATEWAY_STATUS="✅ Running"
else
    GATEWAY_STATUS="⚠️ Check manually"
fi

# Build the message (use plain ASCII to avoid encoding issues)
REPORT="Daily System Status - $DAY_NAME, $(date '+%b %d')

Discord Bot: $BOT_STATUS
Last Capture: $LAST_CAPTURE

Newsletter: $NEWSLETTER_STATUS
   ($NEWSLETTER_TODAY)

Discord Retro: $RETRO_STATUS
   ($RETRO_TODAY)

Daily Backup: $BACKUP_STATUS

OpenClaw Gateway: $GATEWAY_STATUS

Next Jobs:
- Newsletter: Sun/Thu @ 09:00
- Discord Retro: Sun/Thu @ 22:00  
- This Report: Daily @ 08:00

Reply STOP to pause reports."

# Send via iMessage
if command -v imsg >/dev/null 2>&1; then
    imsg send --to "$RECIPIENT" --text "$REPORT"
    echo "Sent to $RECIPIENT at $(date)"
else
    echo "imsg not installed"
    echo "$REPORT"
fi

# Save to file
mkdir -p "${OPENCLAW_DIR}/memory/daily-reports"
echo "$REPORT" > "${OPENCLAW_DIR}/memory/daily-reports/${TODAY}-status.txt"
