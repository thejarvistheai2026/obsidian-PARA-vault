#!/usr/bin/env bash
#
# Extract Discord Insights from Retro
# Parses generated retro and saves structured learnings to discord-insights/

echo "Extracting insights from retro..."

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RETRO_DIR="${SCRIPT_DIR}/../memory/discord-retro"
INSIGHTS_DIR="/Users/jarvis/Mac-Mini-Obsidian-Vault/3. code/discord-insights"

# Get today's retro file
TODAY=$(date +%Y-%m-%d)
RETRO_FILE="${RETRO_DIR}/${TODAY}.md"

if [[ ! -f "$RETRO_FILE" ]]; then
    echo "No retro file found for today: $RETRO_FILE"
    exit 0
fi

echo "Found retro: $RETRO_FILE"

# Extract key information
YEAR=$(date +%Y)
MONTH=$(date +%B | tr '[:upper:]' '[:lower:]')
MONTH_NUM=$(date +%m)

# Create directory structure
TARGET_DIR="${INSIGHTS_DIR}/${YEAR}/${MONTH_NUM}-$(date +%B)"
mkdir -p "$TARGET_DIR"

# Generate insight file with YAML frontmatter
INSIGHT_FILE="${TARGET_DIR}/${TODAY}-discord-insights.md"

echo "Creating insight file: $INSIGHT_FILE"

# Extract sections from retro (simple parsing)
SUMMARY=$(grep -A 5 "^## Summary" "$RETRO_FILE" | tail -n +2 || echo "See full retro for details")
FRICTION=$(grep -A 10 "^## Friction Points" "$RETRO_FILE" | tail -n +2 | head -20 || echo "None noted")
DECISIONS=$(grep -A 5 "^## Decisions Made" "$RETRO_FILE" | tail -n +2 | head -10 || echo "None recorded")
IMPROVEMENTS=$(grep -A 10 "^## Improvements to Try" "$RETRO_FILE" | tail -n +2 | head -15 || echo "None suggested")

# Create the insight file
cat > "$INSIGHT_FILE" << EOF
---
date: ${TODAY}
retro_file: memory/discord-retro/${TODAY}.md
type: discord-insights
collection: discord-insights
tags: [retro, learning, discord]
---

# Discord Insights - ${TODAY}

**From:** [[${TODAY}-discord-retro|Full Retro]]  
**Generated:** $(date '+%Y-%m-%d %H:%M')

## Quick Summary

${SUMMARY}

## Key Friction Points

${FRICTION}

## Decisions Made

${DECISIONS}

## Improvements to Try

${IMPROVEMENTS}

## Full Context

See the complete retrospective: [[${TODAY}-discord-retro|${TODAY} Discord Retro]]

---

*This is an auto-extracted summary from Discord conversations. For full context and conversation threads, see the linked retrospective.*
EOF

echo "✓ Saved insights to: $INSIGHT_FILE"

# Also create/update a master index
MASTER_INDEX="${INSIGHTS_DIR}/README.md"

if [[ ! -f "$MASTER_INDEX" ]]; then
    cat > "$MASTER_INDEX" << 'EOF'
# Discord Insights Index

Auto-extracted learnings and insights from Discord conversations.

## How This Works

- **Observer Bot:** Captures Discord messages 24/7
- **AI Retros:** Generated Sun/Thu at 22:00
- **Insight Extraction:** Key learnings saved here for easy reference
- **QMD Indexed:** All insights searchable via `qmd search "term" -c discord-insights`

## Recent Insights

EOF
fi

# Add link to today's insight at the top of recent insights section
# (Using a temp file to avoid in-place editing issues)
TEMP_INDEX=$(mktemp)
head -15 "$MASTER_INDEX" > "$TEMP_INDEX"
echo "" >> "$TEMP_INDEX"
echo "### ${TODAY}" >> "$TEMP_INDEX"
echo "- [[${YEAR}/${MONTH_NUM}-$(date +%B)/${TODAY}-discord-insights|${TODAY} Insights]]" >> "$TEMP_INDEX"
echo "" >> "$TEMP_INDEX"

# Get the rest of the file after the "Recent Insights" header
tail -n +16 "$MASTER_INDEX" >> "$TEMP_INDEX" 2>/dev/null || true

mv "$TEMP_INDEX" "$MASTER_INDEX"
echo "✓ Updated master index: $MASTER_INDEX"

# Update QMD index
if command -v qmd >/dev/null 2>&1; then
    echo "Updating QMD index for discord-insights..."
    qmd update >/dev/null 2>&1 || echo "QMD update completed with warnings"
fi

echo "✓ Insight extraction complete!"
