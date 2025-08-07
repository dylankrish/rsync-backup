# How to set up backups with Rsync

### Disclaimer: Guide was created for Rocky Linux/RHEL
This guide was created for Red Hat Enterprise Linux and it's derivatives. You may need to change some commands to adapt to your setup, for example:
- The useradd command
- `apt install` instead of `dnf install`
- The location of rrsync

## Step 1 - Create backup user
```bash
sudo useradd -m backupuser
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
no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding ssh-rsa iusdGDUIGSAIUFGHihwjerdhtuigerb backup-client
```
For extra security, you can restrict the device to only be able to backup to a certain directory using rrsync (restricted rsync). Example with Home Assistant:
```
command="/usr/share/doc/rsync/support/rrsync /home/backupuser/backups/homeassistant",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding ssh-rsa iusdGDUIGSAIUFGHihwjerdhtuigerb homeassistant
```
If you restrict the directory using rrsync, set the script like this to backup to the directory shared:
```bash
REMOTE_DIR="/"
```

## Step 5 - Client Setup
Install tar + rsync
```bash
sudo dnf in rsync tar git
```

Clone repo and, edit to your liking, and make executable
```bash
git clone https://github.com/dylankrish/rsync-backup.git
cd rsync-backup
chmod +x backup.sh
```

## Step 7 - Automation

Use either **cron** or **systemd** for this. Below is a cron example. On the client:

```bash
crontab -e
```

Add the following lines:
```
30 2 * * * /home/youruser/backup.sh >> /home/youruser/backup.log 2>&1
```
This script will run daily at 2:30 AM defined by "30 2" at the beginning of the crontab file. 
If you wanted to do weekly, on Sunday for example:
```
30 2 * * 0 /home/youruser/backup.sh >> /home/youruser/backup.log 2>&1
```
Verify that your cronjob is installed using:
```bash
crontab -l
```
