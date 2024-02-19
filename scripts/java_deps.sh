#!/bin/bash

set -e
set -u


# apply common functions
source $(pwd)/scripts/utils.sh >/dev/null


mvn_dependency_list(){
  local pom_file_path="${1:-''}"
  local output_file_path="${2:-''}"

  chmod 700 ./java/mvnw

  # Check if TARGET_DIR exists, if not, create it
  if [ ! -d "${TARGET_DIR}" ]; then
      mkdir -p "${TARGET_DIR}"
  fi

  if [[ -z "$pom_file_path" ]]; then  # Check if the variable is unset or empty
      log "ERROR" "Variable 'POM_FILE_PATH' must be defined."
      exit 1  # Exit the function with an error status
  fi

  if [ -z "$output_file_path" ]; then  # Check if the variable is unset or empty
      log "ERROR" "Variable 'OUTPUT_DEPS_FILE_NAME' must be defined."
      exit 1  # Exit the function with an error status
  fi


  ./java/mvnw -o dependency:list -f "${pom_file_path}/pom.xml" | \
  grep ":.*:.*:compile" | \
  sed -e "s/\[INFO\]    \([^:]*\):\([^:]*\):jar:\([^:]*\):compile/\1;\2;\3/" -e "s/ -- /;/" | \
  { echo "GroupId;ArtifactId;Version;Info"; cat; } | \
  sort -u > "$output_file_path"

  analisys_log $(pwd)/$output_file_path
  
}

mvn_dependency_update(){
  ./java/mvn org.codehaus.mojo:versions-maven-plugin:display-dependency-updates"${MVN_P_OPTS}" | tee "$TARGET_FILE"
}