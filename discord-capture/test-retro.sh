#!/usr/bin/env bash
#
# Manual test of retro generator
# Usage: ./test-retro.sh [YYYY-MM-DD]
# Without date, uses today's retro file

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RETRO_DIR="${SCRIPT_DIR}/../memory/discord-retro"

echo "=== Discord Retro Generator Test ==="
echo ""

# Check if Ollama is running
if ! curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo "❌ Ollama is not running. Start it with:"
    echo "   ollama serve"
    exit 1
fi
echo "✓ Ollama is running"

# Check if model exists
if ! curl -s http://localhost:11434/api/tags | grep -q "kimi-k2.5"; then
    echo "⚠ Model kimi-k2.5 not found. Pulling..."
    ollama pull kimi-k2.5
fi
echo "✓ Model kimi-k2.5 is available"

# Run generator
echo ""
echo "Running retro generator..."
echo ""

./generate-retro.sh

# Show result
LATEST_RETRO=$(ls -t "$RETRO_DIR"/*.md 2>/dev/null | head -1)
if [[ -n "$LATEST_RETRO" ]]; then
    echo ""
    echo "=== Generated Retro Preview ==="
    echo ""
    head -50 "$LATEST_RETRO"
else
    echo "⚠ No retro file found in $RETRO_DIR"
fi

echo ""
echo "✓ Full retro saved to: ${RETRO_DIR}/<date>.md"
