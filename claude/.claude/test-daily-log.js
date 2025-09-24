#!/usr/bin/env node

/**
 * Test Suite for Daily Log Automation System
 *
 * This script tests the core functionality of the daily log automation system
 * to ensure it properly extracts activities and generates formatted logs.
 */

const fs = require('fs');
const path = require('path');
const DailyLogAutomation = require('./daily-log-automation.js');

class DailyLogTester {
    constructor() {
        this.testDir = '/tmp/claude-daily-log-test';
        this.testResults = [];
    }

    /**
     * Setup test environment
     */
    setupTestEnvironment() {
        console.log('🧪 Setting up test environment...');

        // Create test directory structure
        if (!fs.existsSync(this.testDir)) {
            fs.mkdirSync(this.testDir, { recursive: true });
        }

        // Create test CLAUDE.md files with sample data
        this.createTestClaudeFiles();

        console.log('✅ Test environment ready');
    }

    /**
     * Create test CLAUDE.md files with sample activities
     */
    createTestClaudeFiles() {
        const testData = {
            'test-planetary.md': `# Planetary Project Activities

## Recent Activities

### 2025-09-23
**For Planetary on DTF**: Fixed navigation menu responsive design
- **Problem**: Navigation menu was not responsive on mobile devices, breaking user experience on phones and tablets
- **Process**: Analyzed CSS media queries, implemented flexbox layout, tested across multiple devices and screen sizes
- **Result**: Navigation now works seamlessly across all device sizes, improved mobile user experience significantly

**For Planetary on The Well**: Implemented mega menu system
- **Problem**: Site needed comprehensive navigation system with CMS integration
- **Process**: Created Sanity schemas, built Vue components, integrated with CMS data flow
- **Result**: Production-ready mega menu with hover interactions and CMS content management

### 2025-09-22
**For Planetary on Burlington**: Optimized page load performance
- **Problem**: Site was loading slowly affecting user engagement and SEO rankings
- **Process**: Analyzed bundle sizes, implemented code splitting, optimized images and assets
- **Result**: Reduced page load time by 60%, improved Google PageSpeed score from 45 to 92
`,

            'test-plainsight.md': `# Plainsight Activities

## Recent Daily Activities

### 2025-09-23
**For Plainsight on Client Portal**: Completed semantic token migration
- **Problem**: 797 useColorModeValue calls creating performance bottlenecks across application
- **Process**: Systematically migrated high-impact components, created semantic token infrastructure, validated with TypeScript
- **Result**: Achieved 95% migration completion, eliminated 757 conditional hooks, major performance improvement

### 2025-09-22
**For Plainsight on Client Portal**: Resolved E2E testing infrastructure crisis
- **Problem**: E2E test suite taking 2+ hours with infinite loops blocking development workflow
- **Process**: Deployed specialized agents, fixed selector mismatches, optimized test scope and timeouts
- **Result**: Fixed infinite loops, created 90% scope reduction strategy, established reliable testing foundation
`,

            'test-personal.md': `# Personal Projects

## Activities Log

### 2025-09-23
**For Personal on Wishare**: Enhanced user onboarding flow
- **Problem**: User drop-off rate was high during initial registration and setup process
- **Process**: Redesigned onboarding screens, added progress indicators, simplified form fields
- **Result**: Increased completion rate by 40%, improved user retention in first week

### 2025-09-22
**For Personal on System**: Automated development workflow setup
- **Problem**: Manual setup of development environments was time-consuming and error-prone
- **Process**: Created shell scripts, Docker configurations, and documentation for one-command setup
- **Result**: Reduced setup time from 2 hours to 15 minutes, eliminated configuration errors
`
        };

        // Write test files
        Object.entries(testData).forEach(([filename, content]) => {
            const filePath = path.join(this.testDir, filename);
            fs.writeFileSync(filePath, content, 'utf-8');
            console.log(`📄 Created test file: ${filename}`);
        });
    }

