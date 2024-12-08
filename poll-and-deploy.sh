#!/bin/bash

# Set the repository URL
repo_url="https://github.com/aagrxyz/aagr-blog.git"

# Check for changes
git fetch origin
if git diff --quiet origin/main...HEAD; then
    echo "No changes detected."
else
    echo "Changes detected. Pulling and deploying..."

    # Pull the latest Docker images
    docker-compose pull

    # Start or restart containers
    docker-compose up -d
fi
