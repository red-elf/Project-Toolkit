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

if ! test -e "$WHAT"; then

    echo "ERROR: Directory does not exist '$WHAT'"
    exit 1
fi

MAIN="$SUBMODULES_HOME/main.sh"

if ! test -e "$MAIN"; then

    echo "ERROR: Toolkit main module not found '$MAIN'"
    exit 1
fi

. "$MAIN"

recreate_directory "$WHAT"
