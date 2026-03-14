#!/bin/bash

# Process links from the capture queue
# Usage: ./queue-process.sh [--limit N]

QUEUE_FILE="/Users/ava/.openclaw/workspace/workflows/queue/pending.json"
PROCESSED_FILE="/Users/ava/.openclaw/workspace/workflows/queue/processed.json"
FAILED_FILE="/Users/ava/.openclaw/workspace/workflows/queue/failed.json"
LIMIT="${2:-9999}"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "Processing queue..."

# Get queue size
QUEUE_SIZE=$(jq '.links | length' "$QUEUE_FILE")
echo "Found $QUEUE_SIZE links in queue"

if [ "$QUEUE_SIZE" -eq 0 ]; then
    echo "Queue is empty. Nothing to process."
    exit 0
fi

# Process links (up to limit)
TO_PROCESS=$(jq ".links[:$LIMIT]" "$QUEUE_FILE")
REMAINING=$(jq ".links[$LIMIT:]" "$QUEUE_FILE")

# Output file for processing
OUTPUT_FILE="/tmp/queue-process-$(date +%s).json"
echo "$TO_PROCESS" > "$OUTPUT_FILE"

echo "Processing $(echo "$TO_PROCESS" | jq 'length') links..."
echo ""
echo "Links to process:"
echo "$TO_PROCESS" | jq -r '.[].url'
echo ""
echo "Run the capture workflow for each link above."
echo ""
echo "After processing, run:"
echo "  ./workflows/scripts/queue-archive.sh $OUTPUT_FILE"

# Note: Actual processing would be done by the agent
# This script prepares the batch for processing