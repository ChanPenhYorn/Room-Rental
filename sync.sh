#!/bin/bash

# Check if a commit message was provided
if [ -z "$1" ]; then
    echo "Usage: ./sync.sh \"your commit message\""
    exit 1
fi

COMMIT_MSG=$1

echo "--- Staging all changes ---"
git add .

echo "--- Committing changes: $COMMIT_MSG ---"
git commit -m "$COMMIT_MSG"

echo "--- Pushing to origin ---"
git push

echo "--- Done! ---"
