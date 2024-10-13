#!/bin/bash
echo "Setting up SSH keys and repo access"

ssh_dir=$HOME/.ssh
ssh_config=$ssh_dir/config
pri_key=$ssh_dir/roost
pub_key=${pri_key}.pub

ssh-keygen -t rsa -b 4096 -C "$(git config user.name) [${git config user.email}]" -f ${pri_key}

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
  read -p "Enter your SSH Key ID (provided by administrator): " ssh_key_id

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

