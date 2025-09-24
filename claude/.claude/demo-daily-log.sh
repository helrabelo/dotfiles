#!/bin/bash

# Demo script for Daily Log Automation System
# This demonstrates the key features and functionality

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOMATION_SCRIPT="$SCRIPT_DIR/daily-log-automation.js"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Daily Log Automation System Demo${NC}"
echo "================================================"

echo -e "\n${YELLOW}📋 System Overview:${NC}"
echo "• Scans all CLAUDE.md files across project directories"
echo "• Extracts activities for any specified date"
echo "• Formats according to established daily log standards"
echo "• Creates/updates Obsidian-compatible daily log files"
echo "• Supports slash commands and interactive logging"

echo -e "\n${YELLOW}🔍 Scanning for CLAUDE.md files...${NC}"
find /Users/helrabelo/Code -name "CLAUDE.md" -type f 2>/dev/null | head -10 | while read file; do
    rel_path=$(echo "$file" | sed 's|/Users/helrabelo/||')
    echo "  📄 $rel_path"
done

echo -e "\n${YELLOW}📅 Available Commands:${NC}"
echo "• ./claude-daily-log.sh                    # Today's log"
echo "• ./claude-daily-log.sh 2025-09-22       # Specific date"
echo "• ./claude-daily-log.sh --yesterday       # Yesterday's log"
echo "• ./claude-daily-log.sh --week           # Entire week"
echo "• node activity-logger.js                # Interactive logging"

echo -e "\n${YELLOW}🧪 Running Test Suite:${NC}"
if command -v node &> /dev/null; then
    if [[ -f "$SCRIPT_DIR/test-daily-log.js" ]]; then
        echo "Running automated tests..."
        node "$SCRIPT_DIR/test-daily-log.js"
    else
        echo "⚠️  Test suite not found"
    fi
else
    echo "⚠️  Node.js not available for testing"
fi

echo -e "\n${YELLOW}📄 Sample Usage - Generate Today's Log:${NC}"
echo "Command: node $AUTOMATION_SCRIPT"

if command -v node &> /dev/null; then
    echo -e "\n${GREEN}✨ Generating sample daily log...${NC}"

    # Generate today's log
    node "$AUTOMATION_SCRIPT" --date 2025-09-23

    echo -e "\n${GREEN}✅ Demo completed!${NC}"
    echo "Check /Users/helrabelo/obsidian-daily-entry-2025-09-23.md for the generated log"
else
    echo -e "\n${YELLOW}⚠️  Node.js not available - cannot run live demo${NC}"
    echo "Please install Node.js to use the automation system"
fi

echo -e "\n${BLUE}📚 Documentation:${NC}"
echo "• README.md - Complete setup and usage guide"
echo "• System supports 19+ project CLAUDE.md files"
echo "• Automatic detection of Planetary, Plainsight, and Personal projects"
echo "• Obsidian-compatible output with proper date formatting"

echo -e "\n${BLUE}🎯 Next Steps:${NC}"
echo "1. Make scripts executable: chmod +x claude-daily-log.sh"
echo "2. Add to PATH or create aliases for easy access"
echo "3. Run: ./claude-daily-log.sh to generate today's log"
echo "4. Use: node activity-logger.js to add new activities"

echo "================================================"