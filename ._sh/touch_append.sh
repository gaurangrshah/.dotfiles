#!/bin/bash

# Check if a filepath is provided as an argument
if [ $# -eq 0 ]; then
  echo "Please provide a filepath as an argument."
  exit 1
fi

# Get the filepath argument
filepath="$1"

# Check if the file already exists (optional)
# ... (add your existing logic here)

# Check for graphical environment (optional)
if [[ -n $DISPLAY ]]; then
  # Use xclip for graphical systems
  content=$(xclip -o)
else
  # Use pbpaste (or your non-graphical tool) for non-graphical systems
  content=$(pbpaste)
fi

# Append the clipboard content to the file
echo "$content" >> "$filepath"

echo "File '$filepath' updated with clipboard content."


# Append the file with the clipboard content
# echo "$content" >> "$filepath
# usage: touch_append.sh <filepath>