    /**
     * Test activity extraction from content
     */
    testActivityExtraction() {
        console.log('\n🔍 Testing activity extraction...');

        const automation = new DailyLogAutomation();
        const testFile = path.join(this.testDir, 'test-planetary.md');
        const content = fs.readFileSync(testFile, 'utf-8');

        // Test extracting activities for 2025-09-23
        const activities = automation.extractActivitiesFromContent(content, testFile, '2025-09-23');

        console.log(`📊 Found ${activities.length} activities for 2025-09-23`);

        if (activities.length === 2) {
            console.log('✅ Correct number of activities extracted');
            this.testResults.push({ test: 'Activity Extraction Count', status: 'PASS' });

            // Verify first activity
            const firstActivity = activities[0];
            if (firstActivity.company === 'Planetary' &&
                firstActivity.project === 'DTF' &&
                firstActivity.title === 'Fixed navigation menu responsive design') {
                console.log('✅ First activity correctly parsed');
                this.testResults.push({ test: 'First Activity Parsing', status: 'PASS' });
            } else {
                console.log('❌ First activity parsing failed');
                console.log('Expected: Planetary, DTF, Fixed navigation menu responsive design');
                console.log('Got:', firstActivity.company, firstActivity.project, firstActivity.title);
                this.testResults.push({ test: 'First Activity Parsing', status: 'FAIL' });
            }

            // Verify activity content includes Problem/Process/Result
            if (firstActivity.content.includes('Problem') &&
                firstActivity.content.includes('Process') &&
                firstActivity.content.includes('Result')) {
                console.log('✅ Activity content structure correct');
                this.testResults.push({ test: 'Activity Content Structure', status: 'PASS' });
            } else {
                console.log('❌ Activity content structure incorrect');
                this.testResults.push({ test: 'Activity Content Structure', status: 'FAIL' });
            }

        } else {
            console.log('❌ Incorrect number of activities extracted');
            console.log('Expected: 2, Got:', activities.length);
            this.testResults.push({ test: 'Activity Extraction Count', status: 'FAIL' });
        }
    }

    /**
     * Test daily log formatting
     */
    testDailyLogFormatting() {
        console.log('\n📝 Testing daily log formatting...');

        const automation = new DailyLogAutomation();

        // Create test activities
        const testActivities = [
            {
                company: 'Planetary',
                project: 'DTF',
                title: 'Fixed navigation responsive design',
                date: '2025-09-23',
                content: '**For Planetary on DTF**: Fixed navigation responsive design\n- **Problem**: Menu not responsive\n- **Result**: Works on all devices',
                sourceFile: '/test/planetary.md'
            },
            {
                company: 'Plainsight',
                project: 'Client Portal',
                title: 'Semantic token migration',
                date: '2025-09-23',
                content: '**For Plainsight on Client Portal**: Semantic token migration\n- **Problem**: Performance issues\n- **Result**: 95% migration complete',
                sourceFile: '/test/plainsight.md'
            }
        ];

        const formattedLog = automation.formatDailyLog(testActivities, '2025-09-23');

        // Check if formatted log contains expected sections
        if (formattedLog.includes('# Daily Log - September 23, 2025')) {
            console.log('✅ Correct date formatting in header');
            this.testResults.push({ test: 'Date Header Formatting', status: 'PASS' });
        } else {
            console.log('❌ Incorrect date formatting in header');
            this.testResults.push({ test: 'Date Header Formatting', status: 'FAIL' });
        }

        if (formattedLog.includes('## For Planetary') && formattedLog.includes('## For Plainsight')) {
            console.log('✅ Company sections properly created');
            this.testResults.push({ test: 'Company Section Creation', status: 'PASS' });
        } else {
            console.log('❌ Company sections not properly created');
            this.testResults.push({ test: 'Company Section Creation', status: 'FAIL' });
        }

        if (formattedLog.includes('**Project**: DTF') && formattedLog.includes('**Project**: Client Portal')) {
            console.log('✅ Project information included');
            this.testResults.push({ test: 'Project Information', status: 'PASS' });
        } else {
            console.log('❌ Project information missing');
            this.testResults.push({ test: 'Project Information', status: 'FAIL' });
        }

        console.log('\n📄 Generated log preview:');
        console.log('─'.repeat(60));
        console.log(formattedLog.substring(0, 500) + '...');
        console.log('─'.repeat(60));
    }

