#!/bin/bash

# Test script for automated backup project

echo "=========================================="
echo "  AUTOMATED BACKUP - TEST SCRIPT"
echo "=========================================="
echo ""

# Step 1: Create test source directory with files
echo "1️⃣  Creating test files..."
mkdir -p ~/test_source
echo "This is test file 1" > ~/test_source/file1.txt
echo "This is test file 2" > ~/test_source/file2.txt
echo "This is test file 3" > ~/test_source/file3.txt
echo "✅ Created 3 test files in ~/test_source"
echo ""

# Step 2: Create backup destination
echo "2️⃣  Creating backup destination..."
mkdir -p ~/test_backups
echo "✅ Created ~/test_backups directory"
echo ""

# Step 3: Run first backup
echo "3️⃣  Running first backup..."
./backup.sh ~/test_source ~/test_backups
echo ""

# Step 4: Run multiple backups to test rotation (should keep only 7)
echo "4️⃣  Running 9 more backups to test rotation..."
for i in {1..9}; do
    echo "   Backup $((i+1))/10..."
    ./backup.sh ~/test_source ~/test_backups
    sleep 1
done
echo ""

# Step 5: Check how many backups exist
echo "5️⃣  Checking backup count (should be 7)..."
backup_count=$(ls ~/test_backups/*.tar.gz 2>/dev/null | wc -l)
echo "   Found $backup_count backups"
if [ "$backup_count" -eq 7 ]; then
    echo "✅ Rotation working correctly!"
else
    echo "⚠️  Expected 7 backups, found $backup_count"
fi
echo ""

# Step 6: List all backups
echo "6️⃣  Listing all backups:"
ls -lh ~/test_backups/*.tar.gz
echo ""

# Step 7: Test restore
echo "7️⃣  Testing restore functionality..."
mkdir -p ~/test_restore
latest_backup=$(ls -t ~/test_backups/*.tar.gz | head -1)
echo "   Restoring from: $(basename $latest_backup)"
./restore.sh "$latest_backup" ~/test_restore
echo ""

# Step 8: Verify restored files
echo "8️⃣  Verifying restored files..."
if [ -f ~/test_restore/test_source/file1.txt ]; then
    echo "✅ file1.txt restored successfully"
    cat ~/test_restore/test_source/file1.txt
else
    echo "❌ file1.txt not found"
fi
echo ""

# Summary
echo "=========================================="
echo "  TEST SUMMARY"
echo "=========================================="
echo "Backups created: $backup_count"
echo "Backup location: ~/test_backups"
echo "Restored to: ~/test_restore"
echo ""
echo "To clean up test files, run:"
echo "  rm -rf ~/test_source ~/test_backups ~/test_restore"
echo ""
