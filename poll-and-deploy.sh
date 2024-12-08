#!/bin/bash

# Set the repository URL
repo_url="https://github.com/aagrxyz/aagr-blog.git"

# Navigate to the project directory
PROJECT_DIR="/home/aman/aagr-blog"
cd "$PROJECT_DIR" || { echo "Failed to navigate to project directory."; exit 1; }

# Pull the latest changes from GitHub
echo "Pulling latest changes from GitHub..."
git fetch origin
LOCAL_HASH=$(git rev-parse HEAD)
REMOTE_HASH=$(git rev-parse origin/main) # Adjust branch name if not "main"

if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
    echo "Changes detected. Updating repository..."
    git pull origin main

    # Pull latest Docker images and restart containers
    echo "Pulling latest Docker images..."
    docker compose pull

    echo "Restarting Docker containers..."
    docker compose up -d
else
    echo "No changes detected. Exiting."
fi

