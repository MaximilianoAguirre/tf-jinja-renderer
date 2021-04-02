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

# Save template to temporal file
echo $jinja_template > template.tmp
echo $data > data.json

# Create args to run jinja
args=()

# Check if filters have been submitted and add an argument if so
if [[ $(echo $filters | jq length) -ne 0 ]]; then
    echo $filters |
    jq -r '.[]' |
    awk -F "\\" '{print "touch filter"NR-1".py && echo \""$1"\" >> filter"NR-1".py"}' |
    xargs -0 bash -c

    # to_entries | map("filter\(.key).py") | join(" ")

    args+=(--filters $(echo $filters | jq -r '. | join(" ")'))
fi

# Run jinja
# RESULT=$(docker run -v $module_directory:/app --rm jinja template.tmp data.json "${args[@]}")
RESULT=$(docker run -v $module_directory:/app --rm jinja template.tmp data.json)

# Remove temporal file
rm template.tmp
rm data.json
rm *.py

# Parse output
jq -n \
--arg r "$RESULT" \
'{ "result": $r }'
