# Introduction to ML Engineering – Local Setup Instructions

> **Note:** All setup steps below are meant to be run on your **local laptop**, not on the remote virtual machines.

---

## 1. Add Host Entries

Before connecting to any remote services, you need to ensure your system can resolve the required local hostnames.

### Run the script
- On Linux/macOS:
```bash
./add_hosts.sh
```
- On Windows (PowerShell):
```powershell
.\add_hosts.ps1
```
This script will append the following entries to your `/etc/hosts` file:

```plaintext
127.0.0.1 kserve-gateway.local
127.0.0.1 ml-pipeline-ui.local
127.0.0.1 mlflow-server.local
127.0.0.1 mlflow-minio-ui.local
127.0.0.1 mlflow-minio.local
127.0.0.1 prometheus-server.local
127.0.0.1 grafana-server.local
127.0.0.1 evidently-monitor-ui.local
```
These entries map the service hostnames to your local machine so that your browser and scripts can reach them via `127.0.0.1`.

### Manual alternative (if the script fails)

1. Open the hosts file with a text editor (you will need admin/root privileges):

   - On Linux/macOS:
     ```bash
     sudo nano /etc/hosts
     ```
  - On Windows, open Notepad as Administrator and then open the file located at `C:\Windows\System32\drivers\etc\hosts`.

2. Add the above lines to the end of the file and save.
3. Verify by pinging a host, e.g.:
   ```bash
   ping mlflow-server.local
   ```

## 2. Update ssh config

To make connecting easier, update your SSH configuration using the provided script:

   - On Linux/macOS:
      ```bash
      ./update_ssh_config.sh <local-vm-ip> <remote-vm-ip> <path-to-private-key>
      ```
   - On Windows:
      ```bash
      ./update_ssh_config.ps1 <local-vm-ip> <remote-vm-ip> <path-to-private-key>
      ```

This script will updates your ~/.ssh/config with three host entries:

   - local-mlops
   Connects directly to the local VM using the provided private key.

   - remote-mlops
   Connects directly to the remote VM using the same key.

   - remote-mlops-jump
   Connects to the remote VM through the local VM using ProxyJump.

If the Script Fails: Manual Setup
   1. Open the SSH config file:
      - On Linux/macOS:
         ```bash
         nano ~/.ssh/config
         ```
      - On Windows, open the file located at  `~\.ssh\config`
   2. Add the following entries (replace the IPs and key path):
      ```
      Host local-mlops
         HostName <local-vm-ip>
         User ubuntu
         IdentityFile <path-to-private-key>

      Host remote-mlops
         HostName <remote-vm-ip>
         User ubuntu
         IdentityFile <path-to-private-key>

      Host remote-mlops-jump
         HostName <remote-vm-ip>
         User ubuntu
         ProxyJump local-mlops
      ```
   3. Save and exit.

   4. Add your key to the ssh-agent:
      ```bash
         eval "$(ssh-agent -s)"
         ssh-add <path-to-private-key>
      ```      

## 3. Connect to MLflow
Next, you need to establish an SSH connection with port forwarding so that your local machine can access the remote MLflow service.

### Run the connection script
- On Linux/macOS:
  ```bash
  ./connect_mlflow.sh
  ```
- On Windows (PowerShell):
  ```powershell
  .\connect_mlflow.ps1
  ```

This script will:
- Use the SSH alias remote-mlops from your ~/.ssh/config.
- Forward port 80 on the remote MLflow server to localhost:8080.
- Keep the SSH session open while you work with the MLflow web UI.

You can now access MLflow in your browser: `http://mlflow-server.local:8080`

### Manual alternative (if the script fails)
1. Ensure your `~/.ssh/config` has a host entry like:
   ```
   Host remote-mlops
    HostName <REMOTE_IP>
    User all_student
    IdentityFile <PATH_TO_PRIVATE_KEY>
    ```
2. Run the SSH command with port forwarding:
   ```bash
   ssh -i <PATH_TO_PRIVATE_KEY> -L 8080:localhost:80 all_student@<REMOTE_IP>
   ```
3. Access MLflow in your browser: `http://mlflow-server.local:8080`

## 4. Open VS Code with Remote-SSH
After adding hosts and connecting MLflow, you can use VS Code Remote-SSH to access the code on the remote environment

Steps:
1. Open VS Code on your local laptop.

2. Install the Remote - SSH extension (if not already installed).

3. Click on the green "><" icon in the bottom-left corner of VS Code. Select "Remote-SSH: Connect to Host..." and choose `local-mlops` from the list. **NOTE: choose `local-mlops`, not `remote-mlops`.**

4. Once connected, open the folder `/home/student/Introduction-to-Engineering-of-Machine-Learning-Systems` to access the course materials. You are now ready to explore the notebooks, run MLflow experiments, and work with the MLOps platform.
