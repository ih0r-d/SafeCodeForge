#!/bin/bash

set -e
set -u

# apply variables from another file
source ../../scripts/utils.sh >/dev/null

SEPARTAOR_LINE='------------------------------------------------------------------------'
TARGET_DIR='target/deps'


function dependency_list(){
  local pom_file_path="${1:-.}"
  local output_file_path="${2:-${TARGET_DIR}/list.csv}"


  # Check if TARGET_DIR exists, if not, create it
  if [ ! -d "${TARGET_DIR}" ]; then
      mkdir -p "${TARGET_DIR}"
  fi

  if [ -z "$pom_file_path" ]; then  # Check if the variable is unset or empty
      echo "Error: Variable 'pom_file_path' must be defined." >&2  # Output error message to stderr
      exit 1  # Exit the function with an error status
  fi

  mvn -o dependency:list -f "${pom_file_path}/pom.xml" | \
  grep ":.*:.*:compile" | \
  sed -e "s/\[INFO\]    \([^:]*\):\([^:]*\):jar:\([^:]*\):compile/\1;\2;\3/" -e "s/ -- /;/" | \
  { echo "GroupId;ArtifactId;Version;Info"; cat; } | \
  sort -u > "$output_file_path"

  log "INFO" "${SEPARTAOR_LINE}"
  log "INFO" "ANALYSIS COMPLETED"
  log "INFO" "${SEPARTAOR_LINE}"
  log "INFO" "Output fite:\t${output_file_path}"
}

dependency_list "$1" "$2"
measure_time_in_sec dependency_list
log "INFO" "${SEPARTAOR_LINE}"