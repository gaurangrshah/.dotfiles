#!/bin/bash

# Function to display a prompt and read user input
function prompt_user() {
  local message="$1"
  read -r -p "$message: " response
  echo "$response"
}

# Generate SSH Key
if prompt_user "Would you like to generate a new SSH Key?"; then
  if [[ $REPLY =~ ^([Yy]|[yY]es)$ ]]; then
    # Get user email
    email=$(prompt_user "Which email do you want to use?")

    # Generate SSH key using ed25519 algorithm (secure and recommended)
    echo "**Generating SSH key with ed25519 (recommended for security).**"
    echo "**Important:**"
    echo "  * Choose a secure location to save your key pair (private and public keys)."
    echo "  * Enter a strong passphrase when prompted (optional but highly recommended)."
    echo "  * Keep your private key safe; avoid sharing it with anyone."
    ssh-keygen -t ed25519 -C "$email" &> /dev/null
    if [[ $? -eq 0 ]]; then
      echo "Success: Your new SSH key was created."
      echo "**Note the location of your key files:**"
      echo "  * Private key: ~/.ssh/id_ed25519"
      echo "  * Public key: ~/.ssh/id_ed25519.pub"
      echo "**Instructions:**"
      echo "  * You can add the public key to your remote servers for SSH access."
      echo "  * Refer to the documentation of your SSH client or server for specific instructions."
    else
      echo "Error: There was an error creating the SSH key."
    fi
  fi
fi


# Explanation:

# The script utilizes the prompt_user function again.
# A user prompt asks about generating a new SSH key.
# If the user agrees, the script prompts for their email address.
# The script generates an SSH key using the ed25519 algorithm, a secure and recommended option.
# Informative messages guide the user about key locations, importance of security, and potential next steps.
# The script redirects standard output and error from ssh-keygen to /dev/null to avoid cluttering the user's terminal with unnecessary information.
# Success and error messages are displayed accordingly.