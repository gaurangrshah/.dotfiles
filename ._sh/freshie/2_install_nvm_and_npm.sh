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

# Install NVM
if prompt_user "Would you like to install NVM?"; then
  echo "**Note:** The script will attempt to automatically add the required lines to your shell configuration file (likely .bashrc or .zshrc)."
  echo "**However, it might not always be successful.**"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  echo ""  # Add an empty line for better readability
fi

# Exit message
echo "**Important:**"
echo "  * If the script didn't add the lines automatically, you might need to add them manually to your shell configuration file (usually ~/.bashrc or ~/.zshrc)."
echo "  * The lines to be added are:"
echo "      export NVM_DIR=\"$HOME/.nvm\"  # This line sets the NVM directory"
echo "      [ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"  # This line loads nvm"
echo "  * After adding the lines, relaunch your terminal for the changes to take effect."
echo "  * Verify the installation by running 'nvm --version' and 'nvm list' (if any versions are installed)."


# Explanation:

# The script utilizes the prompt_user function again.
# A user prompt asks about NVM installation.
# A clear note informs the user that automatic configuration might not always work and provides alternative instructions.
# The script exits with messages explaining how to complete the installation manually if automatic configuration fails.
# Naming the Script:

# A good name for this script file would be:

# install_nvm.sh: This is a clear and concise name that directly conveys the script's purpose.
