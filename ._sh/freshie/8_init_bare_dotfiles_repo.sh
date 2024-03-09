#!/bin/bash

# Function to display a prompt and read user input
function prompt_user() {
  local message="$1"
  read -r -p "$message: " response
  echo "$response"
}

# Initiate a dotfiles repository
if prompt_user "Would you like to initiate a .dotfiles repository?"; then
  if [[ $REPLY =~ ^([Yy]|[yY]es)$ ]]; then
    # Get SSH address for the repo
    repo_ssh_address=$(prompt_user "Create a new .dotfiles repo on GitHub and enter the SSH address for the repo here.")

    # Initialize bare repo (handle potential errors)
    if git init --bare --quiet "$HOME/.dotfiles" &> /dev/null; then
      echo "Success: New local bare repo created at '$HOME/.dotfiles'"
    else
      echo "Error: Something went wrong initiating a bare .dotfiles repo."
      exit 1  # Exit script with error code for abnormal termination
    fi

    # Set up git config alias (safer approach)
    if [[ ! -f "$HOME/.bashrc" ]]; then  # Check for commonly used shell config file
      echo "**Warning:** No shell configuration file found (e.g., ~/.bashrc). Alias for 'config' might not work."
    else
      echo "alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> "$HOME/.bashrc"
      if [[ $? -eq 0 ]]; then
        echo "**Note:** The alias for 'config' will be available after restarting your terminal or sourcing your shell configuration file."
      fi
    fi

    # Set up initial branch (handle errors)
    if config branch -m main &> /dev/null; then  # Use 'config' alias if set up
      echo "Success: Initial branch 'main' created."
    else
      echo "Error: Something went wrong creating the initial branch."
    fi

    # Set remote origin (handle errors)
    if config remote set-url origin "$repo_ssh_address" &> /dev/null; then  # Use 'config' alias
      echo "Success: Config Remote Set!"
    else
      echo "Error: Something went wrong updating the SSH remote origin."
    fi

    # Set status.showUntrackedFiles to 'no' (handle errors)
    if config config status.showUntrackedFiles no &> /dev/null; then  # Use 'config' alias
      echo "**Note:** Untracked files will not be shown by default with 'config status'."
    else
      echo "Error: Something went wrong configuring status.showUntrackedFiles."
    fi

    # Display instructions
    echo "**Instructions:**"
    echo "  * To check the status of tracked files: 'config status'"
    echo "  * To add a file: 'config commit <file_name> -m \"<commit message>\""
    echo "  * To push new files or changes: 'config push origin main'"
    echo "  * Read more about managing dotfiles with Git: https://www.atlassian.com/git/tutorials/dotfiles"
    echo "  * Explore an example dotfiles repository: https://github.com/Calbabreaker/dotfiles"
  fi
fi


# Improvements:

# Error handling is incorporated throughout the script using if statements and exit codes.
# The script checks for the existence of a common shell configuration file (e.g., .bashrc) before adding the alias for config.
# The script provides informative messages for successful operations and warnings/error messages for potential issues.
# The user is informed about potential limitations if the alias for config cannot be added.
# Redirecting standard output and error from some commands (git init and config commands) to /dev/null helps keep the user's terminal output clean.