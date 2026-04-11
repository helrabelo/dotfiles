#!/usr/bin/env bash
# ============================================================
# macOS Defaults — Hel's Preferences
#
# Run this on a new Mac to apply trackpad, mouse, keyboard,
# Dock, Finder, and global UI preferences that don't sync
# via iCloud.
#
# Idempotent — safe to run multiple times. Some settings
# require a logout or Dock/Finder restart to fully apply.
#
# Usage:
#   bash ~/code/dotfiles/macos-defaults.sh
# ============================================================

set -e

echo "=== Applying macOS defaults ==="
echo ""

# ------------------------------------------------------------------
# Global UI
# ------------------------------------------------------------------
echo ">>> Global UI"

defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true
defaults write NSGlobalDomain AppleTemperatureUnit -string "Celsius"

# Expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save new docs to disk, not iCloud, by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# ------------------------------------------------------------------
# Keyboard
# ------------------------------------------------------------------
echo ">>> Keyboard"

# Fast key repeat (good for vim and terminal work)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable press-and-hold for accented characters (lets "jjjj" repeat in vim)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Disable macOS autocorrect (editors should own spelling)
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticInlinePredictionEnabled -bool false

# ------------------------------------------------------------------
# Trackpad (both built-in and Bluetooth)
# ------------------------------------------------------------------
echo ">>> Trackpad"

# Natural scrolling (matches MacBook — content moves with fingers)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# Force click and haptic feedback
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true

for trackpad_domain in \
  com.apple.driver.AppleBluetoothMultitouch.trackpad \
  com.apple.AppleMultitouchTrackpad; do

  # Tap to click
  defaults write "$trackpad_domain" Clicking -bool true

  # No drag lock
  defaults write "$trackpad_domain" DragLock -bool false
  defaults write "$trackpad_domain" Dragging -bool false

  # Pinch, zoom, rotate, scroll — all standard gestures on
  defaults write "$trackpad_domain" TrackpadPinch -bool true
  defaults write "$trackpad_domain" TrackpadRotate -bool true
  defaults write "$trackpad_domain" TrackpadScroll -bool true
  defaults write "$trackpad_domain" TrackpadHorizScroll -bool true
  defaults write "$trackpad_domain" TrackpadMomentumScroll -bool true

  # Right-click (two-finger or corner)
  defaults write "$trackpad_domain" TrackpadRightClick -bool true
  defaults write "$trackpad_domain" TrackpadCornerSecondaryClick -int 0

  # Three-finger drag OFF (matches MacBook)
  defaults write "$trackpad_domain" TrackpadThreeFingerDrag -bool false
  defaults write "$trackpad_domain" TrackpadThreeFingerTapGesture -int 0

  # Swipe gestures (2 = on)
  defaults write "$trackpad_domain" TrackpadThreeFingerHorizSwipeGesture -int 2
  defaults write "$trackpad_domain" TrackpadThreeFingerVertSwipeGesture -int 2
  defaults write "$trackpad_domain" TrackpadFourFingerHorizSwipeGesture -int 2
  defaults write "$trackpad_domain" TrackpadFourFingerVertSwipeGesture -int 2
  defaults write "$trackpad_domain" TrackpadFourFingerPinchGesture -int 2
  defaults write "$trackpad_domain" TrackpadFiveFingerPinchGesture -int 2

  # Notification Center swipe from right edge
  defaults write "$trackpad_domain" TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3

  # Smart zoom (two-finger double tap)
  defaults write "$trackpad_domain" TrackpadTwoFingerDoubleTapGesture -bool true

  # Palm rejection
  defaults write "$trackpad_domain" TrackpadHandResting -bool true

  defaults write "$trackpad_domain" UserPreferences -bool true
done

# ------------------------------------------------------------------
# Dock
# ------------------------------------------------------------------
echo ">>> Dock"

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock tilesize -int 40
defaults write com.apple.dock largesize -int 64
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false

# Hot corners (matches MacBook):
#   top-left = Mission Control (1) with modifier Cmd (1048576)
#   bottom-right = Quick Note (14)
defaults write com.apple.dock wvous-tl-corner -int 1
defaults write com.apple.dock wvous-tl-modifier -int 1048576
defaults write com.apple.dock wvous-br-corner -int 14
defaults write com.apple.dock wvous-br-modifier -int 0

# ------------------------------------------------------------------
# Finder
# ------------------------------------------------------------------
echo ">>> Finder"

defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder AppleShowAllFiles -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"   # List view
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"   # Search current folder
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# ------------------------------------------------------------------
# Screenshots
# ------------------------------------------------------------------
echo ">>> Screenshots"

mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture showsClicks -bool true

# ------------------------------------------------------------------
# Menu bar clock
# ------------------------------------------------------------------
echo ">>> Menu bar clock"

defaults write com.apple.menuextra.clock Show24Hour -bool true
defaults write com.apple.menuextra.clock ShowDate -bool false
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock IsAnalog -bool false

# ------------------------------------------------------------------
# Restart affected services to pick up changes
# ------------------------------------------------------------------
echo ""
echo ">>> Restarting Dock, Finder, SystemUIServer..."
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo ""
echo "=== macOS defaults applied ==="
echo ""
echo "Some settings require a logout or reboot to fully apply:"
echo "  - Keyboard key repeat (full logout)"
echo "  - Trackpad gestures (may need mouse/trackpad re-connection)"
echo "  - Autocorrect settings (per-app, new documents only)"
echo ""
