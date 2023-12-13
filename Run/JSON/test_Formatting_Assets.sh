#!/bin/bash

# TODO: Incorporate this as the part of integration tests.

HERE=$(pwd)
ASSETS="$HERE/Assets/JSON/Formatting"
SCRIPT_RUN="$HERE/Run/JSON/test_Formatting.sh"

if ! test -e "$ASSETS"; then

    echo "ERROR: Directory not found '$ASSETS'"
    exit 1
fi

if cd "$ASSETS" && rm -f Formatted.*  >/dev/null 2>&1; then

    echo "Existing formatted JSON file have been cleaned up from '$ASSETS'"
fi

if ! cd "$HERE" && test -e "$SCRIPT_RUN"; then

    echo "ERROR: Script not found '$SCRIPT_RUN'"
    exit 1
fi

bash "$SCRIPT_RUN" "$ASSETS"
