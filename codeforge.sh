#!/bin/bash

# apply common functions
source "$(pwd)"/src/scripts/utils.sh >/dev/null

# apply deps functions
source "$(pwd)"/src/scripts/java_deps.sh >/dev/null

# apply tools functions
source "$(pwd)"/src/scripts/scan_tools.sh >/dev/null

# apply variables functions
source "$(pwd)"/src/scripts/variables.sh >/dev/null

# apply func_complete functions
source "$(pwd)"/src/scripts/func_complete.sh >/dev/null
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
    mvn-dep-bom)
        mvn_dep_bom "${POM_FILE_PATH}" "$(pwd)/target/deps/bom"
        ;;
    mvn-dep-tree)
        mvn_dep_tree "${POM_FILE_PATH}" "$(pwd)/target/deps/"
        ;;
    gradle-deps)
        gradle_deps "${GRADLE_FILE_PATH}" "${TARGET_DIR_PATH}"
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
        scan_with_snyk "${POM_FILE_PATH}" "${SNYK_TOKEN}" "$(pwd)/target/reports/"
        ;;
    owasp)
        scan_with_owasp "${POM_FILE_PATH}" "${TARGET_DIR_PATH}" "${OWASP_OUT_FORMAT}"
        ;;
    blackduck)
        scan_with_blackduck
        ;;
    *)
        echo "$UNKNOWN_MSG: $tool"
        display_help
        ;;
    esac
}

# Main function to handle commands
main() {

    local command="$1"

    # Register auto-completion function
    complete -F complete_command "$command"

    shift

    case "$command" in
    --analyze | -a)
        analyze_command "$@"
        ;;
    --scan | -s)
        scan_command "$@"
        ;;
    --help | -h)
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
