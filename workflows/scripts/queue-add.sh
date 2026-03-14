#!/bin/bash

# Add a link to the capture queue
# Usage: ./queue-add.sh "URL" ["optional note"]

QUEUE_FILE="/Users/ava/.openclaw/workspace/workflows/queue/pending.json"
URL="$1"
NOTE="${2:-}"

if [ -z "$URL" ]; then
    echo "Usage: ./queue-add.sh \"https://example.com\" [\"optional note\"]"
    exit 1
fi

# Generate timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Create new entry
NEW_ENTRY=$(cat <<EOF
{
  "url": "$URL",
  "added": "$TIMESTAMP",
  "note": "$NOTE",
  "source": "manual",
  "priority": "normal"
}
EOF
)

# Add to queue (requires jq)
if command -v jq &> /dev/null; then
    jq --argjson entry "$NEW_ENTRY" '.links += [$entry] | .lastUpdated = "'"$TIMESTAMP"'"' "$QUEUE_FILE" > "${QUEUE_FILE}.tmp" && mv "${QUEUE_FILE}.tmp" "$QUEUE_FILE"
    echo "✓ Added to queue: $URL"
else
    echo "Error: jq is required. Install with: brew install jq"
    exit 1
fi

# Show queue count
COUNT=$(jq '.links | length' "$QUEUE_FILE")
echo "Queue size: $COUNT links pending"