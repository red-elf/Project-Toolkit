#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: The SUBMODULES_HOME is not defined"
  exit 1
fi

SCRIPT_DO_BRANDING="$SUBMODULES_HOME/Iconic/do_branding.sh"

if ! test -e "$SCRIPT_DO_BRANDING"; then

    echo "ERROR: Script not found '$SCRIPT_DO_BRANDING'"
    exit 1
fi

if [ -z "$1" ]; then

  echo "ERROR: Path to the launcher icon resource is mandatory (2)"
  exit 1
fi

LAUNCHER_ICON_PATH="$1"

sh "$SCRIPT_DO_BRANDING" "$LAUNCHER_ICON_PATH"

