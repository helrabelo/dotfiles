# VS Code-style terminal keybindings (terminal-agnostic escape sequences).
# Requires the terminal's Left Option key set to Esc+ (Meta) for word nav.

# Word navigation: Option+Left / Option+Right
bindkey '\e[1;3D' backward-word
bindkey '\e[1;3C' forward-word
bindkey '\e[1;9D' backward-word
bindkey '\e[1;9C' forward-word
bindkey '\eb' backward-word
bindkey '\ef' forward-word

# Kill word: Option+Delete / Option+D
bindkey '\e\x7f' backward-kill-word
bindkey '\ed' kill-word

# Forward delete: Fn+Delete
bindkey '\e[3~' delete-char

# Line navigation
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Line kill
bindkey '^K' kill-line
bindkey '^U' backward-kill-line

# Undo / Redo
bindkey '^Z' undo
bindkey '^Y' redo

# History substring search
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Clear screen
bindkey '^L' clear-screen
