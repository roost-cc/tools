{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.nodejs_22     # For Node.js
    pkgs.docker        # For Docker
    pkgs.awscli2       # AWS CLI
    pkgs.gnumake       # Make tool for general scripts
    pkgs.sass          # Global SASS installation
    pkgs.tmux          # For starting the stack with tmux
    pkgs.git           # Git for version control
    pkgs.google-chrome # Google Chrome installation in Nix
    pkgs.cowsay
    pkgs.fortune
  ];

  # Optional: Set up environment variables here if needed
  shellHook = ''
#     if [ ! -f ~/.aws/credentials ]; then
#       echo "AWS credentials not found. Please provide your AWS Access Key and Secret Key."
#
#       # Prompt the user for AWS Access Key ID
#       read -p "Enter your AWS Access Key ID: " aws_access_key_id
#
#       # Prompt the user for AWS Secret Access Key
#       read -sp "Enter your AWS Secret Access Key: " aws_secret_access_key
#       echo
#
#       # Ensure the AWS credentials directory exists
#       mkdir -p ~/.aws
#
#       # Store the credentials in ~/.aws/credentials
#       cat > ~/.aws/credentials <<EOF
# [default]
# aws_access_key_id = $aws_access_key_id
# aws_secret_access_key = $aws_secret_access_key
# EOF
#
#       echo "AWS credentials stored successfully."
#     fi

    export ROOST_DIR="__ROOST_DIR__"
    export ROOST_APP_DIR="$ROOST_DIR/app.roost.cc"
    export PATH="$ROOST_DIR/tools/bin:$PATH"
    # Chrome
    alias chrome="roost-chrome"
    # cowsay 
    alias roostersay="LC_ALL=C cowsay -f __ROOST_DIR__/tools/nix/extras/rooster.cow"

    # Set a custom command line prompt
    # export PS1="(roost-dev) \u@\h:\w\$ "
    export PS1="\n\[\033[1;32m\][🐓:\u@\h:\w]\$\[\033[0m\] "

    fortune -s | roostersay
    echo
    echo "Welcome to Roost 🐓"
  '';
}

