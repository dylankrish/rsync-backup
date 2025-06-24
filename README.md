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
# use root if necessary, if not needed then use user
```
command="rsync --server --sender -logDtpre.i . backups",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding ssh-rsa iusdGDUIGSAIUFGHihwjerdhtuigerb root@test-example
```

## Step 5 - Client Setup
Install tar + rsync
```
sudo dnf in rsync tar
```

Download script and make executable
```
chmod +x main.sh
```

## Step 7 - Automation

Use either **cron** or **systemd** for this.
