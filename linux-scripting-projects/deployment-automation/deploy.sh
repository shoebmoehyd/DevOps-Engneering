#!/bin/bash

# ---------------------------------------------
# Deployment Automation Script
# Deploy applications to multiple servers via SSH
# Supports rollback and health checks
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

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -s, --servers    Comma-separated server list (user@host1,user@host2)"
    echo "  -f, --file       Application file/directory to deploy"
    echo "  -h, --help       Show this help message"
    echo ""
    echo "Example:"
    echo "  $0 -s root@server1,root@server2 -f ./app.tar.gz"
}

# Parse arguments
SERVERS=""
APP_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--servers)
            SERVERS="$2"
            shift 2
            ;;
        -f|--file)
            APP_FILE="$2"
            shift 2
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_usage
            exit 1
            ;;
    esac
done

# Validate inputs
if [ -z "$SERVERS" ]; then
    echo -e "${RED}Error: No servers specified${NC}"
    show_usage
    exit 1
fi

if [ -z "$APP_FILE" ]; then
    echo -e "${RED}Error: No application file specified${NC}"
    show_usage
    exit 1
fi

if [ ! -f "$APP_FILE" ]; then
    echo -e "${RED}Error: File not found: $APP_FILE${NC}"
    exit 1
fi

# Convert comma-separated servers to array
IFS=',' read -ra SERVER_ARRAY <<< "$SERVERS"

echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║    DEPLOYMENT AUTOMATION v1.0          ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Application:${NC} $APP_FILE"
echo -e "${BLUE}Servers:${NC}     ${#SERVER_ARRAY[@]}"
echo ""

# Function to deploy to a single server
deploy_to_server() {
    local server=$1
    local app_file=$2
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Deploying to: $server${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Test SSH connection
    echo -n "Testing connection... "
    if ssh -o ConnectTimeout=5 -o BatchMode=yes "$server" "echo 'connected'" &>/dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ Failed${NC}"
        return 1
    fi
    
    # Create backup directory
    echo -n "Creating backup directory... "
    if ssh "$server" "mkdir -p $BACKUP_DIR" &>/dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ Failed${NC}"
        return 1
    fi
    
    # Backup current deployment
    echo -n "Backing up current deployment... "
    timestamp=$(date +%Y%m%d_%H%M%S)
    if ssh "$server" "[ -d $DEPLOYMENT_DIR ] && tar -czf $BACKUP_DIR/backup_$timestamp.tar.gz -C $DEPLOYMENT_DIR . 2>/dev/null || true" &>/dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}⚠ No previous deployment${NC}"
    fi
    
    # Stop service
    echo -n "Stopping service... "
    ssh "$server" "systemctl stop $APP_SERVICE 2>/dev/null || service $APP_SERVICE stop 2>/dev/null || true" &>/dev/null
    echo -e "${GREEN}✓${NC}"
    
    # Copy new application
    echo -n "Copying application files... "
    if scp -q "$app_file" "$server:/tmp/app_deploy.tar.gz"; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ Failed${NC}"
        return 1
    fi
    
    # Extract application
    echo -n "Extracting application... "
    if ssh "$server" "mkdir -p $DEPLOYMENT_DIR && tar -xzf /tmp/app_deploy.tar.gz -C $DEPLOYMENT_DIR && rm /tmp/app_deploy.tar.gz" &>/dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ Failed${NC}"
        return 1
    fi
    
    # Set permissions
    echo -n "Setting permissions... "
    if ssh "$server" "chown -R www-data:www-data $DEPLOYMENT_DIR 2>/dev/null || chmod -R 755 $DEPLOYMENT_DIR" &>/dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}⚠ Warning${NC}"
    fi
    
    # Start service
    echo -n "Starting service... "
    if ssh "$server" "systemctl start $APP_SERVICE 2>/dev/null || service $APP_SERVICE start 2>/dev/null || true" &>/dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}⚠ Manual start required${NC}"
    fi
    
    # Health check
    echo -n "Health check... "
    sleep 2
    if ssh "$server" "systemctl is-active --quiet $APP_SERVICE 2>/dev/null || pgrep -x $APP_SERVICE >/dev/null 2>&1"; then
        echo -e "${GREEN}✓ Healthy${NC}"
    else
        echo -e "${RED}✗ Service not running${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✓ Deployment successful!${NC}"
    echo ""
    return 0
}

# Deploy to all servers
SUCCESSFUL=0
FAILED=0

for server in "${SERVER_ARRAY[@]}"; do
    if deploy_to_server "$server" "$APP_FILE"; then
        ((SUCCESSFUL++))
    else
        ((FAILED++))
        echo -e "${RED}Deployment to $server failed!${NC}"
        echo ""
    fi
done

# Summary
echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║         DEPLOYMENT SUMMARY             ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Successful:${NC} $SUCCESSFUL"
echo -e "${RED}Failed:${NC}     $FAILED"
echo -e "Total:      ${#SERVER_ARRAY[@]}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All deployments completed successfully!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠ Some deployments failed${NC}"
    exit 1
fi
