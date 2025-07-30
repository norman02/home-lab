# 🧰 osTicket Setup Guide

This document outlines the steps used to install and configure the osTicket support system in the home lab.

---

## 🖥️ VM Details

- OS: Ubuntu Server 22.04 LTS
- Hostname: `osticket`
- Network: Bridged or NAT with port forwarding
- IP Address: DHCP/static depending on lab config

---

## 📦 Software Stack

- Apache2
- MariaDB
- PHP 8.x
- osTicket v1.17.4

### Required PHP Modules

```bash
php php-mysql php-imap php-intl php-common php-mbstring php-apcu php-cli php-curl php-gd php-xml

