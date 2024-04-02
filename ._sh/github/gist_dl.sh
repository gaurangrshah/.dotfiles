#!/bin/bash

# Check if the number of arguments is correct
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <gist_url> <file_path>"
  exit 1
fi

# Get the arguments
user_gistid="$1"  # username/gistid
file_path="$2"

# Extract the directory path and file name from the provided file path
destination_dir=$(dirname "$file_path")
file_name=$(basename "$file_path")

# Check and create the destination directory if needed
if [[ ! -d "$destination_dir" ]]; then
  mkdir -p "$destination_dir"
  echo "Created directory: $destination_dir"
fi

# Construct the complete URL, including the file name
file_url="https://gist.githubusercontent.com/$user_gistid/raw/$file_name"

# Check and create the file if needed (ensures it's empty if it doesn't exist)
touch "$destination_dir/$file_name"

# Download and append to the file
curl -s "$file_url" >> "$destination_dir/$file_name"

echo "File downloaded and saved to: $destination_dir/$file_name"
