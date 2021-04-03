#!/bin/bash

set -e

# Parse input
eval "$(jq -r '@sh "jinja_template=\(.jinja_template) filters=\(.filters) module_directory=\(.module_directory) data=\(.data)"')"

# Function to evaluate if  docker engine is installed and running
# If the condition is not met exit with failure
check_docker_engine () {
    if ! docker info >/dev/null 2>&1; then
        >&2 echo "Docker must be installed and running."
        exit 1
    fi
}

# Function to check if a docker image is built, if not, build process is executed
check_docker_image () {
    image=$(docker images --filter "reference=$1:$2" -q)
    if [ -z "$image" ]; then
        docker build -t $1:$2 $3 -q >/dev/null
    fi
}

# Check dependencies
check_docker_engine
check_docker_image "jinja" "latest" "$module_directory/jinja"

# Declare used variables
jinja_template_filename=$(basename $jinja_template)
data_filename=$(basename $data)

# Copy files to tmp folder
mkdir -p $module_directory/tmp
cp $jinja_template $module_directory/tmp
cp $data $module_directory/tmp

# Create args to run jinja
args=()

# Check if filters have been submitted and add an argument if so
if [[ $(echo $filters | jq length) -ne 0 ]]; then
    echo $filters | jq -r '.[]' | awk -v module_directory=$module_directory '{print "cp "$0" "module_directory"/tmp/"}' | xargs -0 bash -c

    args+=(--filters $(echo $filters | jq -r '.[]' | xargs -L1 basename | paste -sd " " -))
fi

# Run jinja
RESULT=$(docker run -v $module_directory/tmp:/app --rm jinja $jinja_template_filename $data_filename "${args[@]}")

# Remove temporal files
rm -rf $module_directory/tmp/

# Parse output
jq -n \
--arg r "$RESULT" \
'{ "rendered_template": $r }'
