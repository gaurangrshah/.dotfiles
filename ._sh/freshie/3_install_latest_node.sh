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

# Install latest Node.js version
if prompt_user "Would you like to install the latest version of Node.js?"; then
  echo "**Note:** NVM will attempt to install the latest Node.js version."
  echo "In case of errors, refer to the NVM documentation for troubleshooting."
  nvm install node
  if [[ $? -eq 0 ]]; then
    echo "Success: Latest Node.js version installed."
    echo "**Instructions:**"
    echo "  * To temporarily use the latest version, run:"
    echo "      nvm use node"
    echo "  * To verify the installed versions, run:"
    echo "      node -v && npm -v"
    echo "  * For more information on using NVM, refer to its documentation."
  else
    echo "Error: Installation failed. Please check NVM logs for details."
  fi
fi

# Exit message
echo ""  # Add an empty line for better readability


# Explanation:
# The script reuses the prompt_user function.
# A user prompt asks about installing the latest Node.js version.
# A note informs the user that automatic installation might not always be successful and suggests referring to NVM documentation for troubleshooting.
# The script exits with success and usage instructions if installation is successful.
# An error message advises the user to check NVM logs for details in case of failure.
# Naming the Script:
# A good name for this script file would be:
# install_latest_node.sh: This name clearly conveys the script's purpose of installing the latest Node.js version.
