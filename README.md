# Minecraft Java Auto Backup

This project contains simple, automated shell scripts to back up and restore a Minecraft Java Edition server running on Linux. It supports multi-dimension world backups, plugin folder archiving, and conditional backups based on recent player activity.

---

## 🚀 Features

- Backs up:
  - Overworld, Nether, and End dimensions
  - `plugins/` folder
  - `server.properties` file
- Optionally checks for recent player activity (file modification)
- Deletes old backups after a set number of days
- Easy restore from a specific backup file
- Runs on any Linux-based VPS or local setup

## 🔧 Configuration

Edit the following variables in `backup.sh` and `restore_backup.sh` as needed:

```bash
SERVER_DIR="/minecraft-java-server/server"
WORLD_NAME="unasat"
BACKUP_DIR="/minecraft-java-server/backups"
```

To disable the activity check (always create backups):
```
CHECK_ACTIVITY=false
```

## Usage
**Backup script** 
`backups/backup.sh`
Recommended to run via cron every 15 minutes:

```bash
*/15 * * * * /path/to/backups/backup.sh >> /path/to/backup.log 2>&1
```

**Restore script**
`backups/restore_backup.sh`
or specify directly:
`backups/restore_backup.sh unasat_backup-20250623-093700.tar.gz`
The script will stop the server, extract the backup, and restart the server.