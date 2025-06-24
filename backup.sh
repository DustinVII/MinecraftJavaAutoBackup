#!/bin/bash

# === CONFIGURATION ===
SERVER_DIR="/minecraft-java-server"
WORLD_NAME="unasat"
BACKUP_DIR="/minecraft-java-server/backups"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_FILE="$BACKUP_DIR/${WORLD_NAME}_backup-$TIMESTAMP.tar.gz"

# === WORLD PATHS ===
WORLD_DIR="$SERVER_DIR/$WORLD_NAME"
NETHER_DIR="$SERVER_DIR/${WORLD_NAME}_nether"
END_DIR="$SERVER_DIR/${WORLD_NAME}_the_end"
PLUGINS_DIR="$SERVER_DIR/plugins"
PROPERTIES_FILE="$SERVER_DIR/server.properties"

# === SETTINGS ===
CHECK_ACTIVITY=true  # set to false to always back up

# === ACTIVITY CHECK (if enabled) ===
should_backup=true

if [ "$CHECK_ACTIVITY" = true ]; then
    activity_found=$(find "$WORLD_DIR/playerdata" "$WORLD_DIR/region" \
                          "$NETHER_DIR/DIM-1/region" \
                          "$END_DIR/DIM1/region" \
                          -type f -mmin -15 2>/dev/null | head -n 1)
    if [ -z "$activity_found" ]; then
        should_backup=false
    fi
fi

# === EXECUTE BACKUP ===
if [ "$should_backup" = true ]; then
    echo "[$TIMESTAMP] Backing up '$WORLD_NAME' + plugins + config..."
    mkdir -p "$BACKUP_DIR"
    tar -czf "$BACKUP_FILE" -C "$SERVER_DIR" \
        "$WORLD_NAME" "${WORLD_NAME}_nether" "${WORLD_NAME}_the_end" \
        plugins server.properties
    echo "[$TIMESTAMP] Backup complete: $BACKUP_FILE"
else
    echo "[$TIMESTAMP] No activity. Backup skipped."
fi

# === SMART CLEANUP: Keep at least 15 backups, remove older than 20 days ===
all_backups=($(ls -1t "$BACKUP_DIR"/*.tar.gz 2>/dev/null)) # sorted newest first
total_backups=${#all_backups[@]}

if [ "$total_backups" -gt 15 ]; then
    echo "[$TIMESTAMP] Checking for old backups to delete..."

    # Loop from the 16th backup onward
    for ((i=15; i<total_backups; i++)); do
        file="${all_backups[$i]}"
        # Only delete if older than 20 days
        if [ "$(find "$file" -mtime +20)" ]; then
            echo "Deleting old backup: $file"
            rm -f "$file"
        fi
    done
fi