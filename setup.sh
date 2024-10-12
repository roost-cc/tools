#!/bin/bash
handle_error() {
    echo "An error occurred on line $1"
    exit 1
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
    export ROOST_DIR=$(readlink -f .)
  fi
fi

echo setup.sh : $ROOST_DIR
STEP=0
if [ -d "$ROOST_DIR/.setup_step" ]; then
  STEP=$(cat $ROOST_DIR/.setup_step)
fi

while true; do
  STEP=$((STEP + 1))
  STEP_FILE=step-${STEP}.sh
  if [ -f "$ROOST_DIR/setup/${STEP_FILE}" ]; then
    echo "Local step : ${STEP_FILE}"
    # run the local step since it exists
    bash --login <(cat $ROOST_DIR/setup/${STEP_FILE})
  else
    echo "Remote step : ${STEP_FILE}"
    # grab the step from the repo if it exists
    HTTP_CODE=$(curl -s -w "%{http_code}" -X HEAD https://raw.githubusercontent.com/roost-cc/tools/refs/heads/main/setup/${STEP_FILE}))
    if[ HTTP_CODE -neq 200 ]; then
      echo No step $STEP
      exit
    fi 
    bash --login <(curl -L https://raw.githubusercontent.com/roost-cc/tools/refs/heads/main/setup/${STEP_FILE})
  fi
  RES=$?
  if [ $RES -eq 0 ]; then
    echo $STEP>$ROOST_DIR/.setup_step
  elif [ $RES -eq 42]; then
    # The step needs out-of-band action 
    # Increment the step count & exit
    echo $STEP>$ROOST_DIR/.setup_step
    exit
  else
    # something else when wrong - exit
    echo "Step failed with exit code $RES."
    exit
  fi
else
fi
done
