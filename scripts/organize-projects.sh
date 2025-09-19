#!/bin/bash

# Project organization script
echo "Organizing development projects..."

# Create new structure
mkdir -p /Users/helrabelo/Code/work/planetary
mkdir -p /Users/helrabelo/Code/work/plainsight
mkdir -p /Users/helrabelo/Code/personal
mkdir -p /Users/helrabelo/Code/archive
mkdir -p /Users/helrabelo/Code/_shared

# Move projects (with confirmation)
echo "Ready to organize projects. This will:"
echo "1. Move Planetary projects to Code/work/planetary/"
echo "2. Move Plainsight projects to Code/work/plainsight/"
echo "3. Move personal projects to Code/personal/"
echo ""
echo "Current projects will be MOVED (not copied)."
read -p "Continue? (y/n): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Move work projects
    mv /Users/helrabelo/Code/current/planetary/* /Users/helrabelo/Code/work/planetary/ 2>/dev/null
    mv /Users/helrabelo/Code/current/plainsight /Users/helrabelo/Code/work/plainsight/ 2>/dev/null

    # Move personal projects
    for project in wishare helrabelo.dev daysasnumbers faturas-reader loterias-boa-sorte ubsubscriber video-frame-exporter zen-inbox analy daissen pdf-parser; do
        if [ -d "/Users/helrabelo/Code/current/$project" ]; then
            mv "/Users/helrabelo/Code/current/$project" /Users/helrabelo/Code/personal/
        fi
    done

    # Move tooling to shared
    if [ -d "/Users/helrabelo/Code/current/tooling" ]; then
        mv /Users/helrabelo/Code/current/tooling /Users/helrabelo/Code/_shared/
    fi

    echo "Projects organized successfully!"
else
    echo "Organization cancelled."
fi