#!/bin/bash

set -e

# ANSI escape codes for text formatting
BLUE='\e[34m'    # Blue text
YELLOW='\e[33m'  # Yellow text
RED='\e[31m'     # Red text
# shellcheck disable=SC2034
BOLD='\e[1m'     # Bold text
GREEN='\e[32m'   # Green text
RESET='\e[0m'    # Reset text formatting

# application constants
UNKNOWN_MSG="Unknown option:"
SEPARTAOR_LINE="------------------------------------------------------------------------"
TARGET_DIR="target/deps"


# Function to log messages with custom formatting
log() {
    local log_level="$1"
    local message="$2"

    case "$log_level" in
        "INFO")
            color="$BLUE"
            ;;
        "WARNING")
            color="$YELLOW"
            ;;
        "ERROR")
            color="$RED"
            ;;
        *)
            color="$RESET" # Default color (no color)
            ;;
    esac

    output="[$color$log_level$RESET]\t${GREEN}$message$RESET"
    printf "%b\n" "$output"
}

# fixme: integrate in all command
measure_time_in_sec() {
  local func_name=$1
  real_time=$({ time $func_name; } 2>&1 | grep real | awk '{print $2}')
  real_time_seconds=$(echo "$real_time" | awk -F'm|s' '{print ($1 * 60) + $2}')
  log "INFO" "Total time: $real_time"

}

# Function to display help information
display_help() {
#    echo "Usage: $0 <command>"
    echo "DRAFT help (need to implement):"
    echo "  command1   Description of command 1"
    echo "  command2   Description of command 2"
    echo "  command3   Description of command 3"
    echo "  ...        Additional commands"
}