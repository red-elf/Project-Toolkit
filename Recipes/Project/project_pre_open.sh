#!/bin/bash

HERE=$(pwd)

SCRIPT_RECIPE_PRE_OPEN="$HERE/Recipes/Project/pre_open.sh"

if ! test -e "$SCRIPT_RECIPE_PRE_OPEN"; then

    echo "ERROR: Project pre-open :: Script not found '$SCRIPT_RECIPE_PRE_OPEN'"
    exit 1
fi

EXECUTE_RECIPE() {

    SCRIPT="$1"

    if test -e "$SCRIPT"; then

        if sh "$SCRIPT" >/dev/null 2>&1; then

            echo "Recipe executed with success: '$SCRIPT'"

        else

            echo "ERROR: Recipe failed, '$SCRIPT'"
            exit 1
        fi

    else

        echo "WARNING: No recipe found at $SCRIPT"
    fi
}

if [ -z "$GENERAL_SERVER" ]; then

    echo "ERROR: 'GENERAL_SERVER' variable is not set"
    exit 1
fi

echo "Checking the server availability: '$GENERAL_SERVER'"

if ! ping -c 2 "$GENERAL_SERVER"; then

    echo "ERROR: '$GENERAL_SERVER' is not accessible"
    exit 1
fi

EXECUTE_RECIPE "$SCRIPT_RECIPE_PRE_OPEN"
