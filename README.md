# Introduction to ML Engineering – Local Setup Instructions

> **Note:** All setup steps below are meant to be run on your **local laptop**, not on the remote virtual machines.

---

## 1. Update ssh config

To make connecting easier, update your SSH configuration using the provided script:

   - On Linux/macOS:
      ```bash
      ./update_ssh_config.sh <local-vm-ip> <remote-vm-ip> <path-to-private-key>
      ```
   - On Windows:
      ```bash
      ./update_ssh_config.ps1 <local-vm-ip> <remote-vm-ip> <path-to-private-key>
      ```

This script will updates your `~/.ssh/config` with three host entries:

   - local-mlops
   Connects directly to the local VM using the provided private key.

   - remote-mlops
   Connects directly to the remote VM using the same key. It also sets up local port forwarding for MLflow ports (5000, 9000, 9001).

   - remote-mlops-jump
   Connects to the remote VM through the local VM using ProxyJump.

If the Script Fails: Manual Setup
   0. On Linux/Mac `chmod 600 <path_to_private_key_file>`
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
         User student
         IdentityFile <path-to-private-key>

      Host remote-mlops
         HostName <remote-vm-ip>
         User student
         IdentityFile <path-to-private-key>
         LocalForward 5000 127.0.0.1:5000
         LocalForward 9000 127.0.0.1:9000
         LocalForward 9001 127.0.0.1:9001

      Host remote-mlops-jump
         HostName <remote-vm-ip>
         User student
         ProxyJump local-mlops
      ```
   3. Save and exit.

   4. Add your key to the ssh-agent:
      ```bash
         eval "$(ssh-agent -s)"
         ssh-add <path-to-private-key>
      ```      

## 2. Connect to MLflow
Next, you need to establish an SSH connection with port forwarding so that your local machine can access the remote MLflow service.

### Connect using the **Remote** SSH alias
- On Linux/macOS/Windows (PowerShell):
  ```bash
  ssh -N remote-mlops
  ```

This command will:
- Use the SSH alias remote-mlops from your ~/.ssh/config.
- Forward MLflow ports on the remote MLflow server to localhost.
- Keep the SSH session open while you work with the MLflow web UI.

You can now access MLflow (`http://127.0.0.1:5000`) and the MLflow Tracking UI (`http://127.0.0.1:9000`) and MLflow Model Registry UI (`http://127.0.0.1:9001`) on your local machine via your web browser.


## 3. Open VS Code with Remote-SSH
After adding hosts and connecting MLflow, you can use VS Code Remote-SSH to access the code on the remote environment

Steps:
1. Open VS Code on your local laptop.

2. Install the Remote - SSH extension (if not already installed).

3. Click on the green "><" icon in the bottom-left corner of VS Code. Select "Remote-SSH: Connect to Host..." and choose `local-mlops` from the list. **NOTE: choose `local-mlops`, not `remote-mlops`.**

4. Once connected, open the folder `/home/student/Introduction-to-Engineering-of-Machine-Learning-Systems` to access the course materials. You are now ready to explore the notebooks, run MLflow experiments, and work with the MLOps platform.
