#!/bin/bash
handle_error() {
    echo "An error occurred on line $1"
    exit 1
}

trap 'handle_error $LINENO' ERR
# TODO: add to chromedriver and local dynamodb functions
#       ln this setup to bin directory as setup-roost or something
echo "Configure Roost Development environment..."
if [ -z "$ROOST_APP_DIR" ]; then
  APP_DIR=$(realpath $(dirname $0)/..)
  profiles=( "${HOME}/.bashrc" "${HOME}/.zshenv" )
  for p in "${profiles[@]}"; do
    echo "Checking if Roost tools is in ${p}"
    if [ ! -z "$(grep '# roost environment' "${p}")" ]; then 
      echo "Roost environment configured in ${p}, skipping"
      continue
    fi
    echo "Roost environment not configured in ${p}, adding"
    echo "" >> ${p}
    echo "# roost environment" >> ${p}
    echo "export ROOST_APP_DIR=${APP_DIR}" >> ${p}
    echo ". \${ROOST_APP_DIR}/tools/env" >> ${p}
  done
fi

echo 
echo "Installing NPM dependencies"
pushd $(realpath $(dirname $0))
npm install
popd

ROOST_NODE_DIR=/var/node
echo 
echo "Linking roost app to ${ROOST_NODE_DIR}"
sudo mkdir -p ${ROOST_NODE_DIR}
pushd ${ROOST_NODE_DIR}
sodo rm -f roost.cc
sudo ln -s ${ROOST_APP_DIR}/containers/node/app roost.cc
popd

echo 
echo "Roost Development environment complete."
