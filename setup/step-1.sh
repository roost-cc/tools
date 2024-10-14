#!/bin/bash
echo 'Setting up nix'

if [ -z "$ROOST_DIR" ]; then 
  echo "ROOST_DIR not set, exiting"
  exit 1
fi
# install nix
if command -v nix >/dev/null 2>&1; then
  echo "nix already installed"
else
  echo "downloading up 'nix' : ${ROOST_DIR}..."
  bash <(curl -L https://nixos.org/nix/install) --daemon
  #bash <(curl -L https://nixos.org/nix/install) --no-daemon
  mkdir -p $HOME/.config/nixpkgs/
  echo "{ allowUnfree = true; }" > $HOME/.config/nixpkgs/config.nix
fi
# download the shell.nix
curl https://raw.githubusercontent.com/roost-cc/tools/refs/heads/main/nix/shell.nix | sed "s#__ROOST_DIR__#\"$ROOST_DIR\"#" > ${ROOST_DIR}/shell.nix

# install the nix packages
bash --login -e -c "cd $ROOST_DIR && nix-shell --run exit"

# fix chrome permissions
sudo chmod 4755 $(find /nix -name chrome-sandbox)

