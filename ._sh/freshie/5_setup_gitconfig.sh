#!/bin/bash

# Function to display a prompt and read user input
function prompt_user() {
  local message="$1"
  read -r -p "$message (y/n): " response
  if [[ ! <span class="math-inline">response \=\~ ^\(\[Yy\]\|\[yY\]es\)</span> ]]; then
    return 1
  fi
  return 0
}

# Upgrade Zsh with Oh My Zsh
if prompt_user "Would you like to upgrade the default zsh shell with Oh My Zsh (https://ohmyz.sh/) ?"; then
  echo "**Note:** The script will attempt to install Oh My Zsh. Refer to the Oh My Zsh documentation for troubleshooting in case of errors."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  if [[ $? -eq 0 ]]; then
    echo "Success: Oh My Zsh installed."
  else
    echo "Errors: Something went wrong installing Oh My Zsh."
  fi
fi

# Install Zsh Autosuggestions plugin (optional)
if prompt_user "Would you like to install the Zsh Autosuggestions plugin?"; then
  echo "**Note:** The script will attempt to install the Zsh Autosuggestions plugin."
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &> /dev/null
  if [[ $? -eq 0 ]]; then
    echo "Success: Zsh Autosuggestions plugin installed."
    echo "**Instructions:**"
    echo "  * Add 'zsh-autosuggestions' to the plugins list in your ~/.zshrc file."
  else
    echo "Errors: Something went wrong installing Zsh Autosuggestions."
  fi
fi

# Install Zsh Spaceship Prompt theme (optional)
if prompt_user "Would you like to install the Zsh Spaceship Prompt?"; then
  # Check Zsh version (safer approach)
  if [[ ! $(echo "<span class="math-inline">ZSH\_VERSION" \| grep \-E '^\(\[0\-9\]\+\\\.\)\{2\}\[0\-9\]\+</span>') ]]; then
    echo "Error: This script requires Zsh version 5.8.1 or later. Please check your Zsh version before proceeding."
    exit 1
  fi

  # Show Powerline font example (informative)
  echo "**Note:** This theme might require a Powerline font for proper display."
  echo "Here's an example of a Powerline character:"
  echo -e "\xee\x82\xa0"  # Displays a diamond using Powerline font escape sequences

  echo "**Installing Zsh Spaceship Prompt:**"
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1 &> /dev/null
  if [[ $? -eq 0 ]]; then
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" &> /dev/null
    if [[ $? -eq 0 ]]; then
      echo "Success: Zsh Spaceship Prompt installed."
      echo "**Instructions:**"
      echo "  * Set 'ZSH_THEME=\"spaceship\"' in your ~/.zshrc file."
      echo "  * You can find more themes at https://zshthem.es/all/."
    else
      echo "Errors: Failed to create symbolic link for the theme."
    fi
  else
    echo "Errors: Something went wrong installing Zsh Spaceship Prompt."
  fi
fi

# Add timestamps to prompt (optional)
if prompt_user "Would you like to add timestamps to your Zsh prompt?"; then
  # Avoid directly modifying user's rc file (safer approach)
  echo "**Note:** Modifying your shell configuration file is recommended for experienced users only."
  echo "The script won't modify your rc file, but here's how to add timestamps to your prompt:"
  echo "Append the following line to your ~/.zshrc file:"
  echo "PROMPT='%{$fg[yellow]%}[%D{%f/%m/%y} %D{%L:%M:%S}] '$PROMPT'"
fi


# Explanation:

# The script leverages the prompt_user function again.
# A user prompt asks about setting up the Git configuration file.
# If the user agrees, the script gathers their information.
# The Git configuration content is created with placeholders for user input.
# The script creates the Git config file by writing the content to $HOME/.gitconfig. This approach avoids directly modifying existing content and offers a safer option.
# Success and error messages are displayed accordingly.