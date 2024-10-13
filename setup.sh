#!/bin/bash
handle_error() {
    local exit_code=$?  # Captures the exit status of the last command
    local error_line=$1  # The line number where the error occurred
    local command="$BASH_COMMAND"  # The command that was being executed

    echo "Error occurred on line $error_line."
    echo "Command: $command"
    echo "Exit code: $exit_code"
    exit $exit_code  # Exit with the same error code that caused the trap
}


trap 'handle_error $LINENO' ERR

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
    read -p "Where do you want to install [$default_location]: " location

    # If the user pressed Enter without typing anything, use the default full name
    location=${location:-$default_location}
    if [ ! -d "${location}" ]; then
      mkdir -p "${location}"
    fi

    export ROOST_DIR=${location}
  fi
fi

echo Setting up in \"$ROOST_DIR\"
cd $ROOST_DIR
read -p "press enter to continue"

STEP=0
if [ -f "$ROOST_DIR/.setup_step" ]; then
  STEP=$(cat $ROOST_DIR/.setup_step)
  echo "Continuing setup on step $((STEP + 1))"
fi

while true; do
  STEP=$((STEP + 1))
  STEP_FILE=step-${STEP}.sh
  if [ -f "$ROOST_DIR/tools/setup/${STEP_FILE}" ]; then
    echo "Local step : ${STEP_FILE}"
    # run the local step since it exists
    bash --login -e <(cat $ROOST_DIR/tools/setup/${STEP_FILE})
  else
    echo "Remote step : ${STEP_FILE}"
    # grab the step from the repo if it exists
    echo curl -s -w \"%{http_code}\" -X HEAD https://raw.githubusercontent.com/roost-cc/tools/refs/heads/main/setup/${STEP_FILE}
    set +e
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X HEAD "https://raw.githubusercontent.com/roost-cc/tools/refs/heads/main/setup/${STEP_FILE}" || true)
    set -e
    if [ $HTTP_CODE -ne 200 ]; then
      echo No step $STEP
      exit
    fi 
    bash --login -e <(curl -L https://raw.githubusercontent.com/roost-cc/tools/refs/heads/main/setup/${STEP_FILE})
  fi
  echo $STEP>$ROOST_DIR/.setup_step
  
  # # Check the result
  # RES=$?
  # if [ $RES -eq 0 ]; then
  #   echo $STEP>$ROOST_DIR/.setup_step
  # elif [ $RES -eq 42 ]; then
  #   # The step needs out-of-band action 
  #   # Increment the step count & exit
  #   echo $STEP>$ROOST_DIR/.setup_step
  #   exit
  # else
  #   # something else when wrong - exit
  #   echo "Step failed with exit code $RES."
  #   exit
  # fi
done
