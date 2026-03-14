#!/bin/bash
#
# Queue Processor - Agent Integration Script
# This script coordinates between the queue and the agent for full content capture
#

QUEUE_DIR="/Users/ava/.openclaw/workspace/workflows/queue"
PENDING_FILE="$QUEUE_DIR/pending.json"
PROCESSED_FILE="$QUEUE_DIR/processed.json"
FAILED_FILE="$QUEUE_DIR/failed.json"

show_help() {
    echo "Queue Processor - Agent Integration"
    echo ""
    echo "Usage:"
    echo "  $0 list              - List pending links (for agent to capture)"
    echo "  $0 mark-done <url>   - Mark a link as successfully processed"
    echo "  $0 mark-fail <url> <error> - Mark a link as failed"
    echo "  $0 status            - Show queue status"
    echo ""
}

list_pending() {
    if [ ! -f "$PENDING_FILE" ]; then
        echo "[]"
        return
    fi
    
    # Output pending links as JSON array
    jq -c '.links' "$PENDING_FILE"
}

mark_done() {
    local url="$1"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    # Read the link from pending
    local link=$(jq --arg url "$url" '.links[] | select(.url == $url)' "$PENDING_FILE")
    
    if [ -z "$link" ]; then
        echo "Error: Link not found in pending queue: $url"
        return 1
    fi
    
    # Remove from pending
    jq --arg url "$url" '.links = [.links[] | select(.url != $url)]' "$PENDING_FILE" > "$PENDING_FILE.tmp"
    mv "$PENDING_FILE.tmp" "$PENDING_FILE"
    
    # Add to processed
    local completed_link=$(echo "$link" | jq --arg ts "$timestamp" '. + {completed: $ts, status: "success"}')
    
    if [ -f "$PROCESSED_FILE" ]; then
        jq --argjson link "$completed_link" '.links += [$link]' "$PROCESSED_FILE" > "$PROCESSED_FILE.tmp"
    else
        echo "{\"links\": [$completed_link], \"lastUpdated\": \"$timestamp\"}" > "$PROCESSED_FILE.tmp"
    fi
    mv "$PROCESSED_FILE.tmp" "$PROCESSED_FILE"
    
    echo "✓ Marked as processed: $url"
}

mark_fail() {
    local url="$1"
    local error="$2"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    # Read the link from pending
    local link=$(jq --arg url "$url" '.links[] | select(.url == $url)' "$PENDING_FILE")
    
    if [ -z "$link" ]; then
        echo "Error: Link not found in pending queue: $url"
        return 1
    fi
    
    # Remove from pending
    jq --arg url "$url" '.links = [.links[] | select(.url != $url)]' "$PENDING_FILE" > "$PENDING_FILE.tmp"
    mv "$PENDING_FILE.tmp" "$PENDING_FILE"
    
    # Add to failed
    local failed_link=$(echo "$link" | jq --arg ts "$timestamp" --arg err "$error" '. + {completed: $ts, status: "failed", error: $err}')
    
    if [ -f "$FAILED_FILE" ]; then
        jq --argjson link "$failed_link" '.links += [$link]' "$FAILED_FILE" > "$FAILED_FILE.tmp"
    else
        echo "{\"links\": [$failed_link], \"lastUpdated\": \"$timestamp\"}" > "$FAILED_FILE.tmp"
    fi
    mv "$FAILED_FILE.tmp" "$FAILED_FILE"
    
    echo "✗ Marked as failed: $url"
}

show_status() {
    local pending=0
    local processed=0
    local failed=0
    
    if [ -f "$PENDING_FILE" ]; then
        pending=$(jq '.links | length' "$PENDING_FILE")
    fi
    
    if [ -f "$PROCESSED_FILE" ]; then
        processed=$(jq '.links | length' "$PROCESSED_FILE")
    fi
    
    if [ -f "$FAILED_FILE" ]; then
        failed=$(jq '.links | length' "$FAILED_FILE")
    fi
    
    echo "📊 Queue Status"
    echo "  ⏳ Pending: $pending"
    echo "  ✓ Processed: $processed"
    echo "  ✗ Failed: $failed"
}

case "${1:-}" in
    list)
        list_pending
        ;;
    mark-done)
        if [ -z "${2:-}" ]; then
            echo "Usage: $0 mark-done <url>"
            exit 1
        fi
        mark_done "$2"
        ;;
    mark-fail)
        if [ -z "${2:-}" ] || [ -z "${3:-}" ]; then
            echo "Usage: $0 mark-fail <url> <error>"
            exit 1
        fi
        mark_fail "$2" "$3"
        ;;
    status)
        show_status
        ;;
    *)
        show_help
        ;;
esac
