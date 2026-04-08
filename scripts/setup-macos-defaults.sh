#!/usr/bin/env bash
#
# Optional: Apply macOS system defaults
# Run via: ./scripts/setup-macos-defaults.sh
#
# Customize these based on your preferences
#

set -e

echoc 33 "Applying macOS system defaults..."

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable auto-correct while typing
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Trackpad: enable tap to click (current user and login screen)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Key repeat (faster)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Focus Follow Mouse (disabled by default, uncomment if desired)
# defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string "TwoButton"

# Screenshot: save to Desktop instead of clipboard
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Safari: show full URL
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# VSCode: disable telemetry
defaults write com.microsoft.VSCode telemetryLevel -string "off"

# Calendar: show week view by default
defaults write com.apple.calendar DefaultDaysInWeekView -int 7

# Restart affected apps
killall Finder 2>/dev/null
killall Safari 2>/dev/null || true
killall Dock 2>/dev/null || true

echoc 32 "✓ macOS defaults applied"
echoc 36 "Hint: Run 'killall -9 Finder;killall -9 Dock' to force restart if needed"
