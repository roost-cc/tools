#!/bin/bash
handle_error() {
    echo "An error occurred on line $1"
    exit 1
}

trap 'handle_error $LINENO' ERR
# TODO: add to chromedriver and local dynamodb functions
#       ln this setup to bin directory as setup-roost or something
ROOST_DIR=$(readlink -f .)
echo "Step 2 : Setting up 'nix-shell' : ${ROOST_DIR}..."

nix-shell <<EOF
git clone git@github.com:roost-cc/tools.git

EOF
echo "Step 2 complete"
