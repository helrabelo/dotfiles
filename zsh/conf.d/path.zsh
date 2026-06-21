# PATH construction. Depends on env.zsh (ANDROID_HOME, GOPATH, PNPM_HOME).
# Homebrew + OrbStack + mise-shims PATH come from .zprofile (login shell).

# Personal bins (deduped; the old .zshrc exported these three separately)
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Android SDK tooling
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
[ -d "/opt/homebrew/share/android-commandlinetools/emulator" ] && \
  export PATH="$PATH:/opt/homebrew/share/android-commandlinetools/emulator"

# Go
[ -d "$GOPATH/bin" ] && export PATH="$PATH:$GOPATH/bin"

# Google Cloud SDK (Tools install; the Downloads install is wired in tools.zsh)
[ -d "$HOME/Tools/google-cloud-sdk/bin" ] && export PATH="$PATH:$HOME/Tools/google-cloud-sdk/bin"

# Yarn global
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# pnpm
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Antigravity IDE
[ -d "$HOME/.antigravity/antigravity/bin" ] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
