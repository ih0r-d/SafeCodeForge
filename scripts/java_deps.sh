#!/bin/bash

set -e
set -u


# apply common functions
source "$(pwd)"/scripts/utils.sh >/dev/null


analyze_mvn_dep_list(){
  local pom_file_path="${1:-''}"
  local output_file_path="${2:-''}"

  chmod_mvn_wrapper

  # Check if TARGET_DIR exists, if not, create it
  if [ ! -d "${output_file_path}" ]; then
      mkdir -p "${output_file_path}"
  fi

  if [[ -z "$pom_file_path" ]]; then  # Check if the variable is unset or empty
      log "ERROR" "Variable 'POM_FILE_PATH' must be defined."
      exit 1  # Exit the function with an error status
  fi

  if [ -z "$output_file_path" ]; then  # Check if the variable is unset or empty
      log "ERROR" "Variable 'OUTPUT_DEPS_FILE_NAME' must be defined."
      exit 1  # Exit the function with an error status
  fi

  file_name=$(build_file_name "dep_list" "csv")

  ./java/mvnw -o dependency:list -f "${pom_file_path}/pom.xml" | \
  grep ":.*:.*:compile" | \
  sed -e "s/\[INFO\]    \([^:]*\):\([^:]*\):jar:\([^:]*\):compile/\1;\2;\3/" -e "s/ -- /;/" | \
  { echo "GroupId;ArtifactId;Version;Info"; cat; } | \
  sort -u > "$output_file_path/$file_name"

  analisys_log "$(pwd)/$output_file_path/$file_name"
  
}

analyze_mvn_dep_update(){
  chmod_mvn_wrapper
  local pom_file_path="${1:-''}"
  local output_file_path="${2:-''}"

  file_name=$(build_file_name "dep_updates" "txt")

  ./java/mvnw -f "${pom_file_path}/pom.xml" org.codehaus.mojo:versions-maven-plugin:display-dependency-updates > "$output_file_path/$file_name"
  analisys_log "$(pwd)/$output_file_path/$file_name"
}

gradle_deps(){
  chmod_gradle_wrapper
  local gradle_file_path="${1:-''}"
  local output_file_path="${2:-''}"

  file_name=$(build_file_name "deps" "txt")
  ./java/gradlew -b "${gradle_file_path}/build.gradle" -q dependencies > "$output_file_path/$file_name"
  analisys_log "$(pwd)/$output_file_path/$file_name"
}