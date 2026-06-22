# Per-context shell environment: history isolation, per-client env, a visible
# git-identity indicator (tmux status-right + the starship prompt), and
# tmux-session -> context activation. Paired with tmux/tmux.conf + sesh/sesh.toml.
#
# Context = tmux session name. Contexts: default, ayeeye, currents, planetary.

# --- history (baseline comes from /etc/zshrc; set larger + per-context here) --
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS SHARE_HISTORY

# --- contexts and their roots ------------------------------------------------
typeset -gA HELSKY_CTX_ROOTS=(
  default   "$HOME"
  ayeeye    "$HOME/code/ayeeye"
  currents  "$HOME/code/currents"
  planetary "$HOME/code/planetary"
)

# Per-context background tint (subtle, Dracula-compatible darks). Painted onto
# the terminal by _ctx_paint: a tmux window background inside tmux, OSC 11 when
# bare. The vivid status-chip colors are separate and live in tmux/tmux.conf.
typeset -gA HELSKY_CTX_BG=(
  default   "#282a36"
  ayeeye    "#1e2230"
  currents  "#1f2a24"
  planetary "#2d1f22"
)

# Clear per-context state before switching, so nothing leaks between contexts.
_cleanup_ctx() {
  unset HELSKY_CONTEXT
}

# Apply a context's environment.
#   $1 = context name
#   $2 = mode: "init" (env only; fast; safe to run in every pane) or
#              "interactive" (slow path; also cd into the context root)
_ctx_env() {
  local ctx="${1:-default}" mode="${2:-init}"
  _cleanup_ctx
  export HELSKY_CONTEXT="$ctx"
  # Per-context history; default keeps the existing ~/.zsh_history.
  if [[ "$ctx" == "default" ]]; then
    export HISTFILE="$HOME/.zsh_history"
  else
    export HISTFILE="$HOME/.zsh_${ctx}_history"
  fi
  if [[ "$mode" == "interactive" ]]; then
    local root="${HELSKY_CTX_ROOTS[$ctx]:-$HOME}"
    [[ -d "$root" ]] && cd "$root"
  fi
}

# Paint the active context's background tint onto the terminal. Inside tmux we
# set the window background (visible behind the shell; nvim/less keep their own
# bg). Bare, we emit OSC 11 so Ghostty tints the surface directly. Bare shells
# are always the "default" context today, so the OSC path mostly just keeps the
# neutral Dracula bg; the real per-context tint happens inside tmux.
_ctx_paint() {
  local ctx="${HELSKY_CONTEXT:-default}"
  local bg="${HELSKY_CTX_BG[$ctx]:-#282a36}"
  if [[ -n "$TMUX" ]]; then
    tmux set-option -w window-style        "bg=$bg" 2>/dev/null
    tmux set-option -w window-active-style "bg=$bg" 2>/dev/null
  else
    printf '\e]11;%s\a' "$bg"
  fi
}

# Map the current tmux session name -> context, so every new pane inherits it.
_auto_activate_context() {
  local ctx="default"
  if [[ -n "$TMUX" ]]; then
    case "$(tmux display-message -p '#S' 2>/dev/null)" in
      ayeeye)    ctx="ayeeye" ;;
      currents)  ctx="currents" ;;
      planetary) ctx="planetary" ;;
    esac
  fi
  _ctx_env "$ctx" init
  _ctx_paint
}

# Enter (or create) the tmux session for a context, preferring sesh.
_ctx_enter() {
  local ctx="${1:-default}"
  local root="${HELSKY_CTX_ROOTS[$ctx]:-$HOME}"
  if command -v sesh >/dev/null 2>&1; then
    sesh connect "$ctx"
  elif [[ -z "$TMUX" ]]; then
    tmux new-session -A -s "$ctx" -c "$root"
  else
    tmux has-session -t "$ctx" 2>/dev/null || tmux new-session -d -s "$ctx" -c "$root"
    tmux switch-client -t "$ctx"
  fi
}

# Context entry points.
default()   { _ctx_enter default; }
ayeeye()    { _ctx_enter ayeeye; }
currents()  { _ctx_enter currents; }
planetary() { _ctx_enter planetary; }

# Claude, scoped to the active context. Loud about which identity a
# --dangerously-skip-permissions session is running as.
c() {
  local ctx="${HELSKY_CONTEXT:-default}"
  print -P "%F{yellow}claude [skip-permissions] in context '${ctx}' as $(git config user.email 2>/dev/null || echo 'no git identity')%f"
  command claude --dangerously-skip-permissions --verbose "$@"
}

# Inherit the tmux session's context on shell startup (fast path; env only).
_auto_activate_context
