#!/usr/bin/env node

const fs = require('fs');

const targetDate = '2025-09-23';
const claudeFile = '/Users/helrabelo/.claude/CLAUDE.md';
const content = fs.readFileSync(claudeFile, 'utf8');
const lines = content.split('\n');

let inTodaySection = false;
let activities = [];
let currentActivity = [];

console.log('Looking for:', `### ${targetDate}`);

for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    if (line.trim() === `### ${targetDate}`) {
        console.log(`Found target date at line ${i + 1}`);
        inTodaySection = true;
        continue;
    }

    if (inTodaySection && line.match(/^###\s+\d{4}-\d{2}-\d{2}/) && !line.includes(targetDate)) {
        console.log(`End of section at line ${i + 1}: ${line}`);
        break;
    }

    if (inTodaySection) {
        console.log(`Processing line ${i + 1}: "${line}"`);

        if (line.match(/^\*\*For .+ on .+:\*\*/)) {
            console.log(`Found activity start: ${line}`);
            if (currentActivity.length > 0) {
                activities.push(currentActivity);
                console.log(`Saved previous activity with ${currentActivity.length} lines`);
                currentActivity = [];
            }
            currentActivity.push(line);
        } else if (currentActivity.length > 0 && line.trim()) {
            console.log(`Adding to current activity: ${line}`);
            currentActivity.push(line);
        }
    }
}

if (currentActivity.length > 0) {
    activities.push(currentActivity);
    console.log(`Saved final activity with ${currentActivity.length} lines`);
}

console.log(`\nTotal activities found: ${activities.length}`);
activities.forEach((activity, i) => {
    console.log(`\nActivity ${i + 1}:`);
    console.log(activity.join('\n'));
});