#!/bin/bash

# This script will download the contents of a GitHub repo
# and place them in a local directory.
#
# Usage:
#   download-repo.sh <repo> <output-path> <nested-path>
#
# Example:
#   download-repo.sh wattenberger/kumiko ./kumiko-assets
# public/assets
#
# You'll get rate-limited by GitHub, so create a PAT here:
#   https://github.com/settings/tokens
# This will also let you download from private repos.

GITHUB_TOKEN="YOUR_TOKEN_HERE"

repo=$1

# split repo name to username and repository name
repo_name=`echo $repo | cut -d/ -f2`
repo_user=`echo $repo | cut -d/ -f1`

output_path=$2
nested_path=$3

# if no output_path is given, use the repo name
if [ -z "$output_path" ]; then
  output_path="./${repo_name}"
fi


url="https://api.github.com/repos/${repo}/git/trees/master?recursive=1"

# fetch repo data
full_tree_string=`curl -s -H "Authorization: token
${GITHUB_TOKEN}" "${url}"`
# get paths where type is not tree
paths=`echo ${full_tree_string} | jq -r '.tree[] |
select(.type != "tree") | .path'`

# filter out lines that don't start with nested_path and
# remove nested_path prefix
paths=`echo "${paths}" | grep -E "^${nested_path}" | sed
"s|^${nested_path}||g"`

number_of_paths=`echo "${paths}" | wc -l | sed "s/^[
\t]*//"`

echo "Found ${number_of_paths} files, fetching contents..."

mkdir -p "${output_path}/"

set -o noclobber
# fetch contents for each line in paths
for path in ${paths}; do
    echo "Fetching ${path}..."

url="https://raw.githubusercontent.com/${repo}/master/${nested_path}${path}"

    path_without_filename=$(dirname "/${path}")
    full_path="${output_path}${path_without_filename}"

    mkdir -p "${full_path}/"

    # download and save file from url
    curl -s -H "Authorization: token ${GITHUB_TOKEN}"
"${url}" > "${output_path}/${path}"
done

echo "All set! 🌈"
