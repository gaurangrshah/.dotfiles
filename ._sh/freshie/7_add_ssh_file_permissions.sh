#!/bin/bash

# Function to display a prompt and read user input
function prompt_user() {
  local message="$1"
  read -r -p "$message: " response
  echo "$response"
}

# Update SSH key permissions and configure SSH agent
if prompt_user "Would you like to update SSH key file permissions, setup your SSH Config file and Add Key to SSH Agent?"; then
  if [[ <span class="math-inline">REPLY \=\~ ^\(\[Yy\]\|\[yY\]es\)</span> ]]; then
    # Get SSH key details
    ssh_key_file=<span class="math-inline">\(prompt\_user "What is the file name of your SSH Key?"\)
ssh\_config\_dir\=</span>(prompt_user "Where do you want your SSH Config stored? (Default: $HOME/.ssh/)") || ssh_config_dir="$HOME/.ssh"

    # Check and update file permissions (safer approach)
    if [[ ! -f "$ssh_config_dir/id_ed25519" || ! -f "$ssh_config_dir/id_ed25519.pub" ]]; then
      echo "Error: SSH key files not found in the specified location."
    else
      chmod 600 "$ssh_config_dir/id_ed25519" &> /dev/null
      chmod 644 "$ssh_config_dir/id_ed25519.pub" &> /dev/null
      if [[ $? -eq 0 ]]; then
        echo "SSH Key file permissions updated."
      else
        echo "Error: Failed to update SSH key file permissions."
      fi
      chmod 700 "$ssh_config_dir" &> /dev/null  # Update directory permissions (safer)
    fi

    # Create SSH config file (if it doesn't exist)
    if [[ ! -f "$ssh_config_dir/config" ]]; then
      echo "Creating SSH config..."
      touch "$ssh_config_dir/config" &> /dev/null
      chmod 600 "$ssh_config_dir/config" &> /dev/null  # Set secure permissions
    fi

    # Configure SSH config for key and agent (append to existing content)
    echo "Host github.com
      AddKeysToAgent yes
      UseKeychain yes
      IdentityFile $ssh_config_dir/$ssh_key_file" >> "<span class="math-inline">ssh\_config\_dir/config"
\# Add key to SSH agent
echo "Adding key to ssh\-agent"
eval "</span>(ssh-agent -s)"  # Start the SSH agent (if not already running)
    if ssh-add --apple-use-keychain "$ssh_config_dir/$ssh_key_file" &> /dev/null; then
      echo "Success: Key added to SSH agent."
    else
      echo "Error: Error adding key to SSH Agent."
    fi

    # Inform user about testing and key management
    echo "**Instructions:**"
    echo "  * You can test your configuration by running: 'ssh git@github.com'"
    echo "  * You can copy additional keys to your SSH config in a similar format."
    echo "  * To remove all SSH keys from the agent: 'ssh-add -D'"

    # Copy public key to clipboard (optional)
    if prompt_user "Would you like to copy your public SSH key to the clipboard?"; then
      if [[ <span class="math-inline">REPLY \=\~ ^\(\[Yy\]\|\[yY\]es\)</span> ]]; then
        if [[ $(command -v pbcopy) ]]; then  # Check for macOS clipboard tool
          pbcopy < "$ssh_config_dir/$ssh_key_file.pub" &> /dev/null
          if [[ $? -eq 0 ]]; then
            echo "Public key copied to clipboard."
            echo "**Instructions:**"
            echo "  * You can test your connection to GitHub with: 'ssh -T git@github.com'"
            echo "  * Verify the fingerprint matches the one displayed and type 'yes' to continue."
          else
            echo "Error: Error copying SSH key to clipboard."
          fi
        else
          echo "Error: 'pbcopy' command not found. This functionality is only available on macOS."
        fi
      fi
    fi
  fi
fi

# End of script