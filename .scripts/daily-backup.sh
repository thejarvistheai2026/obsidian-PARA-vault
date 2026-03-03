#!/bin/bash

# Daily Backup Script for Obsidian PARA Vault
# Backs up 1. openclaw, 2. the-brain, 4. CRM to separate GitHub repos
# Runs at 23:00 daily via LaunchAgent

set -e

LOG_FILE="/tmp/openclaw-backup.log"
ERROR_LOG="/tmp/openclaw-backup-error.log"
DATE=$(date '+%Y-%m-%d %H:%M')
VAULT_ROOT="/Users/jarvis/Mac-Mini-Obsidian-Vault"

echo "=== Backup started at $DATE ===" >> "$LOG_FILE"

# Function to backup a folder to its repo
backup_folder() {
    local folder_path="$1"
    local repo_name="$2"
    local folder_name="$3"
    
    cd "$folder_path" || return 1
    
    # Check for changes
    if [[ -n $(git status --porcelain) ]]; then
        git add -A
        git commit -m "Daily backup - $DATE" >> "$LOG_FILE" 2>> "$ERROR_LOG" || true
        git push origin main >> "$LOG_FILE" 2>> "$ERROR_LOG" || true
        echo "✅ $folder_name: backed up at $(date '+%H:%M')" >> "$LOG_FILE"
    else
        echo "ℹ️ $folder_name: no changes" >> "$LOG_FILE"
    fi
}

# 1. Backup 1. openclaw (agent workspace)
echo "[1/4] Backing up 1. openclaw..." >> "$LOG_FILE"
backup_folder "$VAULT_ROOT/1. openclaw" "openclaw-obsidian-workspace-backup" "1. openclaw"

# 2. Backup 2. the-brain (knowledge base)
echo "[2/4] Backing up 2. the-brain..." >> "$LOG_FILE"
backup_folder "$VAULT_ROOT/2. the-brain" "PARA-Obsidian-vault-backup" "2. the-brain"

# 3. Backup 4. CRM (contacts/people)
echo "[3/4] Backing up 4. CRM..." >> "$LOG_FILE"
backup_folder "$VAULT_ROOT/4. CRM" "obsidian-crm" "4. CRM"

# 4. Backup OpenClaw Config (sanitized)
echo "[4/4] Backing up OpenClaw config..." >> "$LOG_FILE"
mkdir -p "$VAULT_ROOT/1. openclaw/openclaw-config"
cp ~/.openclaw/openclaw.json "$VAULT_ROOT/1. openclaw/openclaw-config/openclaw.json"

# Sanitize secrets
sed -i '' 's/"token": "[^"]*"/"token": "[REDACTED]"/g' "$VAULT_ROOT/1. openclaw/openclaw-config/openclaw.json"
sed -i '' 's/"apiKey": "[^"]*"/"apiKey": "[REDACTED]"/g' "$VAULT_ROOT/1. openclaw/openclaw-config/openclaw.json"

# Commit if changed
cd "$VAULT_ROOT/1. openclaw"
if [[ -n $(git status --porcelain openclaw-config/) ]]; then
    git add openclaw-config/
    git commit -m "OpenClaw config backup - $DATE" >> "$LOG_FILE" 2>> "$ERROR_LOG" || true
    git push origin main >> "$LOG_FILE" 2>> "$ERROR_LOG" || true
    echo "✅ OpenClaw config: backed up" >> "$LOG_FILE"
else
    echo "ℹ️ OpenClaw config: no changes" >> "$LOG_FILE"
fi

echo "=== Backup completed ===" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
