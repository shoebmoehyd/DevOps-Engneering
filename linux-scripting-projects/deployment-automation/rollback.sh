#!/bin/bash

# ---------------------------------------------
# Rollback Script
# Restore previous deployment from backup
# ---------------------------------------------

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
DEPLOYMENT_DIR="/var/www/app"
BACKUP_DIR="/var/www/backups"
APP_SERVICE="myapp"

# Check arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 user@server"
    exit 1
fi

SERVER=$1

echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║           ROLLBACK v1.0                ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Server:${NC} $SERVER"
echo ""

# List available backups
echo -e "${YELLOW}Available backups:${NC}"
ssh "$SERVER" "ls -lh $BACKUP_DIR/*.tar.gz 2>/dev/null | awk '{print NR\". \"$9\" (\"$5\")\"}'" || {
    echo -e "${RED}No backups found${NC}"
    exit 1
}

echo ""
echo -n "Select backup number to restore: "
read backup_num

# Get selected backup
backup_file=$(ssh "$SERVER" "ls $BACKUP_DIR/*.tar.gz 2>/dev/null" | sed -n "${backup_num}p")

if [ -z "$backup_file" ]; then
    echo -e "${RED}Invalid selection${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Rolling back to: $(basename $backup_file)${NC}"
echo ""

# Stop service
echo -n "Stopping service... "
ssh "$SERVER" "systemctl stop $APP_SERVICE 2>/dev/null || service $APP_SERVICE stop 2>/dev/null || true"
echo -e "${GREEN}✓${NC}"

# Restore backup
echo -n "Restoring backup... "
if ssh "$SERVER" "rm -rf $DEPLOYMENT_DIR/* && tar -xzf $backup_file -C $DEPLOYMENT_DIR"; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗ Failed${NC}"
    exit 1
fi

# Start service
echo -n "Starting service... "
ssh "$SERVER" "systemctl start $APP_SERVICE 2>/dev/null || service $APP_SERVICE start 2>/dev/null || true"
echo -e "${GREEN}✓${NC}"

# Health check
echo -n "Health check... "
sleep 2
if ssh "$SERVER" "systemctl is-active --quiet $APP_SERVICE 2>/dev/null || pgrep -x $APP_SERVICE >/dev/null"; then
    echo -e "${GREEN}✓ Healthy${NC}"
else
    echo -e "${RED}✗ Service not running${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ Rollback successful!${NC}"
