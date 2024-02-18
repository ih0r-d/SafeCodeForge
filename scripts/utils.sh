#!/bin/bash

set -e

# ANSI escape codes for text formatting
BLUE='\e[34m'    # Blue text
YELLOW='\e[33m'  # Yellow text
RED='\e[31m'     # Red text
BOLD='\e[1m'     # Bold text
GREEN='\e[32m'   # Green text
RESET='\e[0m'    # Reset text formatting
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

# application constants
UNKNOWN_MSG="Unknown command:"
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

analisys_log(){
  local out_file_path=$1
  log "INFO" "${SEPARTAOR_LINE}"
  log "INFO" "ANALYSIS COMPLETED"
  log "INFO" ""
  log "INFO" "Output fite:\t${out_file_path}"
}

# Function to display help information for the CLI application
display_help() {
    # ANSI color codes
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    MAGENTA='\033[0;35m'
    CYAN='\033[0;36m'
    BOLD='\033[1m'
    RESET='\033[0m'

    printf "${BOLD}Usage:${RESET} ${GREEN}$0${RESET} ${BLUE}[command] [options]${RESET}\n\n"
    printf "${BOLD}Description:${RESET}\n  ${YELLOW}[Brief description of what the CLI application does.]${RESET}\n\n"
    printf "${BOLD}Commands:${RESET}\n"
    printf "  ${CYAN}command1${RESET}         ${MAGENTA}[Description of command1]${RESET}\n"
    printf "  ${CYAN}command2${RESET}         ${MAGENTA}[Description of command2]${RESET}\n"
    printf "  ...\n\n"
    printf "${BOLD}Options:${RESET}\n"
    printf "  ${GREEN}-h, --help${RESET}       ${BLUE}Show help information${RESET}\n"
    printf "  ${GREEN}-v, --version${RESET}    ${BLUE}Show version information${RESET}\n"
    printf "  ...\n\n"
    printf "${BOLD}Examples:${RESET}\n"
    printf "  ${MAGENTA}[Example usages of the CLI application and its commands]${RESET}\n\n"
    printf "For more information, visit ${CYAN}[URL for additional documentation]${RESET}.\n"
}

# Example usage of the help function
display_help
