#!/bin/bash

# Test script for log analyzer

echo "=========================================="
echo "  LOG ANALYZER - TEST SCRIPT"
echo "=========================================="
echo ""

# Create sample log file
LOG_FILE="sample_app.log"

echo "1️⃣  Creating sample log file..."

cat > "$LOG_FILE" << 'EOF'
2025-11-25 10:00:01 INFO Application started successfully
2025-11-25 10:00:05 DEBUG Connecting to database
2025-11-25 10:00:06 INFO Database connection established
2025-11-25 10:00:10 DEBUG Processing request from 192.168.1.100
2025-11-25 10:00:15 WARNING Database connection slow (2.5s)
2025-11-25 10:00:20 INFO User login: john@example.com
2025-11-25 10:00:25 ERROR Failed to load configuration file: /etc/app/config.yml
2025-11-25 10:00:30 ERROR Failed to load configuration file: /etc/app/config.yml
2025-11-25 10:00:35 WARNING High memory usage: 85%
2025-11-25 10:00:40 INFO Processing 150 items
2025-11-25 10:00:45 DEBUG Cache hit for key: user_session_12345
2025-11-25 10:00:50 ERROR Database query timeout after 30s
2025-11-25 10:00:55 WARNING API rate limit approaching: 950/1000 requests
2025-11-25 10:01:00 INFO User logout: john@example.com
2025-11-25 10:01:05 ERROR Connection refused: Unable to reach external service at api.example.com
2025-11-25 10:01:10 ERROR Connection refused: Unable to reach external service at api.example.com
2025-11-25 10:01:15 WARNING Disk space low: 15% remaining on /var
2025-11-25 10:01:20 DEBUG Garbage collection completed in 120ms
2025-11-25 10:01:25 INFO Scheduled task executed successfully
2025-11-25 10:01:30 ERROR Authentication failed for user: admin@example.com
2025-11-25 10:01:35 ERROR Authentication failed for user: admin@example.com
2025-11-25 10:01:40 ERROR Authentication failed for user: admin@example.com
2025-11-25 10:01:45 WARNING SSL certificate expires in 7 days
2025-11-25 10:01:50 INFO Backup completed: 2.3GB in 45 seconds
2025-11-25 10:01:55 DEBUG Request completed in 245ms
2025-11-25 10:02:00 ERROR Out of memory: Java heap space
2025-11-25 10:02:05 ERROR Failed to load configuration file: /etc/app/config.yml
2025-11-25 10:02:10 WARNING Thread pool queue at 90% capacity
2025-11-25 10:02:15 INFO Application health check: OK
2025-11-25 10:02:20 DEBUG Session cleanup completed
2025-11-25 10:02:25 ERROR Database query timeout after 30s
2025-11-25 10:02:30 WARNING High CPU usage: 92%
2025-11-25 10:02:35 INFO User registration: alice@example.com
2025-11-25 10:02:40 DEBUG Sending notification email
2025-11-25 10:02:45 ERROR SMTP connection failed: Connection timed out
2025-11-25 10:02:50 INFO Cache cleared: 1500 entries removed
2025-11-25 10:02:55 WARNING Response time degraded: 3.2s average
2025-11-25 10:03:00 ERROR Connection refused: Unable to reach external service at api.example.com
2025-11-25 10:03:05 INFO Service restarted successfully
2025-11-25 10:03:10 DEBUG Loading configuration from environment
EOF

echo "✅ Created $LOG_FILE with 40 log entries"
echo ""

# Show file info
echo "2️⃣  File information:"
echo "   Size: $(du -h "$LOG_FILE" | awk '{print $1}')"
echo "   Lines: $(wc -l < "$LOG_FILE")"
echo ""

# Test 1: Analyze entire log
echo "3️⃣  Running full analysis..."
echo ""
./log-analyzer.sh "$LOG_FILE"
echo ""

# Test 2: Show only errors
echo ""
echo "=========================================="
echo "4️⃣  Testing error filter..."
echo "=========================================="
echo ""
./log-analyzer.sh "$LOG_FILE" error
echo ""

# Test 3: Show only warnings
echo ""
echo "=========================================="
echo "5️⃣  Testing warning filter..."
echo "=========================================="
echo ""
./log-analyzer.sh "$LOG_FILE" warning
echo ""

# Summary
echo "=========================================="
echo "  TEST SUMMARY"
echo "=========================================="
echo "Sample log: $LOG_FILE"
echo ""
echo "Expected counts:"
echo "  Errors:   12"
echo "  Warnings: 8"
echo "  Info:     11"
echo "  Debug:    9"
echo ""
echo "To clean up:"
echo "  rm $LOG_FILE"
echo ""
