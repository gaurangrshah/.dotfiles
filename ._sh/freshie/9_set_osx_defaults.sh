#!/bin/bash

# Function to display a prompt and get user selection (yes/no)
function prompt_yes_no() {
  local message="$1"
  read -r -p "$message (y/n): " response
  if [[ $REPLY =~ ^([Yy]|[yY]es)$ ]]; then
    return 0
  else
    return 1
  fi
}

# Set macOS defaults menu
echo "**Available macOS Defaults:**"
echo "  1. Show Library Folder"
echo "  2. Show Hidden Files"
echo "  3. Show Path Bar in Finder"
echo "  4. Show Status Bar in Finder"
echo "  5. Prevent Two-Finger Scroll in Chrome (might disable other gestures)"
echo "  6. Allow Apps from Anywhere (**Security Risk**, use with caution)"

# User selection loop
while true; do
  read -r -p "Select an option (1-6) or enter 'q' to quit: " choice

  case $choice in
    1)
      if prompt_yes_no "This will make your Library folder visible. Are you sure?"; then
        defaults write com.apple.Finder AppleShowAllFiles YES
        if [[ $? -eq 0 ]]; then
          echo "Success: Library folder will be shown."
        else
          echo "Error: Failed to show Library folder."
        fi
      fi
      break
      ;;
    2)
      if prompt_yes_no "This will show hidden files. Are you sure?"; then
        defaults write com.apple.finder AppleShowAllFiles YES
        if [[ $? -eq 0 ]]; then
          echo "Success: Hidden files will be shown."
        else
          echo "Error: Failed to show hidden files."
        fi
      fi
      break
      ;;
    3)
      defaults write com.apple.finder ShowPathbar -bool true
      if [[ $? -eq 0 ]]; then
        echo "Success: Path bar will be shown in Finder."
      else
        echo "Error: Failed to show path bar in Finder."
      fi
      break
      ;;
    4)
      defaults write com.apple.finder ShowStatusBar -bool true
      if [[ $? -eq 0 ]]; then
        echo "Success: Status bar will be shown in Finder."
      else
        echo "Error: Failed to show status bar in Finder."
      fi
      break
      ;;
    5)
      if prompt_yes_no "This will prevent two-finger scroll in Chrome (might disable other gestures). Are you sure?"; then
        defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
        if [[ $? -eq 0 ]]; then
          echo "Success: Two-finger scroll disabled in Chrome."
        else
          echo "Error: Failed to disable two-finger scroll in Chrome."
        fi
      fi
      break
      ;;
    6)
      echo "**WARNING:** Allowing Apps from Anywhere poses a significant security risk."
      echo "This should only be used for temporary testing purposes and should be disabled afterward."
      if prompt_yes_no "Are you sure you want to proceed?"; then
        sudo spctl --master-disable
        if [[ $? -eq 0 ]]; then
          echo "**Warning:** Apps from Anywhere is now allowed. Use with caution and disable when finished."
        else
          echo "Error: Failed to enable Apps from Anywhere."
        fi
      fi
      break
      ;;
    q|Q)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please enter a number between 1-6 or 'q' to quit."
      ;;
  esac
done


# Explanation:

# The script defines a prompt_yes_no function to handle user confirmation (yes/no).
# It presents a menu with available options for macOS defaults.
# A loop allows users to select options (1-6) or quit (q).
# Based on the user's choice, the script executes the appropriate defaults write command.
# For options with security implications (like allowing apps from anywhere), the script displays clear warnings and requires user confirmation.
# Error handling is included to inform the user of any issues during command execution.