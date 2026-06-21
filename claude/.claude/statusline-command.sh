#!/usr/bin/env bash
# Claude Code status line: effort · ctx % · dir (3 levels) · git branch
# Reads JSON from stdin as provided by Claude Code's statusLine feature

input=$(cat)

# ANSI colors (dimmed palette to suit the status bar context)
CYAN='\033[0;36m'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
DIM='\033[2m'
RESET='\033[0m'

SEP=" ${DIM}·${RESET} "

# --- Effort / thinking level ---
effort_level=$(echo "$input" | jq -r '.effort.level // empty')
if [ -n "$effort_level" ]; then
  effort_part="${MAGENTA}effort:${effort_level}${RESET}"
else
  thinking=$(echo "$input" | jq -r '.thinking.enabled // empty')
  if [ "$thinking" = "true" ]; then
    effort_part="${MAGENTA}thinking:on${RESET}"
  else
    effort_part=""
  fi
fi

# --- Context usage % ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct")
  ctx_part="${DIM}ctx ${used_int}%${RESET}"
else
  ctx_part="${DIM}ctx --${RESET}"
fi

# --- Current working directory (last three segments, ~ for home) ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
if [ -n "$cwd" ]; then
  home_dir="$HOME"
  # Replace leading $HOME with ~
  cwd_tilde="${cwd/#$home_dir/~}"
  if [ "$cwd_tilde" = "~" ]; then
    cwd_display="~"
  else
    cwd_clean="${cwd_tilde%/}"
    # Extract up to 3 trailing path segments
    seg3=$(basename "$cwd_clean")
    parent1=$(dirname "$cwd_clean")
    seg2=$(basename "$parent1")
    parent2=$(dirname "$parent1")
    seg1=$(basename "$parent2")
    grandparent=$(dirname "$parent2")

    if [ "$parent1" = "/" ] || [ "$parent1" = "." ] || [ "$parent1" = "~" ]; then
      # Only one segment
      cwd_display="${seg3}"
    elif [ "$parent2" = "/" ] || [ "$parent2" = "." ] || [ "$parent2" = "~" ]; then
      # Two segments
      cwd_display="${seg2}/${seg3}"
    else
      # Three or more segments available
      cwd_display="…/${seg1}/${seg2}/${seg3}"
    fi
  fi
  dir_part="${CYAN}${cwd_display}${RESET}"
else
  dir_part=""
  cwd=""
fi

# --- Git branch (skip optional locks to avoid stalling) ---
git_part=""
if [ -n "$cwd" ]; then
  branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    git_part="${GREEN}${branch}${RESET}"
  fi
fi

# --- Assemble (skip empty segments) ---
parts=()
[ -n "$effort_part" ] && parts+=("$effort_part")
[ -n "$ctx_part" ]    && parts+=("$ctx_part")
[ -n "$dir_part" ]    && parts+=("$dir_part")
[ -n "$git_part" ]    && parts+=("$git_part")

# Join with separator
result=""
for part in "${parts[@]}"; do
  if [ -z "$result" ]; then
    result="$part"
  else
    result="${result}${SEP}${part}"
  fi
done

printf "%b" "$result"
