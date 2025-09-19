#!/bin/bash

echo "=== Weekly Development Environment Cleanup ==="
echo "Starting at $(date)"
echo ""

# 1. Remove .DS_Store files
echo "Removing .DS_Store files..."
find /Users/helrabelo/Code -name '.DS_Store' -type f -delete
echo "✓ DS_Store files removed"

# 2. Clean npm/yarn cache
echo "Cleaning npm cache..."
npm cache clean --force 2>/dev/null
echo "✓ npm cache cleaned"

# 3. Remove orphaned node_modules (projects without package.json)
echo "Finding orphaned node_modules..."
orphaned_count=0
find /Users/helrabelo/Code -name "node_modules" -type d | while read dir; do
    project_dir=$(dirname "$dir")
    if [ ! -f "$project_dir/package.json" ]; then
        echo "  Removing orphaned: $dir"
        rm -rf "$dir"
        ((orphaned_count++))
    fi
done
echo "✓ Removed $orphaned_count orphaned node_modules"

# 4. Check for large log files
echo "Checking for large log files..."
find /Users/helrabelo/Code -name "*.log" -size +100M -exec ls -lh {} \; 2>/dev/null

# 5. Git maintenance on all repos
echo "Running git maintenance on all repositories..."
find /Users/helrabelo/Code -name ".git" -type d | while read git_dir; do
    repo_dir=$(dirname "$git_dir")
    repo_name=$(basename "$repo_dir")
    echo "  Maintaining: $repo_name"
    cd "$repo_dir"
    git gc --auto 2>/dev/null
    git prune 2>/dev/null
done
echo "✓ Git maintenance complete"

# 6. Report disk usage
echo ""
echo "=== Disk Usage Report ==="
echo "Total Code folder: $(du -sh /Users/helrabelo/Code 2>/dev/null | cut -f1)"
echo "Work projects: $(du -sh /Users/helrabelo/Code/work 2>/dev/null | cut -f1)"
echo "Personal projects: $(du -sh /Users/helrabelo/Code/personal 2>/dev/null | cut -f1)"
echo ""

# 7. Identify inactive projects (not modified in 90 days)
echo "=== Inactive Projects (90+ days) ==="
find /Users/helrabelo/Code/work /Users/helrabelo/Dev/personal -maxdepth 2 -type d -name ".git" | while read git_dir; do
    repo_dir=$(dirname "$git_dir")
    last_commit=$(cd "$repo_dir" && git log -1 --format="%cr" 2>/dev/null)
    if [ ! -z "$last_commit" ]; then
        days_ago=$(cd "$repo_dir" && git log -1 --format="%ct" 2>/dev/null)
        current_time=$(date +%s)
        days_diff=$(( ($current_time - $days_ago) / 86400 ))
        if [ $days_diff -gt 90 ]; then
            echo "  $(basename "$repo_dir"): $last_commit"
        fi
    fi
done

echo ""
echo "Cleanup completed at $(date)"