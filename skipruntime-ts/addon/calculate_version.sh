#!/bin/sh

# Script to calculate the version of the skipruntime library to link
# Used by build script in package.json
#
# Set SKIPRUNTIME_VERSION to "dev" to link unversioned skipruntime.so
# Set SKIPRUNTIME_VERSION to a specific version to link that version
# Unset SKIPRUNTIME_VERSION to read version from package.json

if [ "$SKIPRUNTIME_VERSION" = "dev" ]; then
  echo ""
elif [ -n "$SKIPRUNTIME_VERSION" ]; then
  echo "-$SKIPRUNTIME_VERSION"
else
  echo "-$(npm pkg get version | tr -d '{}" \n' | cut -d: -f2)"
fi
