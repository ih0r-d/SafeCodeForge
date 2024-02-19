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
    printf "${BOLD}Usage:${RESET} ${GREEN}$0${RESET} ${BLUE}[command] [options]${RESET}\n\n"
    printf "${BOLD}Commands:${RESET}\n"
    printf "\t${CYAN}analyze <option>${RESET}\t${MAGENTA}[Analyze maven dependencies]${RESET}\n"
    printf "\t${CYAN}${BOLD}Options:${RESET}\t${RESET}\n"
    printf "\t\t${GREEN}mvn-dep-list${GREEN}\t${MAGENTA}[Get and save to csv file list of dependencies]${RESET}\n\n"
    printf "\t${CYAN}scan <tool>${RESET}\t\t${MAGENTA}[Scan for vulnerabilities using the specified tool]${RESET}\n"
    printf "\t${CYAN}${BOLD}Options:${RESET}\t\t${RESET}\n"
    printf "\t\t${GREEN}snyk${GREEN}\t\t${MAGENTA}[Use Snyk for vulnerability scanning]${RESET}\n"
    printf "\t\t${GREEN}owasp${GREEN}\t\t${MAGENTA}[Use OWASP Dependency-Check for vulnerability scanning]${RESET}\n"
    printf "\t\t${GREEN}blackduck${GREEN}\t${MAGENTA}[Use Black Duck for vulnerability scanning]${RESET}\n\n"

    exit 1
}
