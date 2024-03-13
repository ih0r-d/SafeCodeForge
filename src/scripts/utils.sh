#!/bin/bash

set -e

# ANSI escape codes for text formatting
BLUE='\e[34m'   # Blue text
YELLOW='\e[33m' # Yellow text
RED='\e[31m'    # Red text
BOLD='\e[1m'    # Bold text
GREEN='\e[32m'  # Green text
RESET='\e[0m'   # Reset text formatting
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

# application constants
UNKNOWN_MSG="Unknown command:"
SEPARATOR_LINE="------------------------------------------------------------------------"

chmod_mvn_wrapper() {
  chmod 700 ./src/java/mvnw
}

chmod_gradle_wrapper() {
  chmod 700 ./src/java/gradlew
}

build_file_name() {
  local prefix="${1:-'dep_'}"
  local extension="${2:-'txt'}"
  time_str=$(date +"%Y-%m-%d-%H-%M-%S")
  file_name="${prefix}"_"${time_str}"."${extension}"
  echo "${file_name}"
}

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

analisys_log() {
  local out_file_path=$1
  log "INFO" "${SEPARATOR_LINE}"
  log "INFO" "ANALYSIS COMPLETED"
  log "INFO" ""
  log "INFO" "Output fite:\t${out_file_path}"
}

# Function to display help information for the CLI application
display_help() {
  printf "%b\n" ""
  printf "%b\n" "${BOLD}Usage:${RESET} ${GREEN}$0${RESET} ${BLUE}[command] [options]${RESET}"
  printf "%b\n" "${BOLD}Commands:${RESET}"
  printf "%b\n" ""
  printf "%b\n" " ${CYAN}-a, --analyze <option>${RESET}\t\tAnalyze dependencies"
  printf "%b\n" "    ${CYAN}${BOLD}Options:${RESET}\t"
  printf "%b\n" "\t${GREEN}mvn-dep-list${GREEN}\t\t${RESET}Use for analyze list dependencies in maven project"
  printf "%b\n" "\t${GREEN}mvn-dep-update${GREEN}\t\t${RESET}Use for analyze dependencies updates in maven project"
  printf "%b\n" "\t${GREEN}mvn-dep-bom${RESET}\t\t\tUse ${BLUE}cyclonedx plugin ${RESET}to make aggregation bom of dependencies"
  printf "%b\n" "\t${GREEN}mvn-dep-tree${RESET}\t\tUse ${BLUE}dependency plugin ${RESET}to make tree of dependencies"
  printf "%b\n" "\t${GREEN}gradle-deps${GREEN}\t\t${RESET}Use for analyze list dependencies in gradle project"
  printf "%b\n" ""
  printf "%b\n" " ${CYAN}-s, --scan <tool>${RESET}\t\t${RESET}Scan for vulnerabilities using the specified tool"
  printf "%b\n" "    ${CYAN}${BOLD}Options:${RESET}\t\t${RESET}"
  printf "%b\n" "\t${GREEN}snyk${GREEN}\t\t\t${RESET}Use Snyk for vulnerability scanning"
  printf "%b\n" "\t${GREEN}owasp${GREEN}\t\t\t${RESET}Use OWASP Dependency-Check for vulnerability scanning. Supported JSON,CSV output formats"
  #    printf "%b\n" "\t${GREEN}blackduck${GREEN}\t\t${RESET}Use Black Duck for vulnerability scanning"
  printf "%b\n" ""
  printf "%b\n" "  ${CYAN}-h, --help${RESET}\t\t\tDisplay help"
  printf "%b\n" ""
  printf "%b\n" ""

  exit 1
}
