#!/bin/bash

if [ -z "$SUBMODULES_HOME" ]; then

  echo "ERROR: SUBMODULES_HOME not defined"
  exit 1
fi

if [ -z "$REPO_TOOLKIT" ]; then

  REPO_TOOLKIT="git@github.com:red-elf/Project-Toolkit.git"
fi

TARGET="$SUBMODULES_HOME"

if cd "$TARGET" && ! git status; then

  git clone "$REPO_TOOLKIT" . &&
    git submodule init && git submodule update && \
    echo "Project Toolkit has been installed:" && \
    cd "$SUBMODULES_HOME" && ls -lF
    
else

  echo "ERROR: Installation directory is invalid '$TARGET'"
  exit 1  
fi

