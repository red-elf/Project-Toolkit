#!/bin/bash

# TODO: Incorporate this as the part of integration tests.

HERE=$(pwd)
ASSETS="$HERE/Assets/JSON/Formatting"
SCRIPT_RUN="$HERE/Run/JSON/test_Formatting.sh"

if ! test -e "$ASSETS"; then

    echo "ERROR: Directory not found '$ASSETS'"
    exit 1
fi

if rm -f "$ASSETS/Formatted.*.json"; then

    echo "Existing formatted JSON file have been cleaned up from '$ASSETS'"
fi

if ! test -e "$SCRIPT_RUN"; then

    echo "ERROR: Script not found '$SCRIPT_RUN'"
    exit 1
fi

sh "$SCRIPT_RUN" "$ASSETS"
