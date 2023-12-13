#!/bin/bash

HERE="$(pwd)"

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

RECIPES="$HERE/Recipes"
SCRIPT_GET_SONAR_NAME="get_sonar_project_name.sh"
SCRIPT_GET_SONAR_NAME_FULL="$SUBMODULES_HOME/Software-Toolkit/Utils/SonarQube/$SCRIPT_GET_SONAR_NAME"

if ! test -e "$SCRIPT_GET_SONAR_NAME_FULL"; then

    echo "ERROR: Script not found '$SCRIPT_GET_SONAR_NAME_FULL'"
    exit 1
fi

# shellcheck disable=SC1090
. "$SCRIPT_GET_SONAR_NAME_FULL"

# shellcheck disable=SC1091
bash "$SUBMODULES_HOME/Testable/test.sh" "$RECIPES" "$HERE"
