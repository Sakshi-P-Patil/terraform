#!/bin/bash
set -e

# -------------------------------
# Step 1: Terraform
# -------------------------------
cd /path/to/terraform
terraform init
terraform apply -auto-approve

# Get the public IP
PUBLIC_IP=$(terraform output -raw public_ip)
echo "EC2 Public IP: $PUBLIC_IP"

# -------------------------------
# Step 2: Create Ansible inventory dynamically
# -------------------------------
cat > inventory.ini <<EOL
[webserver]
$PUBLIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=/root/.ssh/jenkins.pem
EOL

# -------------------------------
# Step 3: Run Ansible playbook
# -------------------------------
ansible-playbook -i inventory.ini /path/to/playbook.yml
