#!/bin/bash

if [ -z "$1" ]; then

  echo "ERROR: Please provide the directory you want to recreate"
  exit 1
fi

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

WHAT="$1"

echo "Recreating: '$WHAT'" && \
    rm -rf "$WHAT" && mkdir -p "$WHAT" && cd "$WHAT" && pwd && ls -lFa && exec $SHELL