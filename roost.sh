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
# download the shell.nix
ROOST_DIR=$(readlink -f ..)
sed "s#__ROOST_DIR__#\"$ROOST_DIR\"#" ./nix/shell.nix
