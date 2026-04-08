#!/bin/bash
# Called by Claude Code UserPromptSubmit hook — marks tab as "working"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
PROJECT_NAME=$(basename "$PROJECT_DIR")

# Tab color → amber (working)
printf "\x1B]6;1;bg;red;brightness;230\x07"
printf "\x1B]6;1;bg;green;brightness;180\x07"
printf "\x1B]6;1;bg;blue;brightness;50\x07"

# Tab title → "project — working"
printf "\x1B]1;%s — working\x07" "$PROJECT_NAME"
