#!/bin/bash

# ---------------------------------------------
# Service Manager Script
# Manage services, check status, and monitor health
# Interactive menu-driven interface
# ---------------------------------------------

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if running as root for certain operations
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${YELLOW}Warning: Some operations require sudo privileges${NC}"
        echo ""
    fi
}

# Function to show menu
show_menu() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║      SERVICE MANAGER v1.0              ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo "1. List All Services"
    echo "2. Check Service Status"
    echo "3. Start a Service"
    echo "4. Stop a Service"
    echo "5. Restart a Service"
    echo "6. Enable Service (Auto-start)"
    echo "7. Disable Service (No Auto-start)"
    echo "8. Show Failed Services"
    echo "9. Monitor Service (Real-time)"
    echo "10. Exit"
    echo ""
    echo -n "Choose an option [1-10]: "
}

# List all services
list_services() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}ALL SERVICES${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if command -v systemctl &> /dev/null; then
        systemctl list-units --type=service --all | head -20
        echo ""
        echo -e "${YELLOW}Showing first 20 services. Use 'systemctl list-units --type=service' for full list.${NC}"
    else
        echo -e "${RED}systemctl not found. Trying service command...${NC}"
        service --status-all 2>/dev/null | head -20
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Check service status
check_status() {
    echo ""
    echo -n "Enter service name (e.g., ssh, nginx, docker): "
    read service_name
    
    if [ -z "$service_name" ]; then
        echo -e "${RED}Service name cannot be empty${NC}"
        sleep 2
        return
    fi
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}STATUS: $service_name${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if command -v systemctl &> /dev/null; then
        systemctl status "$service_name" --no-pager 2>&1
    else
        service "$service_name" status 2>&1
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Start service
start_service() {
    echo ""
    echo -n "Enter service name to start: "
    read service_name
    
    if [ -z "$service_name" ]; then
        echo -e "${RED}Service name cannot be empty${NC}"
        sleep 2
        return
    fi
    
    echo ""
    echo -e "${YELLOW}Starting $service_name...${NC}"
    
    if command -v systemctl &> /dev/null; then
        sudo systemctl start "$service_name" 2>&1
    else
        sudo service "$service_name" start 2>&1
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Service started successfully${NC}"
    else
        echo -e "${RED}✗ Failed to start service${NC}"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Stop service
stop_service() {
    echo ""
    echo -n "Enter service name to stop: "
    read service_name
    
    if [ -z "$service_name" ]; then
        echo -e "${RED}Service name cannot be empty${NC}"
        sleep 2
        return
    fi
    
    echo ""
    echo -e "${YELLOW}Stopping $service_name...${NC}"
    
    if command -v systemctl &> /dev/null; then
        sudo systemctl stop "$service_name" 2>&1
    else
        sudo service "$service_name" stop 2>&1
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Service stopped successfully${NC}"
    else
        echo -e "${RED}✗ Failed to stop service${NC}"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Restart service
restart_service() {
    echo ""
    echo -n "Enter service name to restart: "
    read service_name
    
    if [ -z "$service_name" ]; then
        echo -e "${RED}Service name cannot be empty${NC}"
        sleep 2
        return
    fi
    
    echo ""
    echo -e "${YELLOW}Restarting $service_name...${NC}"
    
    if command -v systemctl &> /dev/null; then
        sudo systemctl restart "$service_name" 2>&1
    else
        sudo service "$service_name" restart 2>&1
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Service restarted successfully${NC}"
    else
        echo -e "${RED}✗ Failed to restart service${NC}"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Enable service
enable_service() {
    echo ""
    echo -n "Enter service name to enable (auto-start on boot): "
    read service_name
    
    if [ -z "$service_name" ]; then
        echo -e "${RED}Service name cannot be empty${NC}"
        sleep 2
        return
    fi
    
    echo ""
    echo -e "${YELLOW}Enabling $service_name...${NC}"
    
    if command -v systemctl &> /dev/null; then
        sudo systemctl enable "$service_name" 2>&1
    else
        echo -e "${YELLOW}Enable command may vary by init system${NC}"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Service enabled successfully${NC}"
    else
        echo -e "${RED}✗ Failed to enable service${NC}"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Disable service
disable_service() {
    echo ""
    echo -n "Enter service name to disable (no auto-start): "
    read service_name
    
    if [ -z "$service_name" ]; then
        echo -e "${RED}Service name cannot be empty${NC}"
        sleep 2
        return
    fi
    
    echo ""
    echo -e "${YELLOW}Disabling $service_name...${NC}"
    
    if command -v systemctl &> /dev/null; then
        sudo systemctl disable "$service_name" 2>&1
    else
        echo -e "${YELLOW}Disable command may vary by init system${NC}"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Service disabled successfully${NC}"
    else
        echo -e "${RED}✗ Failed to disable service${NC}"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Show failed services
show_failed() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}FAILED SERVICES${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if command -v systemctl &> /dev/null; then
        failed=$(systemctl list-units --type=service --state=failed --no-pager)
        if [ -z "$failed" ]; then
            echo -e "${GREEN}No failed services!${NC}"
        else
            echo "$failed"
        fi
    else
        echo -e "${YELLOW}Failed service detection requires systemctl${NC}"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Monitor service in real-time
monitor_service() {
    echo ""
    echo -n "Enter service name to monitor: "
    read service_name
    
    if [ -z "$service_name" ]; then
        echo -e "${RED}Service name cannot be empty${NC}"
        sleep 2
        return
    fi
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}MONITORING: $service_name${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop monitoring${NC}"
    echo ""
    
    if command -v systemctl &> /dev/null; then
        sudo journalctl -u "$service_name" -f
    else
        echo -e "${YELLOW}Real-time monitoring requires journalctl (systemd)${NC}"
        echo "Showing recent logs instead:"
        tail -f "/var/log/$service_name.log" 2>/dev/null || echo "Log file not found"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Main execution
check_root

while true; do
    show_menu
    read choice
    
    case $choice in
        1)
            list_services
            ;;
        2)
            check_status
            ;;
        3)
            start_service
            ;;
        4)
            stop_service
            ;;
        5)
            restart_service
            ;;
        6)
            enable_service
            ;;
        7)
            disable_service
            ;;
        8)
            show_failed
            ;;
        9)
            monitor_service
            ;;
        10)
            echo ""
            echo -e "${GREEN}✓ Goodbye!${NC}"
            echo ""
            exit 0
            ;;
        *)
            echo ""
            echo -e "${RED}Invalid option. Please choose 1-10${NC}"
            sleep 2
            ;;
    esac
done
