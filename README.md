# Roost Tools

Tools for setting up the `roost.cc` development environment.

## Prerequisite
1. `sudo` access.  
2. `curl` command
```
command -v curl >/dev/null 2>&1 || { echo "curl not found, installing..."; sudo apt update && sudo apt install -y curl; }
```

## Run install script
Create your development directory, e.g. `$HOME/work/roost`
```
mkdir -p $HOME/work/roost

```
bash <(curl -L https://raw.githubusercontent.com/roost-cc/tools/refs/heads/main/setup/step-1.sh) && \
bash <(curl -L https://raw.githubusercontent.com/roost-cc/tools/refs/heads/main/setup/step-2.sh) 
```
