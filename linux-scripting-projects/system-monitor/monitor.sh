#!/bin/bash

# ---------------------
# System Monitor Script
# Description: Monitors CPU, memory, disk usage and running processes
# Usage: ./monitor.sh
# ---------------------

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Print header
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  SYSTEM MONITOR - $(date '+%Y-%m-%d %H:%M:%S')${NC}"
echo -e "${BLUE}========================================${NC}\n"

# System Information
echo -e "${BLUE}--- SYSTEM INFORMATION ---${NC}"
echo "Hostname: $(hostname)"
echo "Uptime:   $(uptime -p 2>/dev/null || uptime)"
echo ""

# CPU Usage
echo -e "${BLUE}--- CPU USAGE ---${NC}"
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
echo "CPU Usage: ${cpu_usage}%"

if (( $(echo "$cpu_usage > 80" | bc -l 2>/dev/null || echo 0) )); then
    echo -e "${RED}⚠️  High CPU usage!${NC}"
elif (( $(echo "$cpu_usage > 50" | bc -l 2>/dev/null || echo 0) )); then
    echo -e "${YELLOW}⚠️  Moderate CPU usage${NC}"
else
    echo -e "${GREEN}✓ Normal${NC}"
fi

echo -e "\nTop 5 CPU processes:"
ps aux --sort=-%cpu | head -6 | tail -5 | awk '{printf "  %s - %.1f%%\n", $11, $3}'
echo ""

# Memory Usage
echo -e "${BLUE}--- MEMORY USAGE ---${NC}"
free -h | awk 'NR==1{print "  "$0} NR==2{print "  "$0}'
mem_percent=$(free | awk '/^Mem:/ {printf "%.1f", $3/$2 * 100}')
echo "Memory Usage: ${mem_percent}%"

if (( $(echo "$mem_percent > 80" | bc -l 2>/dev/null || echo 0) )); then
    echo -e "${RED}⚠️  High memory usage!${NC}"
elif (( $(echo "$mem_percent > 60" | bc -l 2>/dev/null || echo 0) )); then
    echo -e "${YELLOW}⚠️  Moderate memory usage${NC}"
else
    echo -e "${GREEN}✓ Normal${NC}"
fi
echo ""

# Disk Usage
echo -e "${BLUE}--- DISK USAGE ---${NC}"
df -h | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{printf "  %-20s %s used of %s (%s)\n", $6, $3, $2, $5}'
echo ""

# Process Count
echo -e "${BLUE}--- PROCESSES ---${NC}"
echo "Total:   $(ps aux | wc -l) processes"
echo "Running: $(ps aux | grep -c ' R ')"
echo "Sleeping: $(ps aux | grep -c ' S ')"
echo ""

echo -e "${GREEN}✓ Monitoring complete!${NC}"

