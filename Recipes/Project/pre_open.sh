#!/bin/bash

HERE=$(pwd)

SCRIPT="$HERE/Recipes/Installable/prepare.sh"

if ! test -e "$SCRIPT"; then

    echo "ERROR: Pre-open :: Script not found '$SCRIPT'"
    exit 1
fi

sh "$SCRIPT"