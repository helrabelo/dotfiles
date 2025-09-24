#!/bin/bash

# Claude slash command for daily log automation
# Usage: /daily-log [date] [options]

CLAUDE_DIR="/Users/helrabelo/.claude"
cd "$CLAUDE_DIR"

# Check if working script exists
if [ ! -f "generate-daily-log.js" ]; then
    echo "❌ Daily log automation not found."
    exit 1
fi

# Parse arguments
TARGET_DATE="$1"
if [ -z "$TARGET_DATE" ]; then
    TARGET_DATE=$(date +%Y-%m-%d)
fi

echo "🚀 Generating daily log for $TARGET_DATE..."

# Run the working daily log generator
node generate-daily-log.js "$TARGET_DATE"

echo ""
echo "✅ Daily log slash command completed!"
echo "📁 Check: ~/obsidian-daily-entry-$TARGET_DATE.md"