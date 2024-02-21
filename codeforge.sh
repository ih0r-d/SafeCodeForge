#!/bin/bash

# apply common functions
source "$(pwd)"/scripts/utils.sh >/dev/null

# apply deps functions
source "$(pwd)"/scripts/java_deps.sh >/dev/null

# apply tools functions
source "$(pwd)"/scripts/scan_tools.sh >/dev/null

# apply variables functions
source "$(pwd)"/scripts/variables.sh >/dev/null

# apply func_complete functions
source "$(pwd)"/scripts/func_complete.sh >/dev/null
#

# Handle analyze command
analyze_command() {
    local option="$1"

    case "$option" in
        mvn-dep-list)
            analyze_mvn_dep_list "${POM_FILE_PATH}" "${TARGET_DIR_PATH}"
            ;;
        mvn-dep-update)
            analyze_mvn_dep_update "${POM_FILE_PATH}" "${TARGET_DIR_PATH}"
            ;;
        *)
            echo "Invalid option: $option"
            display_help
            ;;
    esac
}

# Handle scan command
scan_command() {
    local tool="$1"

    case "$tool" in
        snyk)
            scan_with_snyk
            ;;
        owasp)
            scan_with_owasp
            ;;
        blackduck)
            scan_with_blackduck
            ;;
        *)
            echo "Invalid tool: $tool"
            display_help
            ;;
    esac
}


# Main function to handle commands
main() {
    local command="$1"
    shift

    case "$command" in
        --analyze|-a)
            analyze_command "$@"
            ;;
        --scan|-s)
            scan_command "$@"
            ;;
        --help|-h)
            display_help "$@"
            ;;
        *)
            log "ERROR" "$UNKNOWN_MSG $command"
            display_help
            ;;
    esac
}

# Check if the correct number of arguments is provided
if [ "$#" -lt 1 ]; then
    display_help
fi

# Call the main function with provided arguments
main "$@"
