# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/helrabelo/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="spaceship"


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

ZSH_DISABLE_COMPFIX=true

source $ZSH/oh-my-zsh.sh


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#kubectl completitions

command -v kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)

PATH="$HOME/anaconda/bin:$PATH"

SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "

### Zinit plugin manager (zdharma-continuum fork)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}Zinit%F{220} plugin manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$(dirname $ZINIT_HOME)"
    command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load annexes (z-a-as-monitor dropped — merged into zinit-annex-readurl, different use case)
zinit light-mode for \
    zdharma-continuum/zinit-annex-rust \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-bin-gem-node

### End of Zinit installer chunk


zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-toolsexport PATH="$HOME/.jenv/bin:$PATH"
command -v jenv >/dev/null 2>&1 && eval "$(jenv init -)"
export PATH=$PATH:/opt/homebrew/share/android-commandlinetools/emulator/

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

GNUPGHOME=~/.gnupg
export GPG_TTY=$(tty)
gpgconf --launch gpg-agent
export PATH="/Users/helrabelo/.local/bin:$PATH"

# Modify PATH at the end
export PATH="/Users/helrabelo/Library/Python/3.9/bin:$PATH"


# alias python=python3
# alias pip=pip3
export PATH="$HOME/.poetry/bin:$PATH"

[ -f "$HOME/.rye/env" ] && source "$HOME/.rye/env"
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/helrabelo/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/helrabelo/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/helrabelo/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/helrabelo/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# rbenv should be located at `~/.rbenv`
FPATH=~/.rbenv/completions:"$FPATH"

autoload -U compinit
compinit
# Added by `rbenv init` on Qui 26 Dez 2024 09:03:18 -03
eval "$(rbenv init - --no-rehash zsh)"
eval "$(rbenv init - zsh)"
eval "$(rbenv init - zsh)"
export GPG_TTY=$(tty)


git_email() {
  git config user.email 2> /dev/null || echo "no git config"
}

git_name() {
  git config user.name 2> /dev/null || echo "no git config"
}


# pnpm
export PNPM_HOME="/Users/helrabelo/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# direnv
eval "$(direnv hook zsh)"

# Development tools configuration
source ~/.zshrc-tools
export PATH="$HOME/bin:$PATH"

# Claude Code
alias c="claude --dangerously-skip-permissions --verbose"

# Helsky Vault aliases
source ~/.helsky-vault-aliases
export PATH="$HOME/.local/bin:$PATH"

# zoxide - smarter cd command
eval "$(zoxide init zsh)"

# iTerm2 Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# ============================================================
# iTerm2 + Claude Code Integration (added 2026-03-14)
# ============================================================

# -- Project color mapping (RGB 0-255 for escape sequences) --
typeset -A HELSKY_PROJECT_COLORS
HELSKY_PROJECT_COLORS=(
  falavra           "155:89:182"
  dropvox           "52:152:219"
  tokencentric      "230:126:34"
  tokencap          "241:196:15"
  gitography        "46:204:113"
  bespoke-cv        "26:188:156"
  get-ready-for-work "231:76:60"
  helsky-labs-dashboard "52:73:94"
  helsky-labs-site  "255:107:107"
  daysasnumbers-app "255:105:180"
  bookbit           "211:84:0"
  snapstride        "39:174:96"
)

# -- Detect current project from pwd --
_helsky_project_name() {
  local dir="$PWD"
  if [[ "$dir" == "$HOME/code/helsky-labs/"* ]]; then
    echo "${dir#$HOME/code/helsky-labs/}" | cut -d/ -f1
  fi
}

# -- Set iTerm2 tab color from RGB string "R:G:B" --
_iterm2_set_tab_color() {
  local rgb="$1"
  local r="${rgb%%:*}"; rgb="${rgb#*:}"
  local g="${rgb%%:*}"
  local b="${rgb#*:}"
  printf "\x1B]6;1;bg;red;brightness;%s\x07" "$r"
  printf "\x1B]6;1;bg;green;brightness;%s\x07" "$g"
  printf "\x1B]6;1;bg;blue;brightness;%s\x07" "$b"
}

# -- Reset tab color to project default --
_iterm2_reset_tab_color() {
  local project="$(_helsky_project_name)"
  if [[ -n "$project" && -n "${HELSKY_PROJECT_COLORS[$project]}" ]]; then
    _iterm2_set_tab_color "${HELSKY_PROJECT_COLORS[$project]}"
  else
    printf "\x1B]6;1;bg;*;default\x07"
  fi
}

