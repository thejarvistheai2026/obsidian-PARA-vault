#!/usr/bin/env bash
#
# QMD Maintenance Script
# - Daily: Update index (incremental)
# - Weekly (Sunday): Full re-embedding
#

set -e

QMD_BIN="/Users/jarvis/.bun/bin/qmd"
LOG_DIR="/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/memory/qmd-logs"
LOG_FILE="$LOG_DIR/$(date +%Y-%m-%d).log"
DAY_OF_WEEK=$(date +%u)  # 1=Monday, 7=Sunday

mkdir -p "$LOG_DIR"

echo "QMD Maintenance Started: $(date)" >> "$LOG_FILE"

# Always update indexes (incremental)
echo "Running qmd update (incremental)..." >> "$LOG_FILE"
$QMD_BIN update >> "$LOG_FILE" 2>&1 || true

# On Sunday, do full re-embedding
if [[ "$DAY_OF_WEEK" == "7" ]]; then
    echo "Sunday detected - running full re-embedding..." >> "$LOG_FILE"
    $QMD_BIN embed -f >> "$LOG_FILE" 2>&1 || true
    echo "Full re-embedding complete" >> "$LOG_FILE"
else
    # On other days, just update embeddings for new/changed files
    echo "Running qmd embed (incremental)..." >> "$LOG_FILE"
    $QMD_BIN embed >> "$LOG_FILE" 2>&1 || true
fi

# Get current status
echo "QMD Status:" >> "$LOG_FILE"
$QMD_BIN status >> "$LOG_FILE" 2>&1 || true
echo "QMD Maintenance Completed: $(date)" >> "$LOG_FILE"

# Output for reporting
$QMD_BIN status 2>/dev/null | grep -E "(Total:|Vectors:|Updated:)" | head -3 || echo "QMD: Check status manually"
