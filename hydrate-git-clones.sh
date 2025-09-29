#!/bin/bash

# Registry file
REGISTRY="$HOME/.git-essentials/git-clones"

# Backup existing registry if it exists
if [ -f "$REGISTRY" ]; then
  cp "$REGISTRY" "$REGISTRY.backup.$(date +%s)"
  echo "Backed up existing registry to $REGISTRY.backup.$(date +%s)"
fi

# Create/clear the registry
>"$REGISTRY"

echo "Scanning for git repositories in ~/Desktop..."
echo "This may take a moment..."

# Find all .git directories, excluding common directories to skip
find ~/Desktop -name ".git" -type d \
  -not -path "*/node_modules/*" \
  -not -path "*/.venv/*" \
  -not -path "*/venv/*" \
  -not -path "*/.env/*" \
  -not -path "*/env/*" \
  -not -path "*/__pycache__/*" \
  -not -path "*/.tox/*" \
  -not -path "*/vendor/*" \
  -not -path "*/.next/*" \
  -not -path "*/dist/*" \
  -not -path "*/build/*" \
  -prune 2>/dev/null | while read gitdir; do

  repo_dir=$(dirname "$gitdir")

  # Get the remote URL (usually origin)
  remote=$(git -C "$repo_dir" remote get-url origin 2>/dev/null)

  if [ -n "$remote" ]; then
    echo "$remote -> $repo_dir" | tee -a "$REGISTRY"
  fi
done

echo ""
echo "✓ Registry hydrated at $REGISTRY"
echo "Total repositories found: $(wc -l <"$REGISTRY")"
