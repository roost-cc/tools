#!/bin/bash
handle_error() {
    echo "An error occurred on line $1"
    exit 1
}

trap 'handle_error $LINENO' ERR
# TODO: add to chromedriver and local dynamodb functions
#       ln this setup to bin directory as setup-roost or something
ROOST_DIR=$(readlink -f .)
echo "Step 1 : Setting up 'nix' : ${ROOST_DIR}..."
# install nix
if command -v nix >/dev/null 2>&1; then
  echo "nix already installed"
else
  sh <(curl -L https://nixos.org/nix/install) --daemon
  mkdir -p $HOME/.config/nixpkgs/
  echo "{ allowUnfree = true; }" > $HOME/.config/nixpkgs/config.nix
fi
# download the shell.nix
curl https://raw.githubusercontent.com/roost-cc/tools/refs/heads/main/nix/shell.nix | sed "s#__ROOST_DIR__#\"$ROOST_DIR\"#" > ${ROOST_DIR}/shell.nix

cd $ROOST_DIR

echo "Step 1 complete"
