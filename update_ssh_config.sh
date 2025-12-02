#!/usr/bin/env bash

# Script to add SSH config entries for MLops setup
# Usage: ./update_ssh_config.sh <local-vm-ip> <remote-vm-ip> <path-to-private-key>

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <local-vm-ip> <remote-vm-ip> <path-to-private-key>"
    exit 1
fi

LOCAL_VM_IP="$1"
REMOTE_VM_IP="$2"
KEY_PATH="$3"

SSH_CONFIG="$HOME/.ssh/config"

# Ensure the SSH config file exists
mkdir -p "$HOME/.ssh"
touch "$SSH_CONFIG"

# Backup existing config
cp "$SSH_CONFIG" "$SSH_CONFIG.bak.$(date +%Y%m%d%H%M%S)"

echo "Updating SSH config at $SSH_CONFIG..."

# Function to add or replace a host entry
add_or_replace_host() {
    local host="$1"
    local entry="$2"

    # Remove existing entry if it exists
    awk -v host="$host" '
    BEGIN {skip=0}
    $1=="Host" && $2==host {skip=1; next}
    /^Host / {skip=0}
    skip==0 {print}
    ' "$SSH_CONFIG" > "$SSH_CONFIG.tmp" && mv "$SSH_CONFIG.tmp" "$SSH_CONFIG"

    # Append new entry
    echo -e "$entry" >> "$SSH_CONFIG"
}

# Prepare entries
LOCAL_ENTRY="Host local-mlops
    HostName $LOCAL_VM_IP
    User student
    IdentityFile $KEY_PATH
"

REMOTE_ENTRY="Host remote-mlops
    HostName $REMOTE_VM_IP
    User student
    IdentityFile $KEY_PATH
    LocalForward 5000 127.0.0.1:5000
    LocalForward 9000 127.0.0.1:9000
    LocalForward 9001 127.0.0.1:9001
"

# Add entries
add_or_replace_host "local-mlops" "$LOCAL_ENTRY"
add_or_replace_host "remote-mlops" "$REMOTE_ENTRY"

echo "SSH config updated successfully."

echo "Refreshing terminal environment..."
# Refresh ssh-agent
eval "$(ssh-agent -s)"
ssh-add "$KEY_PATH"

echo "You can now use 'ssh local-mlops', 'ssh remote-mlops' to connect."
