#!/usr/bin/env node

/**
 * Daily Log Automation System for Hel Rabelo's Workflow
 *
 * This script automates the collection and formatting of Claude activities
 * from various CLAUDE.md files across all projects into daily log entries.
 *
 * Usage:
 *   node daily-log-automation.js [--date YYYY-MM-DD] [--output-path PATH]
 *
 * Features:
 * - Scans all CLAUDE.md files in project directories
 * - Extracts activities for specified date (defaults to today)
 * - Formats according to established daily log format
 * - Creates/updates Obsidian daily log files
 * - Provides summary of activities logged
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

class DailyLogAutomation {
    constructor() {
        this.homeDir = '/Users/helrabelo';
        this.codeDir = path.join(this.homeDir, 'Code');
        this.claudeConfigDir = path.join(this.homeDir, '.claude');

        // Project directory mappings
        this.projectMappings = {
            'planetary': '/Users/helrabelo/Code/work/planetary',
            'plainsight': '/Users/helrabelo/Code/work/plainsight',
            'personal': '/Users/helrabelo/Code/personal'
        };

        this.today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD format
        this.activities = [];
    }

    /**
     * Find all CLAUDE.md files across the project structure
     */
    findClaudeFiles() {
        console.log('🔍 Scanning for CLAUDE.md files...');

        const claudeFiles = [];

        try {
            // Use find command to locate all CLAUDE.md files efficiently
            const findCommand = `find "${this.codeDir}" -name "CLAUDE.md" -type f 2>/dev/null`;
            const output = execSync(findCommand, { encoding: 'utf-8' });

            const files = output.trim().split('\n').filter(file => file.length > 0);
            claudeFiles.push(...files);

            // Also include the main global CLAUDE.md
            const globalClaudeFile = path.join(this.claudeConfigDir, 'CLAUDE.md');
            if (fs.existsSync(globalClaudeFile)) {
                claudeFiles.push(globalClaudeFile);
            }

            console.log(`✅ Found ${claudeFiles.length} CLAUDE.md files`);
            return claudeFiles;

        } catch (error) {
            console.error('❌ Error finding CLAUDE.md files:', error.message);
            return claudeFiles;
        }
    }

    /**
     * Extract activities for a specific date from CLAUDE.md content
     */
    extractActivitiesFromContent(content, filePath, targetDate) {
        const activities = [];
        const lines = content.split('\n');

        // Convert target date to format used in logs (both 2025-09-23 and ### 2025-09-23)
        const dateFormats = [
            `### ${targetDate}`,
            `## ${targetDate}`,
            targetDate,
            targetDate.replace(/-/g, '/') // Also check MM/DD/YYYY format
        ];

        let currentDateSection = false;
        let currentActivity = null;
        let activityBuffer = [];

        for (let i = 0; i < lines.length; i++) {
            const line = lines[i].trim();

            // Check if we're entering a date section
            const isDateLine = dateFormats.some(format => line.includes(format));

            if (isDateLine) {
                // If we were collecting an activity, save it
                if (currentActivity && activityBuffer.length > 0) {
                    activities.push({
                        ...currentActivity,
                        content: activityBuffer.join('\n').trim(),
                        sourceFile: filePath
                    });
                }

                currentDateSection = true;
                currentActivity = null;
                activityBuffer = [];
                continue;
            }

            // Check if we're leaving the date section (next date or major section)
            if (currentDateSection && (line.startsWith('### ') || line.startsWith('## ')) && !isDateLine) {
                // Save current activity if exists
                if (currentActivity && activityBuffer.length > 0) {
                    activities.push({
                        ...currentActivity,
                        content: activityBuffer.join('\n').trim(),
                        sourceFile: filePath
                    });
                }
                currentDateSection = false;
                break;
            }

            if (currentDateSection) {
                // Look for "For [Company] on [Project]:" pattern
                const activityMatch = line.match(/^\*\*For\s+(\w+)\s+on\s+([^:]+):\s*\*\*\s*(.+)$/);
                if (activityMatch) {
                    // Save previous activity if exists
                    if (currentActivity && activityBuffer.length > 0) {
                        activities.push({
                            ...currentActivity,
                            content: activityBuffer.join('\n').trim(),
                            sourceFile: filePath
                        });
                    }

                    // Start new activity
                    currentActivity = {
                        company: activityMatch[1],
                        project: activityMatch[2].trim(),
                        title: activityMatch[3],
                        date: targetDate
                    };
                    activityBuffer = [line];
                } else if (currentActivity) {
                    // Continue collecting activity content
                    activityBuffer.push(line);
                }
            }
        }

        // Don't forget the last activity
        if (currentActivity && activityBuffer.length > 0) {
            activities.push({
                ...currentActivity,
                content: activityBuffer.join('\n').trim(),
                sourceFile: filePath
            });
        }

        return activities;
    }

    /**
     * Process all CLAUDE.md files and extract activities for target date
     */
    processClaudeFiles(targetDate) {
        console.log(`📅 Extracting activities for ${targetDate}...`);

        const claudeFiles = this.findClaudeFiles();
        let totalActivities = 0;

        for (const filePath of claudeFiles) {
            try {
                if (!fs.existsSync(filePath)) {
                    console.log(`⚠️  File not found: ${filePath}`);
                    continue;
                }

                const content = fs.readFileSync(filePath, 'utf-8');
                const activities = this.extractActivitiesFromContent(content, filePath, targetDate);

                if (activities.length > 0) {
                    console.log(`📄 ${path.relative(this.homeDir, filePath)}: ${activities.length} activities`);
                    this.activities.push(...activities);
                    totalActivities += activities.length;
                }

            } catch (error) {
                console.error(`❌ Error processing ${filePath}:`, error.message);
            }
        }

        console.log(`✅ Total activities found: ${totalActivities}`);
        return this.activities;
    }

    /**
     * Format activities according to the established daily log format
     */
    formatDailyLog(activities, targetDate) {
        if (activities.length === 0) {
            return `# Daily Log - ${this.formatDateForDisplay(targetDate)}\n\nNo Claude activities recorded for this date.\n`;
        }

        // Group activities by company
        const grouped = {};
        activities.forEach(activity => {
            if (!grouped[activity.company]) {
                grouped[activity.company] = [];
            }
            grouped[activity.company].push(activity);
        });

        let output = `# Daily Log - ${this.formatDateForDisplay(targetDate)}\n\n`;

        // Process each company section
        for (const [company, companyActivities] of Object.entries(grouped)) {
            output += `## For ${company}\n\n`;

            companyActivities.forEach((activity, index) => {
                // Extract the activity content without the header line
                const lines = activity.content.split('\n');
                const contentLines = lines.slice(1); // Skip the "**For Company on Project:**" line
                const content = contentLines.join('\n').trim();

                output += `### ${activity.title}\n`;
                output += `**Project**: ${activity.project}\n\n`;

                if (content) {
                    output += content + '\n\n';
                }

                // Add source file reference (helpful for debugging)
                const relativeSource = path.relative(this.homeDir, activity.sourceFile);
                output += `*Source: ${relativeSource}*\n\n`;
            });
        }

        // Add generation timestamp
        output += `---\n*Generated on ${new Date().toISOString()} by Daily Log Automation*\n`;

        return output;
    }

    /**
     * Format date for display (e.g., "September 23, 2025")
     */
    formatDateForDisplay(dateStr) {
        const date = new Date(dateStr + 'T00:00:00');
        return date.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    }

    /**
     * Create or update the daily log file
     */
    createDailyLogFile(content, targetDate, outputPath = null) {
        const fileName = outputPath || path.join(this.homeDir, `obsidian-daily-entry-${targetDate}.md`);

        try {
            // Check if file already exists
            const fileExists = fs.existsSync(fileName);

            if (fileExists) {
                console.log(`📝 Updating existing daily log: ${fileName}`);
            } else {
                console.log(`📝 Creating new daily log: ${fileName}`);
            }

            fs.writeFileSync(fileName, content, 'utf-8');
            console.log(`✅ Daily log saved successfully`);

            return fileName;

        } catch (error) {
            console.error(`❌ Error saving daily log:`, error.message);
            throw error;
        }
    }

    /**
     * Generate summary of what was logged
     */
    generateSummary(activities, targetDate, outputFile) {
        console.log('\n' + '='.repeat(60));
        console.log('📊 DAILY LOG AUTOMATION SUMMARY');
        console.log('='.repeat(60));
        console.log(`📅 Date: ${this.formatDateForDisplay(targetDate)}`);
        console.log(`📄 Output: ${path.relative(this.homeDir, outputFile)}`);
        console.log(`🎯 Activities: ${activities.length}`);

        if (activities.length > 0) {
            // Group by company for summary
            const companySummary = {};
            activities.forEach(activity => {
                if (!companySummary[activity.company]) {
                    companySummary[activity.company] = 0;
                }
                companySummary[activity.company]++;
            });

            console.log('\n📈 Breakdown by Company:');
            Object.entries(companySummary).forEach(([company, count]) => {
                console.log(`   • ${company}: ${count} activities`);
            });

            console.log('\n📋 Activities:');
            activities.forEach((activity, index) => {
                console.log(`   ${index + 1}. ${activity.company} - ${activity.project}: ${activity.title.substring(0, 50)}${activity.title.length > 50 ? '...' : ''}`);
            });
        }

        console.log('\n✨ Daily log automation completed successfully!');
        console.log('='.repeat(60));
    }

    /**
     * Main execution method
     */
    async run(targetDate = null, outputPath = null) {
        try {
            const date = targetDate || this.today;

            console.log('🚀 Starting Daily Log Automation...');
            console.log(`📅 Target Date: ${date}`);

            // Extract activities from all CLAUDE.md files
            const activities = this.processClaudeFiles(date);

            // Format the daily log
            const formattedLog = this.formatDailyLog(activities, date);

            // Create/update the daily log file
            const outputFile = this.createDailyLogFile(formattedLog, date, outputPath);

            // Generate summary
            this.generateSummary(activities, date, outputFile);

            return {
                success: true,
                activitiesCount: activities.length,
                outputFile: outputFile,
                activities: activities
            };

        } catch (error) {
            console.error('❌ Daily log automation failed:', error.message);
            return {
                success: false,
                error: error.message
            };
        }
    }
}

