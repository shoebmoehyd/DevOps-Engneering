#!/bin/bash

# ---------------------------------------------
# Log Analyzer Script
# Analyzes log files for errors, warnings, and patterns
# Interactive menu-driven interface
# ---------------------------------------------

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if log file is provided
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No log file specified${NC}"
    echo ""
    echo "Usage: $0 <log_file>"
    echo ""
    echo "Example:"
    echo "  $0 /var/log/syslog"
    echo "  $0 application.log"
    exit 1
fi

LOG_FILE="$1"

# Check if file exists
if [ ! -f "$LOG_FILE" ]; then
    echo -e "${RED}Error: File '$LOG_FILE' not found${NC}"
    exit 1
fi

# Check if file is readable
if [ ! -r "$LOG_FILE" ]; then
    echo -e "${RED}Error: No read permission for '$LOG_FILE'${NC}"
    exit 1
fi

# Function to show menu
show_menu() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║        LOG ANALYZER v1.0               ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}File: $LOG_FILE${NC}"
    echo ""
    echo "1. View Summary (All Levels)"
    echo "2. Show Errors Only"
    echo "3. Show Warnings Only"
    echo "4. Show Info Messages"
    echo "5. Show Top Error Patterns"
    echo "6. Show Recent Errors (Last 10)"
    echo "7. Exit"
    echo ""
    echo -n "Choose an option [1-7]: "
}

# Get file info
get_file_info() {
    FILE_SIZE=$(du -h "$LOG_FILE" 2>/dev/null | awk '{print $1}')
    LINE_COUNT=$(wc -l < "$LOG_FILE" 2>/dev/null)
}

# Count log levels
count_levels() {
    ERROR_COUNT=$(grep -ic "error" "$LOG_FILE" 2>/dev/null || echo 0)
    WARNING_COUNT=$(grep -ic "warning\|warn" "$LOG_FILE" 2>/dev/null || echo 0)
    INFO_COUNT=$(grep -ic "info" "$LOG_FILE" 2>/dev/null || echo 0)
    DEBUG_COUNT=$(grep -ic "debug" "$LOG_FILE" 2>/dev/null || echo 0)
}

# Show summary
show_summary() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}FILE INFORMATION${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "Size:        $FILE_SIZE"
    echo "Lines:       $LINE_COUNT"
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}LOG LEVEL SUMMARY${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}Errors:      $ERROR_COUNT${NC}"
    echo -e "${YELLOW}Warnings:    $WARNING_COUNT${NC}"
    echo -e "${BLUE}Info:        $INFO_COUNT${NC}"
    echo -e "Debug:       $DEBUG_COUNT"
    echo ""
    read -p "Press Enter to continue..."
}

# Show errors
show_errors() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}ERROR MESSAGES (Last 20)${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    if [ "$ERROR_COUNT" -gt 0 ]; then
        grep -i "error" "$LOG_FILE" | tail -20
    else
        echo "No errors found"
    fi
    echo ""
    read -p "Press Enter to continue..."
}

# Show warnings
show_warnings() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}WARNING MESSAGES (Last 20)${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    if [ "$WARNING_COUNT" -gt 0 ]; then
        grep -i "warning\|warn" "$LOG_FILE" | tail -20
    else
        echo "No warnings found"
    fi
    echo ""
    read -p "Press Enter to continue..."
}

# Show info
show_info() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}INFO MESSAGES (Last 20)${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    if [ "$INFO_COUNT" -gt 0 ]; then
        grep -i "info" "$LOG_FILE" | tail -20
    else
        echo "No info messages found"
    fi
    echo ""
    read -p "Press Enter to continue..."
}

# Show top error patterns
show_error_patterns() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}TOP 5 ERROR PATTERNS${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [ "$ERROR_COUNT" -gt 0 ]; then
        grep -i "error" "$LOG_FILE" | \
        awk '{
            match($0, /[Ee][Rr][Rr][Oo][Rr].*/)
            if (RSTART > 0) {
                msg = substr($0, RSTART)
                msg = substr(msg, 1, 60)
                count[msg]++
            }
        }
        END {
            for (msg in count) {
                printf "%4d  %s\n", count[msg], msg
            }
        }' | sort -rn | head -5
    else
        echo "No errors found"
    fi
    echo ""
    read -p "Press Enter to continue..."
}

# Show recent errors
show_recent_errors() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}RECENT ERRORS (Last 10)${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    if [ "$ERROR_COUNT" -gt 0 ]; then
        grep -i "error" "$LOG_FILE" | tail -10
    else
        echo "No errors found"
    fi
    echo ""
    read -p "Press Enter to continue..."
}

