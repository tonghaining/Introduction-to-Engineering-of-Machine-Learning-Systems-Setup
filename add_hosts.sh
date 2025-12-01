#!/usr/bin/env bash

# Script to append ML Engineering host mappings to /etc/hosts
HOST_IP="127.0.0.1"

echo "Adding ML Engineering hosts to /etc/hosts with IP: $HOST_IP"

# List of hostnames to add
HOSTS=(
    "kserve-gateway.local"
    "ml-pipeline-ui.local"
    "mlflow-server.local"
    "mlflow-minio-ui.local"
    "mlflow-minio.local"
    "prometheus-server.local"
    "grafana-server.local"
    "evidently-monitor-ui.local"
)

# Append each hostname to /etc/hosts if it does not already exist
for host in "${HOSTS[@]}"; do
    if ! grep -q "$host" /etc/hosts; then
        echo "$HOST_IP $host" | sudo tee -a /etc/hosts > /dev/null
        echo "Added: $HOST_IP $host"
    else
        echo "Skipped (already exists): $host"
    fi
done

echo "Done updating /etc/hosts."
