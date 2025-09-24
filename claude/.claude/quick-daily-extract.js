#!/usr/bin/env node

const fs = require('fs');

function extractTodaysActivities() {
    const today = '2025-09-23';
    const claudeFile = '/Users/helrabelo/.claude/CLAUDE.md';

    if (!fs.existsSync(claudeFile)) {
        console.log('CLAUDE.md not found');
        return;
    }

    const content = fs.readFileSync(claudeFile, 'utf8');
    const lines = content.split('\n');

    let inTodaySection = false;
    let activities = [];
    let currentActivity = [];

    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];

        // Check for date header
        if (line.includes(`### ${today}`)) {
            inTodaySection = true;
            continue;
        }

        // Check if we've moved to next section
        if (inTodaySection && line.match(/^###\s+\d{4}-\d{2}-\d{2}/)) {
            break;
        }

        if (inTodaySection) {
            // Look for activity start
            if (line.match(/^\*\*For .+ on .+:\*\*/)) {
                // Save previous activity
                if (currentActivity.length > 0) {
                    activities.push(currentActivity.join('\n'));
                    currentActivity = [];
                }
                currentActivity.push(line);
            } else if (currentActivity.length > 0) {
                currentActivity.push(line);
            }
        }
    }

    // Don't forget last activity
    if (currentActivity.length > 0) {
        activities.push(currentActivity.join('\n'));
    }

    console.log(`Found ${activities.length} activities:`);
    activities.forEach((activity, i) => {
        console.log(`\n--- Activity ${i + 1} ---`);
        console.log(activity);
    });

    return activities;
}

extractTodaysActivities();