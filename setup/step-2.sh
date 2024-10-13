#!/bin/bash
echo "Setting up roost tools"

if [ -z "$ROOST_DIR" ]; then 
  echo "ROOST_DIR not set, exiting"
  exit 1
fi
echo "Setting up git"
while true; do
  # Get the default full name from the system
  default_fullname=$(getent passwd "$USER" | cut -d ':' -f 5)
  # Prompt the user for input with the default value
  read -p "Enter your full name [$default_fullname]: " fullname
  # If the user pressed Enter without typing anything, use the default full name
  fullname=${fullname:-$default_fullname}
  read -p "Enter your email address: " email

  # Show the entered information and ask for confirmation
  echo "You entered: $fullname <$email>"
  read -p "Is this information correct? (Y/n): " confirm

  # If the user confirms with Y or Enter, break the loop and continue
  confirm=${confirm:-Y}  # Default to 'Y' if the user presses Enter
  if [[ "$confirm" == "Y" || "$confirm" == "y" ]]; then
    echo "Information confirmed. Proceeding..."
    break
  else
    echo 
  fi
done
  

echo "Downloading roost tools : ${ROOST_DIR}..."
# setsup the environment, and pulls the tools
if [ -n "$IN_NIX_SHELL" ]; then
  git config --global init.defaultBranch main && \
  git config --global user.name "${fullname}" && \
  git config --global user.email "${email}" && \
  git clone https://github.com/roost-cc/tools.git
else 
  nix-shell --run " \
    git config --global init.defaultBranch main && \
    git config --global user.name \"${fullname}\" && \
    git config --global user.email \"${email}\" && \
    git clone https://github.com/roost-cc/tools.git 
  "
fi
