#!/usr/bin/env bash
#
# Discord Retrospective System - Setup Script
# Run once to initialize everything

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAUNCHAGENTS_DIR="$HOME/Library/LaunchAgents"
PLIST_NAME="ai.thejarvis.openclaw.discord-retro.plist"

echo "=========================================="
echo "Discord Retrospective System Setup"
echo "=========================================="
echo ""

# Step 1: Install Node dependencies
echo "Step 1: Installing Node dependencies..."
cd "$SCRIPT_DIR"
if command -v npm >/dev/null 2>&1; then
    npm install
    echo "✓ Dependencies installed"
else
    echo "❌ npm not found. Please install Node.js first:"
    echo "   brew install node"
    exit 1
fi

# Step 2: Check Ollama
echo ""
echo "Step 2: Checking Ollama..."
if command -v ollama >/dev/null 2>&1; then
    echo "✓ Ollama found: $(ollama --version)"
    
    # Check if kimi-k2.5 is available
    if ollama list | grep -q "kimi-k2.5"; then
        echo "✓ Model kimi-k2.5 is available"
    else
        echo "⚠ Model kimi-k2.5 not found. Pulling..."
        ollama pull kimi-k2.5
        echo "✓ Model pulled"
    fi
else
    echo "⚠ Ollama not found. Please install:"
    echo "   brew install ollama"
    echo "   ollama serve &"
    echo "   ollama pull kimi-k2.5"
fi

# Step 3: Create .env file if missing
echo ""
echo "Step 3: Checking environment..."
if [[ ! -f "$SCRIPT_DIR/.env" ]]; then
    cp "$SCRIPT_DIR/.env.example" "$SCRIPT_DIR/.env"
    echo "✓ Created .env file from template"
    echo "⚠ IMPORTANT: Edit .env and add your Discord bot token!"
else
    echo "✓ .env file already exists"
fi

# Step 4: Update bot user ID in config
echo ""
echo "Step 4: Updating config..."
echo "⚠ You'll need to update config.json with your bot's user ID after setup"
echo "   Get it from: https://discord.com/developers/applications → Your App → OAuth2 → Client ID"

# Step 5: Install LaunchAgent
echo ""
echo "Step 5: Installing LaunchAgent..."
mkdir -p "$LAUNCHAGENTS_DIR"

# Remove old symlink if exists
if [[ -L "$LAUNCHAGENTS_DIR/$PLIST_NAME" ]]; then
    rm "$LAUNCHAGENTS_DIR/$PLIST_NAME"
fi

# Create symlink
ln -s "$SCRIPT_DIR/../.launchagents/$PLIST_NAME" "$LAUNCHAGENTS_DIR/$PLIST_NAME"
echo "✓ LaunchAgent symlinked"

# Load LaunchAgent
if launchctl list | grep -q "ai.thejarvis.openclaw.discord-retro"; then
    launchctl unload "$LAUNCHAGENTS_DIR/$PLIST_NAME" 2>/dev/null || true
fi

launchctl load -w "$LAUNCHAGENTS_DIR/$PLIST_NAME" 2>/dev/null || {
    echo "⚠ Failed to load LaunchAgent. You may need to manually load it:"
    echo "   launchctl load ~/Library/LaunchAgents/$PLIST_NAME"
}

# Step 6: Summary
echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Get Discord Bot Token:"
echo "   https://discord.com/developers/applications → New Application → Bot → Reset Token"
echo ""
echo "2. Edit .env and add your token:"
echo "   DISCORD_TOKEN=your_token_here"
echo ""
echo "3. Get Bot User ID and update config.json:"
echo "   https://discord.com/developers/applications → Your App → OAuth2 → Client ID"
echo ""
echo "4. Invite bot to your server with Message Content intent:"
echo "   https://discord.com/developers/applications → Your App → OAuth2 → URL Generator"
echo "   Scopes: bot, applications.commands"
echo "   Bot Permissions: Read Messages/View Channels, Read Message History"
echo ""
echo "5. Start the listener:"
echo "   cd $SCRIPT_DIR && node bot.js"
echo ""
echo "📊 Schedule:"
echo "   - Daily capture: Continuous (while bot.js runs)"
echo "   - Retrospectives: Sunday + Thursday @ 22:00 via LaunchAgent"
echo ""
echo "📁 Output:"
echo "   - Raw logs: $SCRIPT_DIR/raw/YYYY-MM-DD.jsonl"
echo "   - Retros: $SCRIPT_DIR/../memory/discord-retro/YYYY-MM-DD.md"
echo ""
echo "📝 To check LaunchAgent status:"
echo "   launchctl list | grep ai.thejarvis.openclaw.discord-retro"
echo ""
