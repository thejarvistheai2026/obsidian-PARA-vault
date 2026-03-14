#!/bin/bash

# Archive processed links and update queue
# Usage: ./queue-archive.sh /tmp/queue-process-XXX.json

QUEUE_FILE="/Users/ava/.openclaw/workspace/workflows/queue/pending.json"
PROCESSED_FILE="/Users/ava/.openclaw/workspace/workflows/queue/processed.json"
FAILED_FILE="/Users/ava/.openclaw/workspace/workflows/queue/failed.json"
PROCESS_LOG="$1"

if [ -z "$PROCESS_LOG" ]; then
    echo "Usage: ./queue-archive.sh /tmp/queue-process-XXX.json"
    exit 1
fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Read processed URLs
PROCESSED_URLS=$(jq -r '.[].url' "$PROCESS_LOG" 2>/dev/null || echo "")

if [ -z "$PROCESSED_URLS" ]; then
    echo "No URLs found in process log"
    exit 1
fi

# Move from pending to processed
for url in $PROCESSED_URLS; do
    # Find and remove from pending
    ENTRY=$(jq --arg url "$url" '.links[] | select(.url == $url)' "$QUEUE_FILE")
    
    if [ -n "$ENTRY" ]; then
        # Add to processed with completed timestamp
        COMPLETED_ENTRY=$(echo "$ENTRY" | jq --arg ts "$TIMESTAMP" '. + {completed: $ts, status: "success"}')
        jq --argjson entry "$COMPLETED_ENTRY" '.links += [$entry]' "$PROCESSED_FILE" > "${PROCESSED_FILE}.tmp" && mv "${PROCESSED_FILE}.tmp" "$PROCESSED_FILE"
        
        # Remove from pending
        jq --arg url "$url" 'del(.links[] | select(.url == $url))' "$QUEUE_FILE" > "${QUEUE_FILE}.tmp" && mv "${QUEUE_FILE}.tmp" "$QUEUE_FILE"
        
        echo "✓ Archived: $url"
    fi
done

# Update timestamps
jq '.lastUpdated = "'"$TIMESTAMP"'"' "$QUEUE_FILE" > "${QUEUE_FILE}.tmp" && mv "${QUEUE_FILE}.tmp" "$QUEUE_FILE"
jq '.lastUpdated = "'"$TIMESTAMP"'"' "$PROCESSED_FILE" > "${PROCESSED_FILE}.tmp" && mv "${PROCESSED_FILE}.tmp" "$PROCESSED_FILE"

# Show status
PENDING_COUNT=$(jq '.links | length' "$QUEUE_FILE")
PROCESSED_COUNT=$(jq '.links | length' "$PROCESSED_FILE")

echo ""
echo "Queue status:"
echo "  Pending: $PENDING_COUNT"
echo "  Processed: $PROCESSED_COUNT"

# Cleanup
rm -f "$PROCESS_LOG"