# Initialize
get_file_info
count_levels

# Main loop
while true; do
    show_menu
    read choice
    
    case $choice in
        1)
            show_summary
            ;;
        2)
            show_errors
            ;;
        3)
            show_warnings
            ;;
        4)
            show_info
            ;;
        5)
            show_error_patterns
            ;;
        6)
            show_recent_errors
            ;;
        7)
            echo ""
            echo -e "${GREEN}✓ Goodbye!${NC}"
            echo ""
            exit 0
            ;;
        *)
            echo ""
            echo -e "${RED}Invalid option. Please choose 1-7${NC}"
            sleep 2
            ;;
    esac
done
echo ""

# Get file info
FILE_SIZE=$(du -h "$LOG_FILE" | awk '{print $1}')
LINE_COUNT=$(wc -l < "$LOG_FILE")
FIRST_LINE=$(head -1 "$LOG_FILE")
LAST_LINE=$(tail -1 "$LOG_FILE")

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}FILE INFORMATION${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "Size:        $FILE_SIZE"
echo "Lines:       $LINE_COUNT"
echo ""

# Count log levels (case-insensitive)
ERROR_COUNT=$(grep -ic "error" "$LOG_FILE" 2>/dev/null || echo 0)
WARNING_COUNT=$(grep -ic "warning\|warn" "$LOG_FILE" 2>/dev/null || echo 0)
INFO_COUNT=$(grep -ic "info" "$LOG_FILE" 2>/dev/null || echo 0)
DEBUG_COUNT=$(grep -ic "debug" "$LOG_FILE" 2>/dev/null || echo 0)

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}LOG LEVEL SUMMARY${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}Errors:      $ERROR_COUNT${NC}"
echo -e "${YELLOW}Warnings:    $WARNING_COUNT${NC}"
echo -e "${BLUE}Info:        $INFO_COUNT${NC}"
echo -e "Debug:       $DEBUG_COUNT"
echo ""

# Show filtered logs
case "$FILTER" in
    error)
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${RED}ERROR MESSAGES (Last 20)${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        grep -i "error" "$LOG_FILE" | tail -20
        ;;
    warning|warn)
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${YELLOW}WARNING MESSAGES (Last 20)${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        grep -i "warning\|warn" "$LOG_FILE" | tail -20
        ;;
    info)
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BLUE}INFO MESSAGES (Last 20)${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        grep -i "info" "$LOG_FILE" | tail -20
        ;;
    all)
        # Show most common errors
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}TOP 5 ERROR PATTERNS${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        
        if [ $ERROR_COUNT -gt 0 ]; then
            grep -i "error" "$LOG_FILE" | \
            awk '{
                # Extract meaningful part after ERROR
                match($0, /[Ee][Rr][Rr][Oo][Rr].*/)
                if (RSTART > 0) {
                    msg = substr($0, RSTART)
                    # Truncate to first 60 chars for grouping
                    msg = substr(msg, 1, 60)
                    count[msg]++
                }
            }
            END {
                for (msg in count) {
                    printf "%4d  %s\n", count[msg], msg
                }
            }' | sort -rn | head -5
        else
            echo "No errors found"
        fi
        echo ""
        
        # Show most common warnings
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}TOP 5 WARNING PATTERNS${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        
        if [ $WARNING_COUNT -gt 0 ]; then
            grep -i "warning\|warn" "$LOG_FILE" | \
            awk '{
                # Extract meaningful part after WARNING
                match($0, /[Ww][Aa][Rr][Nn]([Ii][Nn][Gg])?.*/)
                if (RSTART > 0) {
                    msg = substr($0, RSTART)
                    # Truncate to first 60 chars for grouping
                    msg = substr(msg, 1, 60)
                    count[msg]++
                }
            }
            END {
                for (msg in count) {
                    printf "%4d  %s\n", count[msg], msg
                }
            }' | sort -rn | head -5
        else
            echo "No warnings found"
        fi
        echo ""
        
        # Show last 10 errors
        if [ $ERROR_COUNT -gt 0 ]; then
            echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "${RED}RECENT ERRORS (Last 10)${NC}"
            echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            grep -i "error" "$LOG_FILE" | tail -10
            echo ""
        fi
        ;;
    *)
        echo -e "${RED}Unknown filter: $FILTER${NC}"
        echo "Valid filters: all, error, warning, info"
        exit 1
        ;;
esac

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Analysis complete!${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
