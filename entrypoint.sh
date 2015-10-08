#!/bin/bash
set -e

if [[ "$1" == "node" ]]; then
  echo "Performing npm install" >&2
  npm install --no-bin-links
  echo "Completed npm install. Starting app: $@" >&2
fi

exec "$@"