    /**
     * Test file operations
     */
    testFileOperations() {
        console.log('\n💾 Testing file operations...');

        const automation = new DailyLogAutomation();
        const testContent = '# Test Daily Log\n\nThis is a test log entry.';
        const outputPath = path.join(this.testDir, 'test-output.md');

        try {
            const resultPath = automation.createDailyLogFile(testContent, '2025-09-23', outputPath);

            if (fs.existsSync(resultPath)) {
                const writtenContent = fs.readFileSync(resultPath, 'utf-8');
                if (writtenContent === testContent) {
                    console.log('✅ File operations working correctly');
                    this.testResults.push({ test: 'File Operations', status: 'PASS' });
                } else {
                    console.log('❌ File content mismatch');
                    this.testResults.push({ test: 'File Operations', status: 'FAIL' });
                }
            } else {
                console.log('❌ File was not created');
                this.testResults.push({ test: 'File Operations', status: 'FAIL' });
            }

        } catch (error) {
            console.log('❌ File operations failed:', error.message);
            this.testResults.push({ test: 'File Operations', status: 'FAIL' });
        }
    }

    /**
     * Test integration with actual system
     */
    testSystemIntegration() {
        console.log('\n🔗 Testing system integration...');

        // Create a temporary automation instance that points to our test directory
        const automation = new DailyLogAutomation();

        // Override the code directory for testing
        automation.codeDir = this.testDir;

        try {
            // Test the full workflow
            const activities = automation.processClaudeFiles('2025-09-23');

            if (activities && activities.length > 0) {
                console.log('✅ System integration working');
                console.log(`📊 Found ${activities.length} activities across test files`);
                this.testResults.push({ test: 'System Integration', status: 'PASS' });

                // Test formatting with real data
                const formattedLog = automation.formatDailyLog(activities, '2025-09-23');
                const outputPath = path.join(this.testDir, 'integration-test-output.md');
                automation.createDailyLogFile(formattedLog, '2025-09-23', outputPath);

                console.log(`📄 Integration test output saved to: ${outputPath}`);

            } else {
                console.log('❌ No activities found in system integration test');
                this.testResults.push({ test: 'System Integration', status: 'FAIL' });
            }

        } catch (error) {
            console.log('❌ System integration failed:', error.message);
            this.testResults.push({ test: 'System Integration', status: 'FAIL' });
        }
    }

    /**
     * Clean up test environment
     */
    cleanup() {
        console.log('\n🧹 Cleaning up test environment...');

        try {
            // Remove test directory and all contents
            if (fs.existsSync(this.testDir)) {
                fs.rmSync(this.testDir, { recursive: true, force: true });
                console.log('✅ Test environment cleaned up');
            }
        } catch (error) {
            console.log('⚠️  Cleanup warning:', error.message);
        }
    }

    /**
     * Generate test report
     */
    generateReport() {
        console.log('\n' + '='.repeat(60));
        console.log('📊 DAILY LOG AUTOMATION TEST REPORT');
        console.log('='.repeat(60));

        const passCount = this.testResults.filter(r => r.status === 'PASS').length;
        const failCount = this.testResults.filter(r => r.status === 'FAIL').length;
        const total = this.testResults.length;

        console.log(`📈 Overall Results: ${passCount}/${total} tests passed (${Math.round(passCount/total*100)}%)`);
        console.log('');

        this.testResults.forEach((result, index) => {
            const icon = result.status === 'PASS' ? '✅' : '❌';
            console.log(`${icon} ${index + 1}. ${result.test}`);
        });

        console.log('');
        if (failCount === 0) {
            console.log('🎉 All tests passed! The daily log automation system is working correctly.');
        } else {
            console.log(`⚠️  ${failCount} test(s) failed. Please review the implementation.`);
        }

        console.log('='.repeat(60));

        return { passCount, failCount, total };
    }

    /**
     * Run all tests
     */
    async runAllTests() {
        console.log('🚀 Starting Daily Log Automation Test Suite...');

        try {
            this.setupTestEnvironment();
            this.testActivityExtraction();
            this.testDailyLogFormatting();
            this.testFileOperations();
            this.testSystemIntegration();

            const results = this.generateReport();

            return results.failCount === 0;

        } catch (error) {
            console.error('💥 Test suite failed with error:', error.message);
            return false;

        } finally {
            this.cleanup();
        }
    }
}

// Run tests if called directly
if (require.main === module) {
    const tester = new DailyLogTester();
    tester.runAllTests().then(success => {
        process.exit(success ? 0 : 1);
    });
}

module.exports = DailyLogTester;