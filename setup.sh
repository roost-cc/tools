#!/bin/bash
handle_error() {
    echo "An error occurred on line $1"
    exit 1
}

trap 'handle_error $LINENO' ERR
bash <(curl -L https://raw.githubusercontent.com/roost-cc/tools/refs/heads/main/setup/step-1.sh)
bash --login <(curl -L https://raw.githubusercontent.com/roost-cc/tools/refs/heads/main/setup/step-2.sh)
