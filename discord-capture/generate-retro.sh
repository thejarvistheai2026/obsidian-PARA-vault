#!/usr/bin/env bash
#
# Discord Retrospective Generator
# Runs twice weekly (Sun/Thu) via LaunchAgent
# Generates AI-powered retrospectives from captured Discord messages
#

set -e

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RAW_DIR="${SCRIPT_DIR}/raw"
RETRO_DIR="${SCRIPT_DIR}/../memory/discord-retro"
MARKER_FILE="${SCRIPT_DIR}/marker.json"
OLLAMA_URL="http://localhost:11434"
OLLAMA_MODEL="kimi-k2.5:cloud"

# Ensure directories exist
mkdir -p "$RETRO_DIR"

# Get last run timestamp (default: 1970-01-01)
if [[ -f "$MARKER_FILE" ]]; then
    LAST_RUN=$(jq -r '.lastRun // "1970-01-01T00:00:00Z"' "$MARKER_FILE" 2>/dev/null || echo "1970-01-01T00:00:00Z")
else
    LAST_RUN="1970-01-01T00:00:00Z"
fi

echo "Last retrospective run: $LAST_RUN"

# Collect all raw JSONL files since last run
COLLECTED=""
TODAY=$(date +%Y-%m-%d)

for file in "$RAW_DIR"/*.jsonl; do
    [[ -f "$file" ]] || continue
    
    # Extract date from filename
    FILE_DATE=$(basename "$file" .jsonl)
    
    # Skip if file date is before last run
    if [[ "$FILE_DATE" < "${LAST_RUN%%T*}" ]]; then
        continue
    fi
    
    COLLECTED="${COLLECTED}${file} "
done

if [[ -z "$COLLECTED" ]]; then
    echo "No new messages since last run. Exiting."
    exit 0
fi

echo "Processing files: $COLLECTED"

# Combine all messages into temporary file
TEMP_FILE=$(mktemp)
trap "rm -f \"$TEMP_FILE\"" EXIT

for file in "$RAW_DIR"/*.jsonl; do
    [[ -f "$file" ]] || continue
    cat "$file" >> "$TEMP_FILE"
    echo "" >> "$TEMP_FILE"  # Ensure newline between files
done

# Convert JSONL to readable text format for better AI summarization
MESSAGES_FILE=$(mktemp)
trap "rm -f \"$MESSAGES_FILE\"" EXIT

echo "Converting to readable format..."
while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    
    TIMESTAMP=$(echo "$line" | jq -r '.timestamp // empty')
    CHANNEL=$(echo "$line" | jq -r '.channel_name // empty')
    AUTHOR=$(echo "$line" | jq -r '.author // empty')
    CONTENT=$(echo "$line" | jq -r '.content // empty')
    TYPE=$(echo "$line" | jq -r '.type // empty')
    
    if [[ -n "$TIMESTAMP" && -n "$CONTENT" ]]; then
        echo "[$TIMESTAMP] $AUTHOR in #$CHANNEL ($TYPE): $CONTENT" >> "$MESSAGES_FILE"
    fi
done < "$TEMP_FILE"

# Prepare the prompt for Ollama
PROMPT_FILE=$(mktemp)
trap "rm -f $PROMPT_FILE" EXIT

cat > "$PROMPT_FILE" << 'EOF'
You are analyzing Discord conversations to create a retrospective summary.

CONTEXT: These are messages from a Discord server where Jarvis (an AI assistant) and his human (Jarvis/Franco) collaborate on projects.

INPUT: Below are Discord messages from the past few days. Create a structured retrospective.

MESSAGES:

EOF

cat "$MESSAGES_FILE" >> "$PROMPT_FILE"

cat >> "$PROMPT_FILE" << 'EOF'

OUTPUT FORMAT (Markdown):

# Discord Retro - [DATE RANGE]

## Summary
- Channels active: [list]
- Total messages: [count]
- Topics covered: [brief list]

## Conversations

### Topic: [Name] (#channel)
- **Context:** Brief description of what was discussed
- **Resolution:** What was decided or accomplished
- **Friction:** Any challenges or repeated clarifications needed
- **Learning:** Key takeaway or improvement idea

## Friction Points
1. [Pattern noticed - e.g., "Had to clarify X multiple times"]

## Decisions Made
- ✅ [Decision with brief context]

## Improvements to Try
- [ ] [Actionable suggestion based on patterns]

INSTRUCTIONS:
- Be concise but specific
- Focus on actionable insights, not just summaries
- Identify recurring themes
- Note when something took multiple back-and-forths
- Suggest documentation or process improvements

Now generate the retrospective in the exact format above:
EOF

# Call Ollama API
echo "Calling Ollama ($OLLAMA_MODEL) for summarization..."

RESPONSE_FILE=$(mktemp)
trap "rm -f $RESPONSE_FILE" EXIT

# Build request JSON
PROMPT_ESCAPED=$(jq -Rs . < "$PROMPT_FILE")
cat > "$TEMP_FILE.request.json" << EOJSON
{
    "model": "$OLLAMA_MODEL",
    "prompt": $PROMPT_ESCAPED,
    "stream": false
}
EOJSON

curl -s "$OLLAMA_URL/api/generate" \
    -X POST \
    -H "Content-Type: application/json" \
    -d "@$TEMP_FILE.request.json" > "$RESPONSE_FILE"

# Extract the response
RETRO_CONTENT=$(jq -r '.response // empty' "$RESPONSE_FILE")

if [[ -z "$RETRO_CONTENT" ]]; then
    echo "❌ Failed to get response from Ollama"
    echo "Debug output:"
    cat "$RESPONSE_FILE"
    exit 1
fi

# Generate output filename
RETRO_DATE=$(date +%Y-%m-%d)
OUTPUT_FILE="${RETRO_DIR}/${RETRO_DATE}.md"

# Add metadata header
cat > "$OUTPUT_FILE" << EOF
# Discord Retro - ${RETRO_DATE}

**Period:** ${LAST_RUN%%T*} to ${TODAY}
**Generated:** $(date)
**Model:** ${OLLAMA_MODEL}

EOF

# Append the generated content
echo "$RETRO_CONTENT" >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "---" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "## Raw Data" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "- Source files: $(echo $COLLECTED | wc -w)" >> "$OUTPUT_FILE"
echo "- Messages processed: $(wc -l < $MESSAGES_FILE)" >> "$OUTPUT_FILE"

echo "✓ Retro saved to: $OUTPUT_FILE"

# Update marker file
jq -n "{lastRun: \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" > "$MARKER_FILE"
echo "✓ Updated marker: $(cat $MARKER_FILE)"

# Optional: Archive processed raw files (uncomment to enable)
# ARCHIVE_DIR="${RAW_DIR}/archive"
# mkdir -p "$ARCHIVE_DIR"
# for file in $COLLECTED; do
#     mv "$file" "$ARCHIVE_DIR/"
# done
# echo "✓ Archived raw files to: $ARCHIVE_DIR"

echo "Done!"
