#!/usr/bin/env python3
"""
BC Deploy Webhook Server
Listens for GitHub push events and triggers local Docker rebuild
"""

import http.server
import socketserver
import json
import subprocess
import os
import logging
from datetime import datetime

# Configuration
PORT = 9001
REPO_DIR = "/home/john/BC-Dev-Credit-Control"
LOG_FILE = "/home/john/BC-Dev-Credit-Control/cicd/deploy.log"
CONTAINER_NAME = "bc-sandbox"
GITHUB_SECRET = os.environ.get("GITHUB_WEBHOOK_SECRET", "")

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(LOG_FILE),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)


def log_message(message):
    logger.info(message)


def pull_latest():
    """Pull latest changes from GitHub"""
    log_message("Pulling latest changes from GitHub...")
    try:
        subprocess.run(["git", "fetch", "origin"], cwd=REPO_DIR, check=True, capture_output=True)
        subprocess.run(["git", "reset", "--hard", "origin/master"], cwd=REPO_DIR, check=True, capture_output=True)
        result = subprocess.run(["git", "rev-parse", "HEAD"], cwd=REPO_DIR, capture_output=True, text=True)
        commit = result.stdout.strip()
        log_message(f"Code updated to {commit}")
        return commit
    except subprocess.CalledProcessError as e:
        log_message(f"Git pull failed: {e}")
        return None


def build_extension():
    """Build the AL extension"""
    log_message("Building extension...")
    try:
        # In production: use alc.exe or AL-Go
        # For now, just verify files exist
        al_files = subprocess.run(
            ["find", ".", "-name", "*.al", "-type", "f"],
            cwd=REPO_DIR,
            capture_output=True,
            text=True
        )
        count = len(al_files.stdout.strip().split('\n'))
        log_message(f"Found {count} AL files")
        log_message("Build complete (simulated)")
        return True
    except Exception as e:
        log_message(f"Build failed: {e}")
        return False


def publish_to_container():
    """Publish extension to Docker container"""
    log_message(f"Publishing to Docker container: {CONTAINER_NAME}")
    try:
        # Check if container exists
        result = subprocess.run(
            ["docker", "ps", "-a", "--format", "{{.Names}}"],
            capture_output=True,
            text=True
        )
        containers = result.stdout.strip().split('\n')
        
        if CONTAINER_NAME in containers:
            log_message(f"Container {CONTAINER_NAME} exists")
            # In production with running BC container:
            # subprocess.run([
            #     "docker", "exec", CONTAINER_NAME,
            #     "Publish-NavContainerApp",
            #     "-AppName", "BC Dev Credit Control",
            #     "-SkipVerification"
            # ])
        else:
            log_message(f"Container {CONTAINER_NAME} not found - would create and deploy")
            # In production: create container with the extension pre-installed
            
        log_message("Extension published to container (simulated)")
        return True
    except Exception as e:
        log_message(f"Publish failed: {e}")
        return False


def handle_deploy(payload):
    """Handle deployment request"""
    repo = payload.get("repository", {})
    repo_name = repo.get("name", "")
    commit = payload.get("commit", "")
    
    log_message(f"Received deploy request for {repo_name}, commit: {commit}")
    
    if repo_name == "BC-Dev-Credit-Control":
        commit_hash = pull_latest()
        if commit_hash:
            if build_extension():
                if publish_to_container():
                    log_message("Deploy completed successfully!")
                    return {"status": "success", "message": "Deployment completed"}
        
        log_message("Deploy failed")
        return {"status": "error", "message": "Deployment failed"}
    
    log_message(f"Ignoring repository: {repo_name}")
    return {"status": "ignored", "message": "Repository not tracked"}


class WebhookHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps({
            "status": "ready",
            "service": "BC Deploy Webhook",
            "repo": "BC-Dev-Credit-Control"
        }).encode())
    
    def do_POST(self):
        if self.path == "/webhook/bc-deploy":
            content_length = int(self.headers.get("Content-Length", 0))
            body = self.rfile.read(content_length)
            
            try:
                payload = json.loads(body)
                result = handle_deploy(payload)
                
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps(result).encode())
            except json.JSONDecodeError:
                self.send_response(400)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps({"status": "error", "message": "Invalid JSON"}).encode())
        else:
            self.send_response(404)
            self.end_headers()


def main():
    log_message(f"Starting BC Deploy Webhook on port {PORT}")
    
    with socketserver.TCPServer(("", PORT), WebhookHandler) as httpd:
        log_message(f"Server running on http://0.0.0.0:{PORT}")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            log_message("Server stopped")


if __name__ == "__main__":
    main()
