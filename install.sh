 #!/bin/bash

# Ensure the script is run as root or with sudo
if [ "$EUID" -ne 0 ]
then 
  echo "Please run as root or use sudo"
  exit
fi

# Update the package list
echo "Updating system packages..."
apt-get update -y
apt-get upgrade -y

# Install the necessary dependencies
echo "Installing software-properties-common and other dependencies..."
apt-get install -y software-properties-common curl

# Add Ansible PPA repository
echo "Adding Ansible PPA repository..."
apt-add-repository --yes --update ppa:ansible/ansible

# Install Ansible
echo "Installing Ansible..."
apt-get install -y ansible

# Verify the installation
echo "Verifying Ansible installation..."
ansible --version

# Output a success message
echo "Ansible installation completed successfully."
