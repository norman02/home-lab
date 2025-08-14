#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'


# install-osticket.sh
# Author: John Norman
# Purpose: Fully automated osTicket installation with a clean system slate on Ubuntu Server 22.04

set -e  # Exit immediately on errors

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

# --- Clean Slate ---
echo_step "🔄 Removing previous web/db installations and related configs..."

# Stop services if running
sudo systemctl stop apache2 mariadb mysql || true

# Purge old packages
sudo apt purge -y apache2* mariadb* mysql* php* libapache2-mod-php* unzip

# Remove leftover files and configs
sudo rm -rf /etc/apache2 /etc/mysql /etc/php /var/lib/mysql /var/www/html/* /var/log/mysql

# Clean package system
sudo apt autoremove -y
sudo apt autoclean
sudo apt update

# --- Install LAMP stack and PHP extensions ---
echo_step "📦 Installing Apache, MariaDB, PHP, and required extensions..."

sudo apt install -y apache2 mariadb-server unzip
sudo apt install -y php php-mysql php-imap php-intl php-common php-mbstring php-apcu php-cli php-curl php-gd php-xml

# --- Secure MariaDB (non-interactive equivalent) ---
echo_step "🔐 Securing MariaDB configuration..."
sudo mysql <<EOF
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

# --- Set up osTicket database and user ---
echo_step "🗃️ Creating osTicket database and user..."
sudo mysql -e "CREATE DATABASE ${DB_NAME};"
sudo mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# --- Download and Install osTicket ---
echo_step "⬇️ Downloading osTicket ${OSTICKET_VERSION}..."
cd /tmp
wget -q https://github.com/osTicket/osTicket/releases/download/${OSTICKET_VERSION}/osTicket-${OSTICKET_VERSION}.zip
unzip -q osTicket-${OSTICKET_VERSION}.zip

echo_step "📁 Installing osTicket to ${INSTALL_DIR}..."
sudo mv upload "${INSTALL_DIR}"
sudo cp ${INSTALL_DIR}/include/ost-sampleconfig.php ${INSTALL_DIR}/include/ost-config.php

# --- Set Permissions ---
echo_step "🔒 Setting permissions..."
sudo chown -R www-data:www-data ${INSTALL_DIR}
sudo chmod 0666 ${INSTALL_DIR}/include/ost-config.php

# --- Finalize ---
echo_step "🚀 Restarting and enabling services..."
sudo systemctl restart apache2
sudo systemctl restart mariadb
sudo systemctl enable apache2
sudo systemctl enable mariadb

# --- Success Message ---
echo_step "✅ Installation complete!"
echo "Open in your browser: http://<your-vm-ip>/osticket"
echo "DB Name:     ${DB_NAME}"
echo "DB User:     ${DB_USER}"
echo "DB Password: ${DB_PASS}"

