#!/usr/bin/env bash
set -euo pipefail

# get-next-version.sh
# Calculate the next version based on the latest git tag and output GitHub Actions variables
# Usage: get-next-version.sh

# Tag prefix for fork repository
TAG_PREFIX="michael-v"

# Get the latest tag with the fork prefix, or use michael-v0.0.0 if no tags exist
LATEST_TAG=$(git tag -l "${TAG_PREFIX}*" --sort=-v:refname | head -n 1 || echo "${TAG_PREFIX}0.0.0")
if [ -z "$LATEST_TAG" ]; then
  LATEST_TAG="${TAG_PREFIX}0.0.0"
fi
echo "latest_tag=$LATEST_TAG" >> $GITHUB_OUTPUT

# Extract version number and increment
VERSION=$(echo $LATEST_TAG | sed "s/${TAG_PREFIX}//")
IFS='.' read -ra VERSION_PARTS <<< "$VERSION"
MAJOR=${VERSION_PARTS[0]:-0}
MINOR=${VERSION_PARTS[1]:-0}
PATCH=${VERSION_PARTS[2]:-0}

# Increment patch version
PATCH=$((PATCH + 1))
NEW_VERSION="${TAG_PREFIX}$MAJOR.$MINOR.$PATCH"

echo "new_version=$NEW_VERSION" >> $GITHUB_OUTPUT
echo "New version will be: $NEW_VERSION"