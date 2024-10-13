#!/bin/bash
FORCE_PULL=false
if [ "$1" == "-f" ]; then
  FORCE_PULL=true
fi

if [ -n "$ROOST_DIR" ]; then
  cd $ROOST_DIR/tools
  BRANCH="main"  # Replace with your branch if needed (e.g., "master")

  # Fetch updates from the remote repository
  echo "Fetching updates from remote..."
  git fetch origin

  # Compare local and remote branches
  LOCAL=$(git rev-parse $BRANCH)
  REMOTE=$(git rev-parse origin/$BRANCH)

  if [ "$LOCAL" = "$REMOTE" ] && [ "$FORCE_PULL" = false ]; then
      echo "Up to date."
  else
      if [ "$FORCE_PULL" = true ]; then
        echo "Up to date.  Update forced."
      else
        echo "Update available."
      fi
      git pull origin $BRANCH
      cat nix/shell.nix | sed "s#__ROOST_DIR__#$ROOST_DIR#" > ${ROOST_DIR}/shell.nix
  fi
fi
