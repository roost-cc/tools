#!/bin/bash
if [ -n "$ROOST_DIR" ]; then
  cd $ROOST_DIR/tools
  BRANCH="main"  # Replace with your branch if needed (e.g., "master")

  # Fetch updates from the remote repository
  echo "Fetching updates from remote..."
  git fetch origin

  # Compare local and remote branches
  LOCAL=$(git rev-parse $BRANCH)
  REMOTE=$(git rev-parse origin/$BRANCH)

  if [ "$LOCAL" = "$REMOTE" ]; then
      echo "Local and remote branches are up to date."
  else
      echo "Remote is ahead of local."

      # Run your commands here if the remote is ahead
      echo "Running your custom commands..."
      
      # Example command: Pull the latest changes
      git pull origin $BRANCH
      cat nix/shell.nix | sed "s#__ROOST_DIR__#\"$ROOST_DIR\"#" > ${ROOST_DIR}/shell.nix
      # Add more commands as needed, such as rebuilding or restarting services
      # ./build.sh
      # ./restart_service.sh
  fi
fi
