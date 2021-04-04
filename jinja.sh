#!/bin/bash

set -e

# Parse input
eval "$(jq -r '@sh "jinja_template=\(.jinja_template) filters=\(.filters) module_directory=\(.module_directory) docker_tag=\(.docker_tag) data=\(.data)"')"

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
    image=$(docker images --filter "reference=$1" -q)
    if [ -z "$image" ]; then
        docker build -t $1 $2 -q >/dev/null
    fi
}

# Check dependencies
check_docker_engine
check_docker_image $docker_tag "$module_directory/jinja"

# Declare used variables
tmp=$module_directory/tmp

# Save template and data in files
mkdir -p $tmp
echo "$jinja_template" > $tmp/template.yaml
echo "$data" > $tmp/data.json

# Create args to run jinja
args=()

# Check if filters have been submitted and add an argument if so
if [[ $(echo $filters | jq length) -ne 0 ]]; then
    echo $filters | jq -r '.[]' | awk -v module_directory=$module_directory '{print "cp "$0" "module_directory"/tmp/"}' | xargs -0 bash -c

    args+=(--filters $(echo $filters | jq -r '.[]' | xargs -L1 basename | paste -sd " " -))
fi

# Run jinja
RESULT=$(docker run -v $module_directory/tmp:/app --rm jinja template.yaml data.json "${args[@]}")

# Remove temporal files
rm -rf $tmp

# Parse output
jq -n \
--arg r "$RESULT" \
'{ "rendered_template": $r }'
