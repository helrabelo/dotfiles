#!/bin/bash

# Node modules cleanup script
echo "Finding and removing node_modules directories..."

# Find all node_modules directories
find /Users/helrabelo/Code/current -name "node_modules" -type d -prune | while read dir; do
    project_dir=$(dirname "$dir")
    project_name=$(basename "$project_dir")

    # Check if package.json exists (indicates active project)
    if [ -f "$project_dir/package.json" ]; then
        echo "Found node_modules in active project: $project_name"
        read -p "Remove node_modules from $project_name? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$dir"
            echo "Removed node_modules from $project_name"
        fi
    else
        echo "Removing orphaned node_modules: $dir"
        rm -rf "$dir"
    fi
done

echo "Cleanup complete!"
echo "Run 'npm install' in active projects when needed."