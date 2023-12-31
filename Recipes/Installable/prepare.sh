#!/bin/bash

HERE="$(pwd)"
GENERATED="Application/generated"

if test -e "$GENERATED"; then

  if ! sudo rm -rf "$GENERATED"; then

    echo "ERROR: Could not remove the '$GENERATED' directory"
    exit 1
  fi
fi

# TODO: Generate the Go code:
#
#   - Check if there are SQls at expected location
#   - If so perform code generating to expected destination
#   - Determine the type of required code for the project to generate
#
# echo "Generating the code"
#
# if mkdir "$GENERATED" && /usr/local/bin/sql2code-0.0.3/sql2code -i \
#             Database/DDL/Services/Authentication/Definition.V1.sql \
#             Database/DDL/Definition.V1.sql \
#             Database/DDL/Extensions/Chats/Definition.V1.sql \
#             Database/DDL/Extensions/Documents/Definition.V1.sql \
#             Database/DDL/Extensions/Times/Definition.V1.sql \
#             -t cpp -o "$GENERATED"; then
#
#     echo "Code generated"
#
# else
#
#     echo "ERROR: Code not generated"
#     exit 1
# fi

if [ -z "$DEPENDABLE_DEPENDENCIES_HOME" ]; then

  DEPENDABLE_DEPENDENCIES_HOME="$HERE"
fi

echo "The dependencies home directory: '$DEPENDABLE_DEPENDENCIES_HOME'"

DEPENDENCIES_WORKING_DIRECTORY="$DEPENDABLE_DEPENDENCIES_HOME/_Dependencies"

echo "The dependencies working directory: '$DEPENDENCIES_WORKING_DIRECTORY'"
