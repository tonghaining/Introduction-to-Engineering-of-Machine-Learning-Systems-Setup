# Introduction to ML Engineering – Local Setup Instructions

> **Note:** All setup steps below are meant to be run on your **local laptop**, not on the remote virtual machines.

---

## 1. Update ssh config
To simplify connecting to the remote virtual machines (VMs) and forwarding ports for MLflow, you need to update your SSH configuration file (`~/.ssh/config`).
   0. On Linux/Mac `chmod 600 <path_to_private_key_file>`
   1. Open the SSH config file:
      - On Linux/macOS:
         ```bash
         nano ~/.ssh/config
         ```
      - On Windows, open the file located at  `C:\Users\<your-username>\.ssh\config` using a text editor like Notepad.
   2. Add the following entries (replace the IPs and key path):
      ```
      Host client-mlops
         HostName <client-vm-ip>
         User student
         IdentityFile <path-to-private-key>

      Host remote-mlops
         HostName <remote-vm-ip>
         User student
         IdentityFile <path-to-private-key>
         LocalForward 5000 127.0.0.1:5000
         LocalForward 9000 127.0.0.1:9000
         LocalForward 9001 127.0.0.1:9001
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
- On Linux/macOS/Windows (PowerShell):  (Note, it will "hang", saying nothing when it works as intended)
  ```bash
  ssh -N remote-mlops
  ```

This command will:
- Use the SSH alias remote-mlops from your ~/.ssh/config.
- Forward MLflow ports on the remote MLflow server to your localhost.
- Keep this SSH session open while you work with the MLflow web UI.

You can now access MLflow (`http://127.0.0.1:5000`) and the MLflow Tracking UI (`http://127.0.0.1:9000`) and MLflow Model Registry UI (`http://127.0.0.1:9001`) on your local machine via your web browser.


## 3. Open VS Code with Remote-SSH
After adding hosts and connecting MLflow, you can use VS Code Remote-SSH to access the code on the remote environment

Steps:
1. Open VS Code on your local laptop.

2. Install the Remote - SSH extension (if not already installed).

3. Click on the green "><" icon in the bottom-left corner of VS Code. Select "Remote-SSH: Connect to Host..." and choose `client-mlops` from the list. **NOTE: choose `client-mlops`, not `remote-mlops`.**

4. Once connected, open the folder `/home/student/Introduction-to-Engineering-of-Machine-Learning-Systems` to access the course materials. 

5. When running a code cell for the first time, VS Code will ask you to choose a Python interpreter.
Select:
**Python Environments** → `mlops_eng`

6. You're all set! You can now explore the notebooks, run MLflow experiments, and work with the full MLOps platform.
