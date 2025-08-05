#!/bin/bash

# install-osticket.sh
# Author: John Norman
# Purpose: Automate osTicket installation on Ubuntu Server 22.04

set -e  # Exit immediately if a command exits with a non-zero status

# --- Configuration ---
DB_NAME="osticket"
DB_USER="osticketuser"
DB_PASS="SecureP@ssw0rd"
OSTICKET_VERSION="v1.17.4"
INSTALL_DIR="/var/www/html/osticket"

# --- Functions ---

echo_step() {
  echo -e "\n🛠️  $1"
}

# --- Start Script ---

echo_step "Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo_step "Installing Apache, MariaDB, PHP, and required extensions..."
sudo apt install apache2 mariadb-server unzip -y
sudo apt install php php-mysql php-imap php-intl php-common php-mbstring php-apcu php-cli php-curl php-gd php-xml -y

echo_step "Securing MariaDB (non-interactive)..."
sudo mysql <<EOF
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

echo_step "Creating osTicket database and user..."
sudo mysql -e "CREATE DATABASE ${DB_NAME};"
sudo mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

echo_step "Downloading osTicket ${OSTICKET_VERSION}..."
cd /tmp
wget https://github.com/osTicket/osTicket/releases/download/${OSTICKET_VERSION}/osTicket-${OSTICKET_VERSION}.zip
unzip osTicket-${OSTICKET_VERSION}.zip

echo_step "Installing osTicket to ${INSTALL_DIR}..."
sudo mv upload "${INSTALL_DIR}"
sudo cp ${INSTALL_DIR}/include/ost-sampleconfig.php ${INSTALL_DIR}/include/ost-config.php

echo_step "Setting permissions..."
sudo chown -R www-data:www-data ${INSTALL_DIR}
sudo chmod 0666 ${INSTALL_DIR}/include/ost-config.php

echo_step "Restarting Apache and enabling services..."
sudo systemctl restart apache2
sudo systemctl enable apache2
sudo systemctl enable mariadb

echo_step "✅ Installation complete!"
echo "Visit http://<your-vm-ip>/osticket to complete the web installer."
echo "Database name: ${DB_NAME}"
echo "User: ${DB_USER}"
echo "Password: ${DB_PASS}"

