#!/bin/sh
set -e

# Check installed gems if missing
if [[ "$SCHEDULER_ENV" == "development" ]]
then
	bundle check || bundle install
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
