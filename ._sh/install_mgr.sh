#!/bin/bash

# This line specifies the interpreter to be used for this script (bash)

# Function to check if a file is executable
function is_executable() {
  local file="$1"  # Store the function argument (file path) in a local variable
  [[ -x "$file" ]]  # Check if the file has execute permissions using the test operator '[[ ]]'
}

# Function to run a script with optional verbose flag
function run_script() {
  local script_file="$1"  # Store the function argument (script path) in a local variable
  local verbose="$2"     # Store the function argument (verbose flag) in a local variable

  if [[ $verbose == "true" ]]; then
    bash -x "$script_file"  # Run the script with verbose output if the verbose flag is true
  else
    bash "$script_file"     # Run the script normally
  fi
}

# Main script logic

# 1. Parse arguments
script_dir="$1"  # Store the first argument (script directory) in a variable
verbose="false"  # Set the verbose flag to false by default

# 2. Check for verbose flag
if [[ "$2" == "--verbose" ]]; then
  verbose="true"   # Set the verbose flag to true if the second argument is "--verbose"
  shift 2          # Remove the first two arguments (script directory and verbose flag) from processing
fi

# 3. Check if directory is provided
if [[ -z "$script_dir" ]]; then
  echo "Error: Please specify a directory containing scripts."
  exit 1  # Exit the script with an error code (1)
fi

# 4. Find all executable bash files with numeric prefix
executable_scripts=()
for file in "$script_dir/"* ; do  # Loop through all files in the script directory
  if [[ -f "$file" && is_executable "$file" && [[ $file =~ ^[0-9]+_.*\.sh$ ]] ]]; then
    executable_scripts+=("$file")  # Add the file path to the executable_scripts array if it's a regular file, executable, and starts with a numeric prefix followed by ".sh" extension
  fi
done

# 5. Sort scripts numerically based on prefix (leading zeros preserved)
sorted_scripts=($(echo "${executable_scripts[@]}" | tr ' ' '\n' | sort -V | tr '\n' ' '))
#   - Convert the executable_scripts array to individual lines using 'tr ' ' '\n'
#   - Sort the lines numerically with leading zeros preserved using 'sort -V'
#   - Convert the sorted lines back to an array using 'tr '\n' ' '

# 6. Check if any scripts were found
if [[ ${#sorted_scripts[@]} -eq 0 ]]; then
  echo "No executable scripts found in directory '$script_dir'."
  exit 0  # Exit the script with a success code (0)
fi

# 7. Execute scripts in order
for script in "${sorted_scripts[@]}"; do
  run_script "$script" "$verbose"  # Call the run_script function for each script in the sorted order, passing the script path and verbose flag
  echo ""                          # Print a newline after each script execution
done

echo "All scripts have been executed in order."


# Example usage
# ./install_mgr.sh /path/to/scripts --verbose
#   - Run the install_mgr.sh script with the specified script directory and verbose flag

# each script in the directory will be executed in order, with verbose output if the --verbose flag is provided.
# the order of execution is determined by the numeric prefix of the script files, with leading zeros preserved.
# ex: 01_script1.sh, 02_script2.sh, 03_script3.sh, etc.