#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

SCRIPT_FORMAT_JSON="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/JSON/format_json.sh"

if ! test -e "$SCRIPT_FORMAT_JSON"; then

    echo "ERROR: Script not found '$SCRIPT_FORMAT_JSON'"
    exit 1
fi

if [ -n "$1" ]; then

    SOURCE="$1"

    echo "Source JSON path: $SOURCE"

else

    echo "ERROR: The source JSON path is mandatory"
    exit 1
fi

sh "$SCRIPT_FORMAT_JSON" "$SOURCE"