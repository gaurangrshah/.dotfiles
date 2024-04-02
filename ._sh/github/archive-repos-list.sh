#!/bin/bash

# This script uses gh to archive a repository.
# It requires the GitHub CLI (gh) to be installed.
# brew install gh

# Get user confirmation
read -p "Are you sure you want to archive multiple remote repositories? (y/N): " confirmation

# use regex to check if user confirms (case-insensitive)
if [[ $confirmation =~ ^[Yy]$ ]]; then

  # Get a list of repository names (NOTE: space-separated list of repository names is expected)
  read -rp "Enter a space-separated list of repository names (e.g., repo1 repo2 repo3): " repo_names

  # Check if git is installed
  if ! which git &> /dev/null; then
    echo "Error: git is not installed. Please install git before running this script."
    exit 1
  fi

  # Use the GitHub CLI (gh) to archive repositories
  if ! command -v gh &> /dev/null; then
    echo "Warning: GitHub CLI (gh) is not installed. Functionality may be limited."
  fi

  # Get the username from git config
  username=$(git config github.user)
  echo "Archiving $username repositories $repo_names..."
  # Loop through each repository name
  for repo_name in $repo_names; do
  # archive the current repository
    gh repo archive "$username/$repo_name" || echo "Archiving failed for $repo_name. Please check permissions."
  done

else
  echo "Archiving canceled."
fi
