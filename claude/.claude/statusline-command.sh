#!/usr/bin/env bash
# Claude Code status line: context %, cost, git branch, elapsed time
# Reads JSON from stdin as provided by Claude Code's statusLine feature

input=$(cat)

# --- Context usage % ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct")
  ctx_part="ctx ${used_int}%"
else
  ctx_part="ctx --"
fi

# --- Session cost (total input + output tokens, rough estimate) ---
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
# Sonnet 4.x pricing: $3/M input, $15/M output (approximate)
cost=$(awk "BEGIN { printf \"%.3f\", ($total_in / 1000000 * 3) + ($total_out / 1000000 * 15) }")
cost_part="\$${cost}"

# --- Git branch (from cwd, skip locks) ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
if [ -n "$cwd" ]; then
  branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
fi
if [ -n "$branch" ]; then
  git_part=" $branch"
else
  git_part=""
fi

# --- Elapsed time (from transcript file creation time) ---
transcript=$(echo "$input" | jq -r '.transcript_path // empty')
elapsed_part=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  start_epoch=$(stat -f "%B" "$transcript" 2>/dev/null || stat -c "%W" "$transcript" 2>/dev/null)
  now_epoch=$(date +%s)
  if [ -n "$start_epoch" ] && [ "$start_epoch" -gt 0 ] 2>/dev/null; then
    elapsed=$(( now_epoch - start_epoch ))
    hrs=$(( elapsed / 3600 ))
    mins=$(( (elapsed % 3600) / 60 ))
    secs=$(( elapsed % 60 ))
    if [ "$hrs" -gt 0 ]; then
      elapsed_part=" ${hrs}h${mins}m"
    else
      elapsed_part=" ${mins}m${secs}s"
    fi
  fi
fi

printf "%s  %s%s%s" "$ctx_part" "$cost_part" "$git_part" "$elapsed_part"
