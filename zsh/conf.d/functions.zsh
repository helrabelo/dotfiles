# Shell functions.

# git identity helpers
git_email() { git config user.email 2>/dev/null || echo "no git config"; }
git_name()  { git config user.name 2>/dev/null || echo "no git config"; }

# cd and list (ported from .zshrc-dev-optimizations)
cdl() { cd "$1" && ls -la; }

# Save the clipboard image to a temp PNG and print the path
pi() {
  local file="/tmp/clipboard-$(date +%s).png"
  osascript -e "set png to the clipboard as «class PNGf»" \
            -e "set referenceNumber to open for access \"$file\" with write permission" \
            -e "write png to referenceNumber" \
            -e "close access referenceNumber" 2>/dev/null
  if [[ -f "$file" && -s "$file" ]]; then
    echo "✓ Image saved: $file"
  else
    rm -f "$file"
    echo "✗ No image in clipboard"
    return 1
  fi
}
