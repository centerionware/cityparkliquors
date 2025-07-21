#!/bin/bash
set -euo pipefail

# Variables
REPO_URL="https://${GITLAB_USERNAME}:${CI_PUSH_TOKEN}@gitlab.centerionware.com/pyrofoxxx/website-2.git"
BRANCH="argocd"
FILE_PATH="website-nginx-deployment.yaml"
IMAGE_PREFIX="registry.gitlab.centerionware.com/pyrofoxxx/website-2"
NEW_TAG="$CI_COMMIT_SHORT_SHA"

# Clone only the argocd branch
git clone --single-branch --branch "$BRANCH" "$REPO_URL"
cd website-2

# Replace the image tag only to the end of the line
sed -i "s|\(\s*- image: $IMAGE_PREFIX:\)[^[:space:]]*|\1$NEW_TAG|" "$FILE_PATH"
cat $FILE_PATH

# Git config (for CI systems)
git config user.name "CI Bot"
git config user.email "ci-bot@example.com"

# Commit and push
git add "$FILE_PATH"
git commit -m "Update image tag to $NEW_TAG"
git push origin "$BRANCH"