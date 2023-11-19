#!/bin/bash

HERE=$(pwd)

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

DIR_SYS_FONTS=/usr/local/share/fonts

if test -e "$DIR_SYS_FONTS"; then

  sh "$SCRIPT_INSTALL_FONTS" "$HERE/Assets/Fonts" "$DIR_SYS_FONTS"
fi