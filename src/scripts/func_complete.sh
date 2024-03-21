#!/bin/bash

set -e
set -u

# Define available commands and options
commands=("analyze" "scan" "help") # Added "help" command
analyze_options=("mvn-dep-list")
scan_options=("snyk" "owasp" "blackduck")

# Function to handle auto-completion
complete_command() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$COMP_CWORD" in
    1)
        complete_reply=("$(compgen -W "${commands[*]}" -- "$cur")")
        ;;
    2)
        case "${COMP_WORDS[1]}" in
        "analyze")
            complete_reply=("$(compgen -W "${analyze_options[*]}" -- "$cur")")
            ;;
        "scan")
            complete_reply=("$(compgen -W "${scan_options[*]}" -- "$cur")")
            ;;
        *) ;;
        esac
        ;;
    *)
      complete_reply=()
      while IFS='' read -r line; do complete_reply+=("$line"); done < <()
        ;;
    esac
}
