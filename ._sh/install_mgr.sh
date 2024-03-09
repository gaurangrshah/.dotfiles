#!/bin/bash

# Directory containing the scripts (change this to your directory)
scripts_dir="path/to/your/scripts"

# Get all .sh files in the directory
shopt -s nullglob  # Allow for no matches in the glob
scripts=("$scripts_dir"/*.sh)
shopt -u nullglob  # Disable for other uses

# Check if any scripts were found
if [[ ${#scripts[@]} -eq 0 ]]; then
  echo "No .sh files found in '$scripts_dir'"
  exit 1
fi

# Loop through each script
for script in "${scripts[@]}"; do
  # Extract filename from path
  filename=$(basename "$script")

  # Ask user for confirmation
  read -r -p "Run script: $filename (y/n)? " response

  if [[ $response =~ ^([Yy]|[yY]es)$ ]]; then
    echo "Running: $filename"
    # Run the script with source to avoid subshell issues
    source "$script"
  else
    echo "Skipping: $filename"
  fi
  echo ""  # Add a newline for better formatting
done

echo "All scripts processed!"


# Explanation:

# Shebang: Specifies the interpreter (/bin/bash) for this script.
# Script Directory: Update scripts_dir with the actual path containing your development setup scripts.
# Finding Scripts:
# shopt -s nullglob: Allows handling cases where no files match the glob pattern.
# scripts array: Stores all filenames ending with .sh in the scripts_dir.
# shopt -u nullglob: Disables nullglob to avoid affecting other parts of the script.
# Check for Scripts: Exits if no .sh files are found in the directory.
# Looping: Iterates through each script in the scripts array.
# Extracting Filename: Uses basename to get the filename without the path.
# User Confirmation: Prompts the user with the filename and asks for confirmation (y/n) to run it.
# The read command reads the user input and stores it in the response variable.
# The regular expression ^([Yy]|[yY]es)$ checks if the response starts with y, Y, yes, or YES (case-insensitive).
# Running Script:
# If the user confirms, the script is sourced using source "$script". This avoids potential issues with subshells.
# Otherwise, the script is skipped with a message.
# Newline: Adds a newline for better readability in the output.
# Completion Message: Prints a message after processing all scripts.
# How to Use:

# Save the script as run_setup_scripts.sh (or any preferred name) in a suitable location.
# Make the script executable: chmod +x run_setup_scripts.sh
# Run the script from your terminal: ./run_setup_scripts.sh
# It will list each script and ask for confirmation before running it.
# Additional Notes:

# You can modify the user prompt message to provide more information about each script.
# Consider adding error handling for cases where scripts fail to run.
