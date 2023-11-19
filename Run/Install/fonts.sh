#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not available"
  exit 1
fi

SCRIPT_INSTALL_FONTS="$SUBMODULES_HOME/Software-Toolkit/Utils/Sys/Fonts/install_fonts.sh"

if ! test -e "$SCRIPT_INSTALL_FONTS"; then

  echo "ERROR: Script not found '$SCRIPT_INSTALL_FONTS'"
  exit 1
fi

sh "$SCRIPT_INSTALL_FONTS"