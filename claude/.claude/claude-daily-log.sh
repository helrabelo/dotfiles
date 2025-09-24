#!/bin/bash

# Claude Daily Log - Slash Command Interface
# This script provides a convenient interface for generating daily logs
# Usage: ./claude-daily-log.sh [date] [options]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOMATION_SCRIPT="$SCRIPT_DIR/daily-log-automation.js"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to show help
show_help() {
    cat << EOF
Claude Daily Log - Slash Command Interface

USAGE:
    claude-daily-log [DATE] [OPTIONS]

ARGUMENTS:
    DATE                Date in YYYY-MM-DD format (default: today)

OPTIONS:
    -o, --output PATH   Custom output file path
    -q, --quiet         Quiet mode (minimal output)
    -v, --verbose       Verbose mode (detailed output)
    -h, --help          Show this help message

EXAMPLES:
    claude-daily-log                           # Generate log for today
    claude-daily-log 2025-09-22              # Generate log for specific date
    claude-daily-log -o ~/custom-log.md      # Custom output path
    claude-daily-log 2025-09-22 -v           # Verbose mode

SLASH COMMANDS (for Claude integration):
    /daily-log          # Generate today's log
    /daily-log 2025-09-22  # Generate specific date log
    /daily-log --yesterday  # Generate yesterday's log
    /daily-log --week      # Generate logs for the current week

EOF
}

# Function to get yesterday's date
get_yesterday() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        date -v-1d +%Y-%m-%d
    else
        # Linux
        date -d "yesterday" +%Y-%m-%d
    fi
}

# Function to validate date format
validate_date() {
    local date_input=$1
    if [[ $date_input =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to generate week logs
generate_week_logs() {
    print_info "Generating daily logs for the current week..."

    # Get Monday of current week
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        monday=$(date -v-monday +%Y-%m-%d)
    else
        # Linux
        monday=$(date -d "last monday" +%Y-%m-%d)
    fi

    # Generate logs for each day of the week
    for i in {0..6}; do
        if [[ "$OSTYPE" == "darwin"* ]]; then
            current_date=$(date -v+${i}d -j -f "%Y-%m-%d" "$monday" +%Y-%m-%d)
        else
            current_date=$(date -d "$monday + $i days" +%Y-%m-%d)
        fi

        print_info "Generating log for $current_date..."
        node "$AUTOMATION_SCRIPT" --date "$current_date"
    done
}

# Main execution
main() {
    local target_date=""
    local output_path=""
    local quiet_mode=false
    local verbose_mode=false
    local week_mode=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -o|--output)
                output_path="$2"
                shift 2
                ;;
            -q|--quiet)
                quiet_mode=true
                shift
                ;;
            -v|--verbose)
                verbose_mode=true
                shift
                ;;
            --yesterday)
                target_date=$(get_yesterday)
                shift
                ;;
            --week)
                week_mode=true
                shift
                ;;
            -*)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
            *)
                if [[ -z "$target_date" ]]; then
                    if validate_date "$1"; then
                        target_date="$1"
                    else
                        print_error "Invalid date format: $1 (expected YYYY-MM-DD)"
                        exit 1
                    fi
                else
                    print_error "Too many arguments"
                    show_help
                    exit 1
                fi
                shift
                ;;
        esac
    done

    # Check if Node.js is available
    if ! command -v node &> /dev/null; then
        print_error "Node.js is required but not found. Please install Node.js."
        exit 1
    fi

    # Check if automation script exists
    if [[ ! -f "$AUTOMATION_SCRIPT" ]]; then
        print_error "Automation script not found: $AUTOMATION_SCRIPT"
        exit 1
    fi

    # Handle week mode
    if [[ "$week_mode" == true ]]; then
        generate_week_logs
        exit 0
    fi

    # Build command
    local cmd_args=()

    if [[ -n "$target_date" ]]; then
        cmd_args+=("--date" "$target_date")
    fi

    if [[ -n "$output_path" ]]; then
        cmd_args+=("--output-path" "$output_path")
    fi

    # Execute the automation script
    if [[ "$quiet_mode" == true ]]; then
        node "$AUTOMATION_SCRIPT" "${cmd_args[@]}" > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            print_success "Daily log generated successfully"
        else
            print_error "Failed to generate daily log"
            exit 1
        fi
    else
        if [[ "$verbose_mode" == true ]]; then
            print_info "Executing: node $AUTOMATION_SCRIPT ${cmd_args[*]}"
        fi

        node "$AUTOMATION_SCRIPT" "${cmd_args[@]}"

        if [[ $? -eq 0 ]]; then
            print_success "Daily log automation completed successfully!"
        else
            print_error "Daily log automation failed"
            exit 1
        fi
    fi
}

# Handle slash command style invocation
if [[ "$1" == "/daily-log" ]]; then
    # Remove the slash command and pass remaining args
    shift
    main "$@"
else
    main "$@"
fi