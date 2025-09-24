#!/usr/bin/env node

/**
 * Activity Logger - Utility for adding new Claude activities to CLAUDE.md files
 *
 * This script helps maintain consistent activity logging across all projects
 * by providing a standardized interface for adding new entries to CLAUDE.md files.
 *
 * Usage:
 *   node activity-logger.js [options]
 *
 * Features:
 * - Interactive prompts for activity details
 * - Automatic project detection based on current directory
 * - Consistent formatting according to established standards
 * - Validation of required fields
 * - Integration with existing CLAUDE.md structure
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');

class ActivityLogger {
    constructor() {
        this.homeDir = '/Users/helrabelo';
        this.codeDir = path.join(this.homeDir, 'Code');

        // Company/project mappings
        this.companyMappings = {
            'planetary': 'Planetary',
            'plainsight': 'Plainsight',
            'personal': 'Personal'
        };

        // Common project abbreviations
        this.projectMappings = {
            'din-tai-fung': 'DTF',
            'din-tai-fung-website': 'DTF',
            'the-well': 'The Well',
            'client-portal': 'Client Portal',
            'plainsight-api': 'Plainsight API',
            'wishare': 'Wishare'
        };

        this.rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });
    }

    /**
     * Detect project context from current working directory
     */
    detectProjectContext() {
        const cwd = process.cwd();
        const relativePath = path.relative(this.codeDir, cwd);

        console.log(`🔍 Current directory: ${cwd}`);
        console.log(`📁 Relative path: ${relativePath}`);

        // Parse the path to determine company and project
        const pathParts = relativePath.split(path.sep);

        let company = 'Unknown';
        let project = 'Unknown';
        let claudeFilePath = null;

        if (pathParts.length >= 2) {
            const workType = pathParts[0]; // 'work' or 'personal'
            const companyDir = pathParts[1]; // 'planetary', 'plainsight', etc.

            if (workType === 'work' && this.companyMappings[companyDir]) {
                company = this.companyMappings[companyDir];
            } else if (workType === 'personal') {
                company = 'Personal';
            }

            // Try to detect project name
            if (pathParts.length >= 3) {
                const projectDir = pathParts[pathParts.length - 1];
                project = this.projectMappings[projectDir] || projectDir;
            }

            // Find the closest CLAUDE.md file
            let searchDir = cwd;
            while (searchDir !== this.codeDir && searchDir !== '/') {
                const claudeFile = path.join(searchDir, 'CLAUDE.md');
                if (fs.existsSync(claudeFile)) {
                    claudeFilePath = claudeFile;
                    break;
                }
                searchDir = path.dirname(searchDir);
            }
        }

        return {
            company,
            project,
            claudeFilePath,
            detectedFromPath: relativePath
        };
    }

    /**
     * Prompt user for input with validation
     */
    async prompt(question, defaultValue = '', validator = null) {
        return new Promise((resolve) => {
            const promptText = defaultValue
                ? `${question} (${defaultValue}): `
                : `${question}: `;

            this.rl.question(promptText, (answer) => {
                const value = answer.trim() || defaultValue;

                if (validator && !validator(value)) {
                    console.log('❌ Invalid input. Please try again.');
                    resolve(this.prompt(question, defaultValue, validator));
                } else {
                    resolve(value);
                }
            });
        });
    }

    /**
     * Get current date in YYYY-MM-DD format
     */
    getCurrentDate() {
        return new Date().toISOString().split('T')[0];
    }

    /**
     * Format the activity entry according to established standards
     */
    formatActivity(activityData) {
        const { company, project, title, problem, process, result, impact } = activityData;
        const currentDate = this.getCurrentDate();

        let entry = `### ${currentDate}\n`;
        entry += `**For ${company} on ${project}**: ${title}\n`;

        if (problem) {
            entry += `- **Problem**: ${problem}\n`;
        }

        if (process) {
            entry += `- **Process**: ${process}\n`;
        }

        if (result) {
            entry += `- **Result**: ${result}\n`;
        }

        if (impact) {
            entry += `- **Impact**: ${impact}\n`;
        }

        entry += '\n';

        return entry;
    }

    /**
     * Add activity to CLAUDE.md file
     */
    addActivityToFile(claudeFilePath, activityEntry) {
        try {
            let content = '';

            if (fs.existsSync(claudeFilePath)) {
                content = fs.readFileSync(claudeFilePath, 'utf-8');
            } else {
                // Create new CLAUDE.md file with basic structure
                content = `# Claude Activities\n\n## Recent Activities\n\n`;
            }

            // Find the right place to insert the new activity
            // Look for existing date sections or add at the top of Recent Activities
            const lines = content.split('\n');
            const currentDate = this.getCurrentDate();
            let insertIndex = -1;

            // Find Recent Activities section or similar
            for (let i = 0; i < lines.length; i++) {
                if (lines[i].includes('Recent Activities') || lines[i].includes('Daily Activities')) {
                    insertIndex = i + 2; // After the header and empty line
                    break;
                }
            }

            if (insertIndex === -1) {
                // If no Recent Activities section found, add at the end
                content += '\n## Recent Activities\n\n';
                content += activityEntry;
            } else {
                // Insert the new activity at the appropriate position
                lines.splice(insertIndex, 0, ...activityEntry.split('\n'));
                content = lines.join('\n');
            }

            // Write back to file
            fs.writeFileSync(claudeFilePath, content, 'utf-8');
            console.log(`✅ Activity added to ${claudeFilePath}`);

            return true;

        } catch (error) {
            console.error(`❌ Error updating CLAUDE.md file:`, error.message);
            return false;
        }
    }

    /**
     * Interactive activity logging session
     */
    async runInteractiveSession() {
        console.log('🚀 Claude Activity Logger');
        console.log('='.repeat(50));

        try {
            // Detect project context
            const context = this.detectProjectContext();
            console.log(`\n📍 Detected Context:`);
            console.log(`   Company: ${context.company}`);
            console.log(`   Project: ${context.project}`);
            console.log(`   CLAUDE.md: ${context.claudeFilePath || 'Not found'}`);

            // Prompt for activity details
            console.log('\n📝 Activity Details:');

            const company = await this.prompt('Company', context.company);
            const project = await this.prompt('Project', context.project);
            const title = await this.prompt('Activity Title', '', (value) => value.length > 0);

            console.log('\n📋 Optional Details (press Enter to skip):');
            const problem = await this.prompt('Problem');
            const process = await this.prompt('Process');
            const result = await this.prompt('Result');
            const impact = await this.prompt('Impact');

            // Confirm CLAUDE.md file path
            let claudeFilePath = context.claudeFilePath;
            if (!claudeFilePath) {
                claudeFilePath = await this.prompt(
                    'CLAUDE.md file path',
                    path.join(process.cwd(), 'CLAUDE.md')
                );
            } else {
                const useDetected = await this.prompt(
                    `Use detected file (${claudeFilePath})? [y/n]`,
                    'y'
                );
                if (useDetected.toLowerCase() !== 'y') {
                    claudeFilePath = await this.prompt('CLAUDE.md file path');
                }
            }

            // Format the activity
            const activityData = { company, project, title, problem, process, result, impact };
            const activityEntry = this.formatActivity(activityData);

            // Preview the entry
            console.log('\n📄 Preview:');
            console.log('-'.repeat(50));
            console.log(activityEntry);
            console.log('-'.repeat(50));

            // Confirm before adding
            const confirm = await this.prompt('Add this activity? [y/n]', 'y');

            if (confirm.toLowerCase() === 'y') {
                const success = this.addActivityToFile(claudeFilePath, activityEntry);

                if (success) {
                    console.log('\n✨ Activity logged successfully!');

                    // Offer to run daily log generation
                    const runDailyLog = await this.prompt(
                        'Generate daily log now? [y/n]',
                        'n'
                    );

                    if (runDailyLog.toLowerCase() === 'y') {
                        const { execSync } = require('child_process');
                        const dailyLogScript = path.join(__dirname, 'claude-daily-log.sh');

                        try {
                            console.log('\n🔄 Generating daily log...');
                            execSync(`bash "${dailyLogScript}"`, { stdio: 'inherit' });
                        } catch (error) {
                            console.error('❌ Failed to generate daily log:', error.message);
                        }
                    }
                } else {
                    console.log('\n❌ Failed to log activity');
                }
            } else {
                console.log('\n❌ Activity logging cancelled');
            }

        } catch (error) {
            console.error('❌ Error during interactive session:', error.message);
        } finally {
            this.rl.close();
        }
    }

    /**
     * Command-line interface for non-interactive usage
     */
    async runCLI(args) {
        // Parse command-line arguments for non-interactive mode
        // This could be extended to support CLI arguments if needed
        console.log('🔧 CLI mode not yet implemented');
        console.log('💡 Run without arguments for interactive mode');
        this.rl.close();
    }

    /**
     * Main execution method
     */
    async run() {
        const args = process.argv.slice(2);

        if (args.length > 0 && (args[0] === '--help' || args[0] === '-h')) {
            this.showHelp();
            this.rl.close();
            return;
        }

        if (args.length > 0) {
            await this.runCLI(args);
        } else {
            await this.runInteractiveSession();
        }
    }

    /**
     * Show help information
     */
    showHelp() {
        console.log(`
Claude Activity Logger

DESCRIPTION:
    Interactive tool for logging Claude activities to CLAUDE.md files
    with consistent formatting and automatic project detection.

USAGE:
    node activity-logger.js [options]

OPTIONS:
    --help, -h          Show this help message

INTERACTIVE MODE:
    When run without arguments, the tool will prompt for:
    - Company name (auto-detected from directory)
    - Project name (auto-detected from directory)
    - Activity title (required)
    - Problem description (optional)
    - Process description (optional)
    - Result description (optional)
    - Impact description (optional)
    - CLAUDE.md file path (auto-detected)

EXAMPLES:
    node activity-logger.js               # Interactive mode
    node activity-logger.js --help        # Show help

The tool automatically detects your project context based on the current
directory and will find the appropriate CLAUDE.md file to update.
        `);
    }
}

// CLI interface
if (require.main === module) {
    const logger = new ActivityLogger();
    logger.run().catch(error => {
        console.error('💥 Fatal error:', error.message);
        process.exit(1);
    });
}

module.exports = ActivityLogger;