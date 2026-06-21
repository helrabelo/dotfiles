# Tool initialization: plugin manager, runtime manager, prompt, shell helpers.

### Zinit plugin manager (zdharma-continuum fork)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}Zinit%F{220} plugin manager…%f"
    command mkdir -p "$(dirname $ZINIT_HOME)"
    command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-rust \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-bin-gem-node

# Plugins
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# Completions: brew site-functions on fpath, then compinit once
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit

# mise: runtime version manager (replaces nvm / rbenv / jenv)
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"

# starship prompt (replaces oh-my-zsh + spaceship)
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# zoxide: smarter cd
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# direnv
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# Google Cloud SDK (Downloads install: PATH + completion)
[ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
[ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"

# uv (Astral) env, if present
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Launch gpg-agent
command -v gpgconf >/dev/null 2>&1 && gpgconf --launch gpg-agent >/dev/null 2>&1
