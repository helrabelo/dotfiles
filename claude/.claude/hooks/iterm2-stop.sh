#!/bin/bash
# Called by Claude Code Stop hook — notifies user, changes tab green
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
PROJECT_NAME=$(basename "$PROJECT_DIR")

# Tab color → green (task complete / needs attention)
printf "\x1B]6;1;bg;red;brightness;50\x07"
printf "\x1B]6;1;bg;green;brightness;205\x07"
printf "\x1B]6;1;bg;blue;brightness;50\x07"

# Tab title → "project — done"
printf "\x1B]1;%s — done\x07" "$PROJECT_NAME"

# macOS notification
osascript -e "display notification \"Claude finished — needs your attention\" with title \"$PROJECT_NAME\" sound name \"default\""

# Dock bounce (once)
printf "\x1B]1337;RequestAttention=once\x07"
