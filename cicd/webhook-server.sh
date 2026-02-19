#!/bin/bash
# BC Deploy Webhook - triggers local Docker rebuild on GitHub push

# Configuration
PORT=9001
LOG_FILE="/home/john/BC-Dev-Credit-Control/cicd/deploy.log"
REPO_DIR="/home/john/BC-Dev-Credit-Control"
CONTAINER_NAME="bc-sandbox"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Pull latest changes from GitHub
pull_latest() {
    log "Pulling latest changes from GitHub..."
    cd "$REPO_DIR"
    git fetch origin
    git reset --hard origin/master
    log "Code updated to $(git rev-parse HEAD)"
}

# Build the extension (simulated - in production would compile AL)
build_extension() {
    log "Building extension..."
    # In production: use alc.exe or AL-Go
    # For now, just verify the build
    log "Build complete"
}

# Publish to Docker container (simulated)
publish_to_container() {
    log "Publishing to Docker container: $CONTAINER_NAME"
    
    # In production with BC container:
    # docker exec $CONTAINER_NAME Import-NAVEncryptionKey
    # docker exec $CONTAINER_NAME Publish-NavContainerApp -AppName "BC Dev Credit Control" -SkipVerification
    
    log "Extension published to container (simulated)"
}

# Main webhook handler
handle_request() {
    log "Received webhook request"
    
    # Read JSON payload
    read -r payload
    
    # Extract repo info
    repo=$(echo "$payload" | grep -o '"repository": *"[^"]*"' | cut -d'"' -f4)
    commit=$(echo "$payload" | grep -o '"commit": *"[^"]*"' | cut -d'"' -f4)
    
    log "Repository: $repo, Commit: $commit"
    
    if [ "$repo" = "BC-Dev-Credit-Control" ]; then
        pull_latest
        build_extension
        publish_to_container
        
        log "Deploy completed successfully!"
        echo "HTTP/1.1 200 OK"
        echo "Content-Type: application/json"
        echo ""
        echo '{"status": "success", "message": "Deployment triggered"}'
    else
        log "Unknown repository: $repo"
        echo "HTTP/1.1 200 OK"
        echo "Content-Type: application/json"
        echo ""
        echo '{"status": "ignored", "message": "Repository not tracked"}'
    fi
}

# Start webhook server
log "Starting BC Deploy Webhook on port $PORT"

# Simple HTTP server using netcat
while true; do
    echo -e "HTTP/1.1 200 OK\nContent-Type: text/plain\n\nReady" | nc -l -p $PORT -q1 > /dev/null 2>&1 || true
    
    # Read request
    request=$(nc -l $PORT 2>/dev/null)
    
    if echo "$request" | grep -q "POST /webhook/bc-deploy"; then
        handle_request
    fi
done
