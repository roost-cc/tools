#!/bin/bash
handle_error() {
    local exit_code=$?  # Captures the exit status of the last command
    local error_line=$1  # The line number where the error occurred
    local command="$BASH_COMMAND"  # The command that was being executed

    echo "Error occurred on line $error_line."
    echo "Step: $STEP_FILE"
    echo "Command: $command"
    echo "Exit code: $exit_code"
    exit $exit_code  # Exit with the same error code that caused the trap
}
trap 'handle_error $LINENO' ERR

export NIX_QUIET=true

# set ROOST_DIR if necessary
if [ -z "$ROOST_DIR" ]; then
  script_path=$(realpath "$0")
  echo $script_path
  if [ -f "$script_path" ]; then
    ROOST_DIR=$(dirname $script_path)
    ROOST_DIR=$(dirname $ROOST_DIR)
    export ROOST_DIR
  else
    default_location=${HOME}/work/roost

    # Prompt the user for input with the default value
    echo "Where do you want to install the Roost development environment?"
    read -p "[$default_location]: " location

    # If the user pressed Enter without typing anything, use the default full name
    location=${location:-$default_location}
    if [ ! -d "${location}" ]; then
      mkdir -p "${location}"
    fi

    export ROOST_DIR=${location}
  fi
fi

echo Setting up in \"$ROOST_DIR\"
read -p "press enter to continue"

if [ ! -d "${ROOST_DIR}" ]; then
  echo creating ${ROOST_DIR}
  mkdir -p "${ROOST_DIR}"
fi

cd $ROOST_DIR
pwd

STEP=0
if [ -f "$ROOST_DIR/.setup_step" ]; then
  STEP=$(cat $ROOST_DIR/.setup_step)
  echo "Continuing setup on step $((STEP + 1))"
fi

while true; do
  STEP=$((STEP + 1))
  STEP_FILE=step-${STEP}.sh
  if [ -f "$ROOST_DIR/tools/setup/${STEP_FILE}" ]; then
    echo
    echo "Local step : ${STEP_FILE}"
    # run the local step since it exists
    read -p "press enter to continue"
    echo
    bash --login -e <(cat $ROOST_DIR/tools/setup/${STEP_FILE})
  else
    echo
    echo "Remote step : ${STEP_FILE}"
    # grab the step from the repo if it exists
    read -p "press enter to continue"
    echo
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X HEAD "https://raw.githubusercontent.com/roost-cc/tools/refs/heads/main/setup/${STEP_FILE}" || true)
    if [ $HTTP_CODE -ne 200 ]; then
      echo 
      echo The Roost Development Environment is ready.  Exit this terminal 
      echo \(you might have to log out of your window manager.\) 
      echo 
      echo Restart the terminal.  Go to the roost directory, and run nix-shell.
      echo 
      echo cd \"$ROOST_DIR\"
      echo nix-shell
      exit
    fi 
    bash --login -e <(curl -s -L https://raw.githubusercontent.com/roost-cc/tools/refs/heads/main/setup/${STEP_FILE})
  fi
  # Record a successful step
  echo $STEP>$ROOST_DIR/.setup_step
done
