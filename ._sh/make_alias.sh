#!/bin/bash

# Check for required arguments
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Error: Please provide both alias name and command/filepath."
  echo "Usage: $0 <alias_name> <command_or_filepath>"
  exit 1
fi

# Define alias name and command/filepath
alias_name="$1"
alias_value="$2"


# Create a variable to store the path to the .oh-my-zsh/custom/aliases.zsh file or .zshrc file
file_path="$HOME/.zshrc"

# check if there is an alias file at .ohmyzsh/custom/aliases.zsh
if [ -f "$HOME/.oh-my-zsh/custom/aliases.zsh" ]; then
  echo "File exists"
  file_path="$HOME/.oh-my-zsh/custom/aliases.zsh"
else
  echo "File does not exist, creating it at $HOME/.oh-my-zsh/custom/aliases.zsh"
  touch "$HOME/.oh-my-zsh/custom/aliases.zsh"
  file_path="$HOME/.oh-my-zsh/custom/aliases.zsh"
  if [ -f "$HOME/.oh-my-zsh/custom/aliases.zsh" ]; then
    echo "File created"
  else
    echo "Error: File could not be created. Please check your permissions. $file_path" 
    exit 1
  fi
fi

if grep -q "alias $alias_name=" "$file_path"; then
  echo "Error: Alias '$alias_name' already exists in your $file_path file."
  exit 1
fi



# Append alias line to .zshrc
echo -e "\nalias $alias_name='$alias_value'" >> "$file_path"

echo "Appended alias '$alias_name' to your. $file_path" 
echo "** Please note: Changes might require restarting your terminal or running 'source ~/.zshrc' for them to take effect. **"
exit 0
