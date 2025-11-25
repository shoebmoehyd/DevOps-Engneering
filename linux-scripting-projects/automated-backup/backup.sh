#!/bin/bash

################################################################################
# Automated Backup Script
# Description: Backs up directories with compression and rotation
# Usage: ./backup.sh [source_directory] [backup_destination]
################################################################################

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
LOG_FILE="backup_$(date '+%Y%m%d').log"
KEEP_BACKUPS=7  # Keep last 7 backups

# Function: Log messages
log_message() {
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    echo "$message" | tee -a "$LOG_FILE"
}

# Function: Print usage
show_usage() {
    echo "Usage: $0 <source_directory> <backup_destination>"
    echo ""
    echo "Example:"
    echo "  $0 /home/user/documents /backup/location"
    echo ""
    echo "The script will:"
    echo "  - Create compressed backup (tar.gz)"
    echo "  - Add timestamp to filename"
    echo "  - Keep last $KEEP_BACKUPS backups"
    echo "  - Log all operations"
}

# Check arguments
if [ $# -ne 2 ]; then
    echo -e "${RED}Error: Invalid number of arguments${NC}"
    show_usage
    exit 1
fi

SOURCE_DIR="$1"
BACKUP_DIR="$2"

# Validate source directory
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}Error: Source directory does not exist: $SOURCE_DIR${NC}"
    exit 1
fi

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}Creating backup directory: $BACKUP_DIR${NC}"
    mkdir -p "$BACKUP_DIR"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to create backup directory${NC}"
        exit 1
    fi
fi

# Generate backup filename
SOURCE_NAME=$(basename "$SOURCE_DIR")
BACKUP_FILE="${BACKUP_DIR}/${SOURCE_NAME}_backup_${TIMESTAMP}.tar.gz"

# Start backup
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  AUTOMATED BACKUP${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Source:      $SOURCE_DIR"
echo "Destination: $BACKUP_FILE"
echo "Started:     $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

log_message "Starting backup of $SOURCE_DIR"

# Create compressed backup
echo -e "${YELLOW}Creating backup...${NC}"
tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" 2>&1 | tee -a "$LOG_FILE"

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo -e "${GREEN}✓ Backup created successfully!${NC}"
    echo "  File: $BACKUP_FILE"
    echo "  Size: $BACKUP_SIZE"
    log_message "Backup created successfully: $BACKUP_FILE ($BACKUP_SIZE)"
else
    echo -e "${RED}✗ Backup failed!${NC}"
    log_message "ERROR: Backup failed for $SOURCE_DIR"
    exit 1
fi

# Cleanup old backups
echo ""
echo -e "${YELLOW}Cleaning up old backups (keeping last $KEEP_BACKUPS)...${NC}"

OLD_BACKUPS=$(ls -t "${BACKUP_DIR}/${SOURCE_NAME}_backup_"*.tar.gz 2>/dev/null | tail -n +$((KEEP_BACKUPS + 1)))

if [ -n "$OLD_BACKUPS" ]; then
    echo "$OLD_BACKUPS" | while read -r old_backup; do
        echo "  Removing: $(basename "$old_backup")"
        rm -f "$old_backup"
        log_message "Removed old backup: $old_backup"
    done
    echo -e "${GREEN}✓ Cleanup completed${NC}"
else
    echo -e "${GREEN}✓ No old backups to remove${NC}"
fi

# Summary
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Backup completed successfully!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Summary:"
echo "  Backup file: $BACKUP_FILE"
echo "  Size: $BACKUP_SIZE"
echo "  Log file: $LOG_FILE"
echo "  Backups kept: $KEEP_BACKUPS"
echo ""

log_message "Backup operation completed successfully"
