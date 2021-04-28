#!/bin/bash

set -e

eval "$(jq -r '@sh "CONTAINER=\(.container)"')"

output=$(docker logs $CONTAINER)

jq -n \
--arg output "$output" \
'{ "rendered_template":$output }'