#!/bin/bash

################################################################################
# Restore Script
# Description: Restores files from backup archive
# Usage: ./restore.sh <backup_file> <restore_location>
################################################################################

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function: Print usage
show_usage() {
    echo "Usage: $0 <backup_file> <restore_location>"
    echo ""
    echo "Example:"
    echo "  $0 /backup/documents_backup_20251125_143052.tar.gz /restore/here"
}

# Check arguments
if [ $# -ne 2 ]; then
    echo -e "${RED}Error: Invalid number of arguments${NC}"
    show_usage
    exit 1
fi

BACKUP_FILE="$1"
RESTORE_DIR="$2"

# Validate backup file
if [ ! -f "$BACKUP_FILE" ]; then
    echo -e "${RED}Error: Backup file does not exist: $BACKUP_FILE${NC}"
    exit 1
fi

# Create restore directory if needed
if [ ! -d "$RESTORE_DIR" ]; then
    echo -e "${YELLOW}Creating restore directory: $RESTORE_DIR${NC}"
    mkdir -p "$RESTORE_DIR"
fi

# Start restore
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  RESTORE FROM BACKUP${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Backup file:    $BACKUP_FILE"
echo "Restore to:     $RESTORE_DIR"
echo "Started:        $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# Extract backup
echo -e "${YELLOW}Extracting backup...${NC}"
tar -xzf "$BACKUP_FILE" -C "$RESTORE_DIR"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Restore completed successfully!${NC}"
    echo ""
    echo "Restored files:"
    ls -lh "$RESTORE_DIR"
else
    echo -e "${RED}✗ Restore failed!${NC}"
    exit 1
fi
