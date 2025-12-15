#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

WHAT="$(pwd)"

cd .. && echo "Recreating: '$WHAT'" && \
    rm -rf "$WHAT" && mkdir -p "$WHAT" && cd "$WHAT" && pwd