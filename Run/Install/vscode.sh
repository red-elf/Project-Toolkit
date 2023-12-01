#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: The SUBMODULES_HOME is not defined"
  exit 1
fi

HERE="$(pwd)"
DIR_TOOLKIT="$SUBMODULES_HOME/Software-Toolkit"

# shellcheck disable=SC1091
. "$HERE/Recipes/VSCode/installation_parameters_vscode.sh"

sh "$DIR_TOOLKIT/Utils/VSCode/install.sh"