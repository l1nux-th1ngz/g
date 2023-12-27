#!/bin/bash

# Update the package lists for upgrades and new package installations
sudo apt-get update

# Install SQLite3
echo "Installing SQLite3..."
sudo apt-get install -y sqlite3

# Install Git
echo "Installing Git..."
sudo apt-get install -y git

# Add a new system user for Git
echo "Adding a new system user for Git..."
sudo adduser --system --group --disabled-password --shell /bin/bash --home /home/git --gecos 'Git Version Control' git

# Download Gitea
echo "Downloading Gitea..."
wget -O /tmp/gitea https://dl.gitea.io/gitea/1.20/gitea-1.20-linux-amd64

# Move Gitea to the appropriate directory
echo "Moving Gitea to the appropriate directory..."
sudo mv /tmp/gitea /usr/local/bin

# Make Gitea executable
echo "Making Gitea executable..."
chmod +x /usr/local/bin/gitea

# Create necessary directories for Gitea
echo "Creating necessary directories for Gitea..."
mkdir -p /var/lib/gitea/{custom,data,indexers,public,log}

# Change ownership of the Gitea directories
echo "Changing ownership of the Gitea directories..."
chown git: /var/lib/gitea/{data,indexers,log}

# Change permissions of the Gitea directories
echo "Changing permissions of the Gitea directories..."
chmod 750 /var/lib/gitea/{data,indexers,log}

# Create a directory for Gitea's configuration files
echo "Creating a directory for Gitea's configuration files..."
mkdir /etc/gitea

# Change ownership of the Gitea configuration directory
echo "Changing ownership of the Gitea configuration directory..."
chown root:git /etc/gitea

# Change permissions of the Gitea configuration directory
echo "Changing permissions of the Gitea configuration directory..."
chmod 770 /etc/gitea

# Download the Gitea service file
echo "Downloading the Gitea service file..."
wget https://raw.githubusercontent.com/go-gitea/gitea/master/contrib/systemd/gitea.service -P /etc/systemd/system/

# Reload the systemd daemon
echo "Reloading the systemd daemon..."
systemctl daemon-reload

# Enable Gitea to start on boot
echo "Enabling Gitea to start on boot..."
systemctl enable --now gitea

# Check the status of the Gitea service
echo "Checking the status of the Gitea service..."
systemctl status gitea

# Allow traffic on port 3000
echo "Allowing traffic on port 3000..."
ufw allow 3000/tcp

echo "Installation complete. Please navigate to your browser to complete the setup."
sleep 70
