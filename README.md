# How to set up backups with Rsync

## Step 1 - Create backup user
```bash
sudo useradd -m -s /sbin/nologin backupuser
```

## Step 2 - Rsync installation (Rocky/RHEL Example)
```bash
sudo dnf in rsync
```

## Step 3 - Backup Directory
```bash
sudo mkdir -p /home/backupuser/backups
sudo chown backupuser:backupuser /home/backupuser/backups
```

## Step 4 - SSH Setup
On the **client**:
```bash
ssh-keygen -t ed25519 -f ~/.ssh/backup_rsync -N ""
cat ~/.ssh/backup_rsync.pub
```

Copy the file to ~/.ssh/authorized_keys on the **server**. Be sure to restrict it so that it can only access the backup directory. Here is an example.
Use root if necessary, if not needed then use user
```
command="rsync --server --sender -logDtpre.i . backups",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding ssh-rsa iusdGDUIGSAIUFGHihwjerdhtuigerb backup-client
```
For extra security, you can restrict the device to only be able to backup to a certain directory. Example with Home Assistant:
```
from="10.1.1.7",command="rsync --server --receiver -logDtpre . ~/backups/homeassistant",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding ssh-rsa iusdGDUIGSAIUFGHihwjerdhtuigerb homeassistant
```
If you restrict the directory, set the script like this:
```bash
REMOTE_DIR="/home/backupuser/backups/homeassistant"
```

## Step 5 - Client Setup
Install tar + rsync
```bash
sudo dnf in rsync tar
```

Download script, edit to your liking, and make executable
```bash
chmod +x main.sh
```

## Step 7 - Automation

Use either **cron** or **systemd** for this. Below is a cron example. On the client:

```bash
git clone https://github.com/dylankrish/rsync-backup.git
crontab -e
```

Add the following lines:
```
30 2 * * * /home/youruser/backup.sh >> /home/youruser/backup.log 2>&1
```
This script will run daily at 2:30 AM defined by "30 2" at the beginning of the crontab file. Verify that your cronjob is installed using:
```bash
crontab -l
```
