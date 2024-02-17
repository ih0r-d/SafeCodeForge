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

    output="[$color$log_level$RESET]\t---\t${GREEN}$message$RESET"
    printf "%b\n" "$output"
}


function measure_time_in_sec() {
  local func_name=$1
  real_time=$( { time $func_name; } 2>&1 | grep real | awk '{print $2}' )
  real_time_seconds=$(echo "$real_time" | awk -F'm|s' '{print ($1 * 60) + $2}')
  log "INFO" "Total time of ${func_name} function: ${real_time_seconds} s"
}
