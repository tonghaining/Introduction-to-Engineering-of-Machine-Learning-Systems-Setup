<#
.SYNOPSIS
Connect to remote MLflow server via SSH and forward port 80 to localhost:8080.

.DESCRIPTION
This script uses the SSH config alias 'remote-mlops' to establish an SSH connection
with port forwarding. Make sure 'remote-mlops' is configured in ~/.ssh/config.

Port forwarding:
    remote:80 → localhost:8080
#>

# Ensure OpenSSH client is available
if (-not (Get-Command ssh -ErrorAction SilentlyContinue)) {
    Write-Error "OpenSSH client is not installed. Please install it first."
    exit 1
}

$SSHHost = "remote-mlops"
$LocalPort = 8080
$RemotePort = 80

Write-Host "==============================="
Write-Host " MLflow Remote Connection Setup"
Write-Host "==============================="
Write-Host ""
Write-Host "Connecting to $SSHHost ..."
Write-Host "Forwarding ports:"
Write-Host "  remote:$RemotePort → localhost:$LocalPort"
Write-Host ""

# Start SSH connection with port forwarding
ssh -N -L "$LocalPort`:localhost`:$RemotePort" $SSHHost

Write-Host ""
Write-Host "SSH session ended."
