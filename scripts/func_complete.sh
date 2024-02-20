#!/bin/bash

set -e
set -u

## FIXME: need to finalyze autocomplete 
# Define available commands and options
commands=("analyze" "scan" "help")  # Added "help" command
analyze_options=("mvn-dep-list")
scan_options=("snyk" "owasp" "blackduck")

# Function to handle auto-completion
complete_command() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$COMP_CWORD" in
        1)
            COMPREPLY=( $(compgen -W "${commands[*]}" -- "$cur") )
            ;;
        2)
            case "${COMP_WORDS[1]}" in
                "analyze")
                    COMPREPLY=( $(compgen -W "${analyze_options[*]}" -- "$cur") )
                    ;;
                "scan")
                    COMPREPLY=( $(compgen -W "${scan_options[*]}" -- "$cur") )
                    ;;
                *)
                    ;;
            esac
            ;;
        *)
            COMPREPLY=()
            ;;
    esac
}

# Register auto-completion function
# TODO: uncomment next line after resolve FIXME above
#complete -F complete_command "$0"
