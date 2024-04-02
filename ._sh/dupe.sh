#!/bin/bash

# Function to duplicate a file
duplicate_file() {
  local source_file=$1
  local destination_file=$2

  cp "$source_file" "$destination_file"
  echo "File duplicated successfully!"
}

# Function to duplicate a directory
duplicate_directory() {
  local source_directory=$1
  local destination_directory=$2

  cp -R "$source_directory" "$destination_directory"
  echo "Directory duplicated successfully!"
}

# Check if the -R flag is provided
if [[ $1 == "-R" ]]; then
  # Check if a directory path is provided
  if [[ -d $2 ]]; then
    source_directory=$2
    destination_directory=$3

    duplicate_directory "$source_directory" "$destination_directory"
  else
    echo "Invalid directory path!"
    exit 1
  fi
else
  # Check if a file path is provided
  if [[ -f $1 ]]; then
    source_file=$1
    destination_file=$2

    duplicate_file "$source_file" "$destination_file"
  else
    echo "Invalid file path!"
    exit 1
  fi
fi
