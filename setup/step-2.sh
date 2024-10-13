#!/bin/bash
echo "Setting up roost tools"

if [ -z "$ROOST_DIR" ]; then 
  echo "ROOST_DIR not set, exiting"
  exit 1
fi
echo "Downloading roost tools : ${ROOST_DIR}..."
# setsup the environment, and pulls the tools
if [ -n "$IN_NIX_SHELL" ]; then
  git clone https://github.com/roost-cc/tools.git
else 
  nix-shell --run "git clone https://github.com/roost-cc/tools.git"
fi
