#!/bin/bash
handle_error() {
    echo "An error occurred on line $1"
    exit 1
}

trap 'handle_error $LINENO' ERR
# TODO: add to chromedriver and local dynamodb functions
#       ln this setup to bin directory as setup-roost or something
echo "Roost Development environment..."
# install nix

sh <(curl -L https://nixos.org/nix/install) --daemon
# download the shell.nix
ROOST_DIR=$(readlink -f ..)
curl https://raw.githubusercontent.com/roost-cc/tools/refs/heads/main/nix/shell.nix | sed "s#__ROOST_DIR__#\"$ROOST_DIR\"#" > ${ROOST_DIR}/shell.nix

cd $ROOST_DIR

nix-shell <<EOF
git clone git@github.com:roost-cc/tools.git

EOF

echo "Roost Development environment complete..."
