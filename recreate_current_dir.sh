#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

WHAT="$(pwd)"

SCRIPT_RECREATE="$SUBMODULES_HOME/recreate_dir.sh"

if ! test -e "$SCRIPT_RECREATE"; then

  echo "ERROR: Script not found '$SCRIPT_RECREATE'"
  exit 1
fi

cd .. && pwd && bash "$SCRIPT_RECREATE" "$WHAT"