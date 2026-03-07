#!/bin/bash
# Backfill Discord message history
# Usage: ./backfill.sh [days_back]
# Default: 30 days

DAYS=${1:-30}

echo "=========================================="
echo "Discord Historical Backfill"
echo "Fetching last $DAYS days..."
echo "=========================================="
echo ""

cd "$(dirname "$0")"

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "❌ Dependencies not installed."
    echo "   Run: npm install"
    exit 1
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found."
    echo "   Copy: cp .env.example .env"
    echo "   Edit: Add your DISCORD_TOKEN"
    exit 1
fi

echo "Starting backfill..."
echo "Press Ctrl+C to stop"
echo ""

node backfill-channel.js "$DAYS"

echo ""
echo "✅ Backfill complete!"
echo ""
echo "View captured messages:"
echo "  ls -lh raw/"
echo "  head raw/YYYY-MM-DD.jsonl"