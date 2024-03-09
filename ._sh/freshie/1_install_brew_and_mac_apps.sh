#!/bin/bash

# Function to display a prompt and read user input
function prompt_user() {
  local message="$1"
  read -r -p "$message (y/n): " response
  if [[ ! $response =~ ^([Yy]|[yY]es)$ ]]; then
    return 1
  fi
  return 0
}

# Install Homebrew
if prompt_user "Would you like to install Homebrew?"; then
  echo "**WARNING:** Installing Homebrew may require entering your password."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  brew update
  if [[ $? -eq 0 ]]; then
    echo "Success: Homebrew installed and updated successfully"
  else
    echo "Errors:: Something went wrong installing Homebrew."
    if prompt_user "Would you like to try this operation again?"; then
      # Retry installation if user chooses
      ./$(basename "$0")  # Recursively call the script
      exit 0
    fi
    exit 1
  fi
fi

# App selection logic
if ! prompt_user "Would you like to install your default apps?"; then
  exit 0
fi

# Download Brewfile (**Caution:** Downloads from untrusted sources can be risky)
echo "**WARNING:** Downloading a file from an external source (gist)."
brewfile_url="https://gist.github.com/gaurangrshah/215efa7fb982ef1e77bed6833936f01b"
curl -fsSL "$brewfile_url" > Brewfile || ( echo "Error: Couldn't download Brewfile. Please check the file location ($brewfile_url)." && exit 1 )
echo "Success: Found Brewfile from gist: $brewfile_url"

# Update Brewfile comments instead of modifying content (Safer approach)
# This avoids modifying the script and Brewfile for every app selection change.
user_selections=()
for option in ("formulas" "casks" "mac_apps"); do
  if prompt_user "Install all Homebrew ${option[1:-1]}?"; then
    user_selections+=("# $option")  # Add comment to indicate selection
  fi
done

# Prepend comments to relevant sections in Brewfile
sed -i '' "1i\ # User-selected options:" Brewfile  # Add comment header
for selection in "${user_selections[@]}"; do
  echo "$selection" >> Brewfile  # Append selected option comments
done

# Install mas (if App Store apps are selected)
if [[ " ${user_selections[@]} " =~ "# mac_apps" ]]; then
  brew install mas || ( echo "Error: Installing the mac app store cli." && exit 1 )
  echo "**WARNING:** You need to be logged in to the App Store to install apps."
  prompt_user "Please login to the Mac App Store now and press Enter when you've authenticated successfully."
fi

# Install apps using Brewfile
brew bundle install || ( echo "Error: Installing default apps" && exit 1 )
echo "Default apps installed and ready to use."


# Explanation:
#
# The script leverages the prompt_user function again.
# Homebrew installation warnings are included.
# Downloading the Brewfile remains a potential security concern, so a warning is displayed.
# Safer approach for Brewfile updates:
# Instead of modifying content based on user selections, comments are added or removed to indicate chosen options.
# This eliminates the need to modify the script or Brewfile content for every app selection change.
# App Store login warning is included.
#
# Additional Notes:
#
# Consider pre-configuring the Brewfile with commented sections for each option to further improve safety and script maintainability.
# This script offers a secure foundation. You may want to customize it further for your specific needs.
