#!/bin/bash

recreate_directory() {

    if [ -z "$1" ]; then

        echo "recreate_directory :: ERROR: Please provide the directory you want to recreate"
        exit 1
    fi

    WHAT="$1"

    if ! test -e "$WHAT"; then

        echo "recreate_directory :: ERROR: Directory does not exist '$WHAT'"
        exit 1
    fi

    echo "recreate_directory :: Recreating: '$WHAT'" && \
        rm -rf "$WHAT" && mkdir -p "$WHAT" && cd "$WHAT" && pwd && ls -lFa
}