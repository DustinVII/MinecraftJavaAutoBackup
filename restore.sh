#!/bin/bash

# === CONFIGURATION ===
SERVER_DIR="/minecraft-java-server/server"
BACKUP_DIR="/minecraft-java-server/backups"
SERVICE_NAME="minecraft-java.service"

# === INPUT: Get backup file name ===
if [ -z "$1" ]; then
    echo "Available backups:"
    ls -1 $BACKUP_DIR/*.tar.gz
    echo ""
    read -p "Enter the full backup filename to restore (e.g. unasat_backup-20250623-093700.tar.gz): " BACKUP_NAME
else
    BACKUP_NAME="$1"
fi

BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

# === VALIDATE ===
if [ ! -f "$BACKUP_PATH" ]; then
    echo " ^}^l Backup file not found: $BACKUP_PATH"
    exit 1
fi

# === RESTORE ===
echo " ^=^{^q Stopping Minecraft server..."
systemctl stop $SERVICE_NAME

echo " ^y   ^o Restoring from $BACKUP_PATH..."
tar -xzf "$BACKUP_PATH" -C "$SERVER_DIR"

echo " ^v   ^o Starting Minecraft server..."
systemctl start $SERVICE_NAME

echo " ^|^e Restore complete from: $BACKUP_NAME"
