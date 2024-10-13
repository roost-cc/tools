#!/bin/bash
echo "Setting up projects"

pull_repo() {
  if [ -z "$project" ]; then
    echo "Error: A project must be provided."
    return 1
  fi

  # Check if a non-empty directory or file exists
  if [ -e "$project" ]; then
    if [ -d "$project" ] && [ "$(ls -A "$project")" ]; then
      echo "Error: Directory '$project' already exists and is not empty."
      return 1
    elif [ -f "$project" ]; then
      echo "Error: A file named '$project' already exists."
      return 1
    fi
  fi

  local project=$1
  local repo_url=ssh://${git_host}/v1/repos/${project}

  # Prompt the user for confirmation
  read -p "Do you want to download the repository '$project' from '$repo_url'? (Y/n): " response
  response=${response:-y}  # Default to 'y' if the user presses Enter
  if [[ "$response" != "y" && "$response" != "Y" ]]; then
    echo "Skipping download of '$friendly_name'."
    return 0
  fi

  # Clone the repository depending on whether inside Nix shell or not
  if [ -n "$IN_NIX_SHELL" ]; then
    git clone "$repo_url"
  else 
    nix-shell --run "git clone $repo_url"
  fi

  echo "Repository '$friendly_name' has been downloaded."
}

if [ -z "$ROOST_DIR" ]; then 
  echo "ROOST_DIR not set, exiting"
  exit 1
fi

cd "$ROOST_DIR"

#git_host=git-codecommit.us-east-2.amazonaws.com
git_host=roost-git

projects=("roost.cc" "app.roost.cc")
for project in "${projects[@]}"; do
  echo "Processing project: $project"
  pull_repo "$project"
done
