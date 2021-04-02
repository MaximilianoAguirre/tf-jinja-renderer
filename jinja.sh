#!/bin/bash

set -e

# Parse input
eval "$(jq -r '@sh "W=\(.working_directory) T=\(.jinja_template) filters=\(.filters) module_directory=\(.module_directory) data=\(.data)"')"

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

# Create args to run jinja
args=()

# Check if filters have been submitted and add an argument if so
if [[ $(echo $filters | jq length) -ne 0 ]]; then
    args+=(--filters $(echo $filters | jq -r '. | join(" ")'))
fi

# Run jinja
RESULT=$(docker run --rm -v $W:/app jinja $T $data "${args[@]}")

# Parse output
jq -n \
--arg r "$RESULT" \
'{ "result": $r }'
