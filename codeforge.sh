#!/bin/bash

# apply common functions
source ./scripts/utils.sh >/dev/null

# apply deps functions
source ./java/dep-list.sh >/dev/null

# apply variables functions
source ./vars/variables.sh >/dev/null


# Parse command line arguments
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --command|-c)
    COMMAND="$2"
    shift # past argument
    shift # past value
    ;;
    *)
    # unknown option
    log "ERROR" "${UNKNOWN_MSG} $key"
    shift # past argument
    exit 1  # Exit the script with a non-zero status code to indicate an error
    ;;
esac
done

# Check the value of the mode variable
case $COMMAND in
    mvn-dep-list)
      mvn_dependency_list "$POM_FILE_PATH" "$OUTPUT_DEPS_FILE_PATH"
      log "INFO" "${SEPARTAOR_LINE}"
      ;;
    help)
      display_help
      ;;
    *)
      log "ERROR" "${NO_MODE_MSG}"
      display_help
      exit 1  # Exit the script with a non-zero status code to indicate an error
      ;;
esac