#!/bin/bash
set -e

# Change hostname (optional)
sudo hostnamectl set-hostname dockhost01

# Update system and install dependencies
sudo apt-get update -y
sudo apt-get install -y net-tools ca-certificates curl gnupg lsb-release

# Add Docker’s official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Ensure docker group exists
if ! getent group docker >/dev/null; then
  sudo groupadd docker
fi

# Add Jenkins user to docker group
if id "jenkins" &>/dev/null; then
  sudo usermod -aG docker jenkins
else
  echo "⚠️ Jenkins user does not exist. Skipping usermod step."
fi

# Optional: Relax socket permissions (only if Jenkins still cannot access Docker)
# sudo chmod 666 /var/run/docker.sock

# Verify installation
echo "✅ Docker installation completed!"
docker --version

