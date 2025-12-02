# Script to add SSH config entries for MLops setup
# Usage: .\update_ssh_config.ps1 -LocalIP <local-vm-ip> -RemoteIP <remote-vm-ip> -KeyPath <path-to-private-key>

param(
    [Parameter(Mandatory=$true)][string]$LocalIP,
    [Parameter(Mandatory=$true)][string]$RemoteIP,
    [Parameter(Mandatory=$true)][string]$KeyPath
)

$sshDir = "$env:USERPROFILE\.ssh"
$configFile = "$sshDir\config"

# Ensure .ssh exists
if (-not (Test-Path $sshDir)) { New-Item -ItemType Directory -Path $sshDir }

# Backup existing config
if (Test-Path $configFile) {
    Copy-Item $configFile "$configFile.bak.$((Get-Date).ToString('yyyyMMddHHmmss'))"
}

Write-Host "Updating SSH config at $configFile..."

# Prepare entries
$entries = @"
Host local-mlops
    HostName $LocalIP
    User ubuntu
    IdentityFile $KeyPath

Host remote-mlops
    HostName $RemoteIP
    User ubuntu
    IdentityFile $KeyPath
    LocalForward 5000 127.0.0.1:5000
    LocalForward 9000 127.0.0.1:9000
    LocalForward 9001 127.0.0.1:9001

Host remote-mlops-jump
    HostName $RemoteIP
    User ubuntu
    ProxyJump local-mlops
"@

# Remove existing lines for these hosts
$existingLines = @()
if (Test-Path $configFile) {
    $skip = $false
    foreach ($line in Get-Content $configFile) {
        if ($line -match '^Host (local-mlops|remote-mlops|remote-mlops-jump)$') {
            $skip = $true
            continue
        }
        if ($line -match '^Host ') { $skip = $false }
        if (-not $skip) { $existingLines += $line }
    }
}

# Write new config
$existingLines + $entries | Set-Content $configFile -Encoding UTF8

Write-Host "SSH config updated successfully."

Write-Host "Adding key to ssh-agent..."
Start-Service ssh-agent -ErrorAction SilentlyContinue
ssh-add $KeyPath

Write-Host "You can now use 'ssh local-mlops', 'ssh remote-mlops', or 'ssh remote-mlops-jump'."