# -- Set tab title --
_iterm2_set_tab_title() {
  printf "\x1B]1;%s\x07" "$1"
}

# -- precmd: reset tab color + update title on each prompt --
_helsky_precmd() {
  _iterm2_reset_tab_color
  local project="$(_helsky_project_name)"
  if [[ -n "$project" ]]; then
    _iterm2_set_tab_title "$project"
  fi
}
precmd_functions+=(_helsky_precmd)

# -- iTerm2 user-defined variables --
iterm2_print_user_vars() {
  iterm2_set_user_var project "$(_helsky_project_name)"
}

# -- Helper: open new iTerm2 tab for a project --
claude-tab() {
  local project="${1:?Usage: claude-tab <project-name> [label]}"
  local label="${2:-}"
  local dir="$HOME/code/helsky-labs/$project"
  if [[ ! -d "$dir" ]]; then
    echo "Project not found: $dir" >&2
    return 1
  fi
  local tab_title="$project"
  if [[ -n "$label" ]]; then
    tab_title="${project}-${label}"
  fi
  osascript <<APPLESCRIPT
    tell application "iTerm2"
      tell current window
        set newTab to (create tab with profile "HL: $project")
        tell current session of newTab
          set name to "$tab_title"
        end tell
      end tell
    end tell
APPLESCRIPT
}

# ============================================================
# End iTerm2 + Claude Code Integration
# ============================================================

# ============================================================
# VS Code-like Terminal Keybindings (added 2026-02-06)
# Requires: iTerm2 Left Option key set to Esc+ (Meta)
# To remove: delete this entire block between the === lines
# ============================================================

# -- Word navigation: Option+Left / Option+Right --
bindkey '\e[1;3D' backward-word        # Option+Left (CSI modifier 3)
bindkey '\e[1;3C' forward-word         # Option+Right (CSI modifier 3)
bindkey '\e[1;9D' backward-word        # Option+Left (iTerm2 Esc+ variant)
bindkey '\e[1;9C' forward-word         # Option+Right (iTerm2 Esc+ variant)
bindkey '\eb' backward-word            # Meta+b (Esc+b fallback)
bindkey '\ef' forward-word             # Meta+f (Esc+f fallback)

# -- Kill word: Option+Delete / Option+D --
bindkey '\e\x7f' backward-kill-word    # Option+Delete (backward kill word)
bindkey '\ed' kill-word                # Option+D (forward kill word)

# -- Forward delete: Fn+Delete --
bindkey '\e[3~' delete-char            # Fn+Delete (forward delete char)

# -- Line navigation/editing --
bindkey '\e[H' beginning-of-line       # Home key
bindkey '\e[F' end-of-line             # End key
bindkey '^A' beginning-of-line         # Ctrl+A (line start)
bindkey '^E' end-of-line               # Ctrl+E (line end)

# -- Line kill --
bindkey '^K' kill-line                 # Ctrl+K (kill to end of line)
bindkey '^U' backward-kill-line        # Ctrl+U (kill to start of line)

# -- Undo/Redo --
bindkey '^Z' undo                      # Ctrl+Z (undo last edit)
bindkey '^Y' redo                      # Ctrl+Y (redo)

# -- History substring search (like VS Code Ctrl+Up/Down) --
bindkey '^[[A' up-line-or-search       # Up arrow (history search)
bindkey '^[[B' down-line-or-search     # Down arrow (history search)

# -- Clear screen --
bindkey '^L' clear-screen              # Ctrl+L (clear terminal)

# ============================================================
# End VS Code-like Terminal Keybindings
# ============================================================

# ============================================================
# Clipboard Image Paste (added 2026-03-18)
# ============================================================
pi() {
  local file="/tmp/clipboard-$(date +%s).png"
  osascript -e "set png to the clipboard as «class PNGf»" -e "set referenceNumber to open for access \"$file\" with write permission" -e "write png to referenceNumber" -e "close access referenceNumber" 2>/dev/null
  if [[ -f "$file" && -s "$file" ]]; then
    echo "✓ Image saved: $file"
  else
    rm -f "$file"
    echo "✗ No image in clipboard"
    return 1
  fi
}

# Added by Antigravity
export PATH="/Users/helrabelo/.antigravity/antigravity/bin:$PATH"

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"  # uv (Mini)
