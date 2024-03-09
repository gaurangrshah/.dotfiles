#!/bin/bash

# Function to set executable permissions for a file
set_executable_permissions() {
    chmod +x "$1"
    echo "Executable permissions set for: $1"
}

# Main script
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file/directory>"
    exit 1
fi

# Resolve the absolute path for the provided argument
ARGUMENT=$(realpath "$1")

# Check if the argument is a directory
if [ -d "$ARGUMENT" ]; then
    echo "Processing directory: $ARGUMENT"
    
    # Find and set executable permissions for .sh files recursively
    find "$ARGUMENT" -type f -name "*.sh" | while read -r file; do
        if [ ! -x "$file" ]; then
            set_executable_permissions "$file"
        fi
    done

    echo "Finished processing directory."
elif [ -f "$ARGUMENT" ]; then
    # Check if the argument is a file
    if [[ "$ARGUMENT" == *.sh && ! -x "$ARGUMENT" ]]; then
        set_executable_permissions "$ARGUMENT"
    else
        echo "File is not a .sh file or already has executable permissions."
    fi
else
    echo "Invalid argument. Please provide a valid file or directory."
    exit 1
fi
