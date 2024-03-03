#!/bin/bash

set -e
set -u


# apply common functions
source "$(pwd)"/src/scripts/utils.sh >/dev/null


# Function to handle vulnerability scanning with Snyk
scan_with_snyk() {
  chmod_mvn_wrapper
  local pom_file_path="$1"
  local snyk_token="$2"
  local target_dir="$3"
  # this check is useless per se, but this has a more descriptive message rather than the one given by the plugin
  if test -z "$snyk_token"; then
  	log "ERROR" 'Not present SNYK_TOKEN'
  	exit 1
  fi

  if [ ! -d "$target_dir" ]; then
    mkdir -p "$target_dir"
  fi

  target_file=$(build_file_name "snyk_report" 'log')


  # run the plugin, note that the plugin can only take the API token from pom.xml, not by using user properties
  ./src/java/mvnw -f "${pom_file_path}/pom.xml" io.snyk:snyk-maven-plugin:2.1.1:test | tee "$target_dir/$target_file"

}

# Function to handle vulnerability scanning with OWASP Dependency-Check
scan_with_owasp() {
  echo "Scanning for vulnerabilities with OWASP Dependency-Check..."
  chmod_mvn_wrapper
  local pom_file_path="${1:-''}"
  local output_file_path="${2:-''}"
  local output_format="${3:-'json'}"

  file_name=''
  mvn_opts=''
  source_file=''

  if [ ! -d "${output_file_path}" ]; then
      mkdir -p "${output_file_path}"
  fi

  if [[ output_format == 'json' ]]; then
    file_name=$(build_file_name "owasp_report" 'json')
    mvn_opts="-Dformats=JSON -Dodc.outputDirectory=$pom_file_path/target -DscanDirectory=src/main/java"
    source_file="dependency-check-report.json"
  else
    file_name=$(build_file_name "owasp_report" 'csv')
    mvn_opts="-Dformats=CSV -Dodc.outputDirectory=$pom_file_path/target -DscanDirectory=src/main/java"
    source_file="dependency-check-report.csv"
  fi


  ./src/java/mvnw -q -f "${pom_file_path}/pom.xml" $mvn_opts org.owasp:dependency-check-maven:7.1.1:check
  mv "$pom_file_path"/target/$source_file "$(pwd)/$output_file_path/$file_name"

  if which csvtool; then
  	cat "$(pwd)/$output_file_path/$file_name" \
  		| csvtool cols '3,7,8,10-' - \
  		| sponge "$(pwd)/$output_file_path/$file_name"
  fi

  analisys_log "$(pwd)/$output_file_path/$file_name"

}

## Function to handle vulnerability scanning with Black Duck
#scan_with_blackduck() {
#    echo "Scanning for vulnerabilities with Black Duck..."
#    # Add your logic here
#}