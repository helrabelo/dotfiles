# Environment variables. Sourced before path.zsh so PATH can build on these.

# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"

# Go
export GOPATH="$HOME/Tools/go"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"

# GnuPG (1Password handles SSH signing; gpg-agent covers any direct gpg use)
export GNUPGHOME="$HOME/.gnupg"
export GPG_TTY="$(tty)"
