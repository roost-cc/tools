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

echo "Setting up SSH keys and repo access"

ssh_dir=$HOME/.ssh
ssh_config=$ssh_dir/config
pri_key=$ssh_dir/roost
pub_key=${pri_key}.pub

if [ ! -f $pri_key ]; then 
  if [ -n "$IN_NIX_SHELL" ]; then
    ssh-keygen -t rsa -b 4096 -C "$(git config user.name) [$(git config user.email)]" -f ${pri_key} || true
  else 
    nix-shell --run "ssh-keygen -t rsa -b 4096 -C \"\$(git config user.name) [\$(git config user.email)]\" -f ${pri_key}"
  fi
fi

echo send this to the admin
echo ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
cat ${pub_key}
echo ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------

echo send this to the admin

git_host=git-codecommit.us-east-2.amazonaws.com

if ! grep -A 3 '^Host roost-git' ${ssh_config} 2> /dev/null; then
  if [ ! -f "${ssh_config}" ]; then 
    touch ${ssh_config}
  fi

  # Prompt for SSH Key ID and ensure it is 20 characters long and composed of A-Z and 0-9
  while true; do
    read -p "Enter your SSH Key ID (provided by administrator): " ssh_key_id
    if [[ "$ssh_key_id" =~ ^[A-Z0-9]{20}$ ]]; then
      break  # Exit the loop if ssh_key_id matches the pattern
    else
      echo "Invalid SSH Key ID. It must be exactly 20 characters long and contain only uppercase letters (A-Z) and digits (0-9)."
    fi
  done

  echo Adding configuration $ssh_config
  cat <<EOF >> $ssh_config

Host roost-git
  Hostname ${git_host}
  User ${ssh_key_id}
  IdentityFile ${pri_key}
EOF
fi

git_test=$(ssh -T roost-git 2>&1 || true)
echo
echo $git_test | GREP_COLORS="mt=01;32" grep --color=auto successfully
echo
if [ ! $? ]; then
  echo "Unexpected error, exiting"
  return 1
fi

