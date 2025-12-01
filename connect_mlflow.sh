#!/usr/bin/env bash

echo "==============================="
echo " MLflow Remote Connection Setup"
echo "==============================="
echo ""

# The script now assumes the SSH config has a host entry called 'remote-mlops'
SSH_HOST="remote-mlops"

echo "Connecting to $SSH_HOST ..."
echo "Forwarding ports:"
echo "  remote:80 → localhost:8080"
echo ""

# Use SSH with the alias, keep port forwarding
ssh -N -L 8080:localhost:80 "$SSH_HOST"