// CLI interface
if (require.main === module) {
    const args = process.argv.slice(2);
    let targetDate = null;
    let outputPath = null;

    // Parse command line arguments
    for (let i = 0; i < args.length; i++) {
        if (args[i] === '--date' && i + 1 < args.length) {
            targetDate = args[i + 1];
            i++; // Skip next argument
        } else if (args[i] === '--output-path' && i + 1 < args.length) {
            outputPath = args[i + 1];
            i++; // Skip next argument
        } else if (args[i] === '--help' || args[i] === '-h') {
            console.log(`
Daily Log Automation for Hel Rabelo's Workflow

Usage:
  node daily-log-automation.js [options]

Options:
  --date YYYY-MM-DD      Target date for log extraction (default: today)
  --output-path PATH     Custom output file path (default: ~/obsidian-daily-entry-YYYY-MM-DD.md)
  --help, -h             Show this help message

Examples:
  node daily-log-automation.js
  node daily-log-automation.js --date 2025-09-22
  node daily-log-automation.js --date 2025-09-22 --output-path /path/to/custom-log.md
            `);
            process.exit(0);
        }
    }

    // Run the automation
    const automation = new DailyLogAutomation();
    automation.run(targetDate, outputPath).then(result => {
        process.exit(result.success ? 0 : 1);
    });
}

module.exports = DailyLogAutomation;