# 🧾 osTicket Server – Home Lab Documentation

This document outlines the installation, configuration, testing, and usage strategy for the `osTicket` support ticket system as part of the Home Cyber Lab. It is used to simulate helpdesk workflows and track issues arising from other machines.

---

## 🖥️ System Overview

| Component      | Value                 |
|----------------|-----------------------|
| Hostname       | `osticket`            |
| FQDN           | `osticket.lab`        |
| OS             | Ubuntu 25.04          |
| Web Server     | Apache 2.4.63         |
| PHP Version    | 8.3                   |
| Database       | MariaDB 11.4.7        |
| osTicket       | v1.17.4               |

---

## ⚙️ Installation

### 🔁 Step 1: Clone & Run Installer

Clone the repo and run the provisioning script:

```bash
git clone https://github.com/YOUR-USERNAME/home-lab.git
cd home-lab/scripts/
chmod +x install_osticket.sh
./install_osticket.sh
````

> 💡 Script installs Apache, PHP, MariaDB, and deploys osTicket under `/var/www/html/osticket`.

---

### 🧱 Step 2: Create MySQL Database

```bash
sudo mysql -u root -p

-- Inside MariaDB:
CREATE DATABASE osticket;
CREATE USER 'osticketuser'@'localhost' IDENTIFIED BY 'SecureP@ssw0rd';
GRANT ALL PRIVILEGES ON osticket.* TO 'osticketuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

---

### 🌐 Step 3: Web Setup

Visit: `http://osticket.lab/osticket/setup/`

Fill in:

* Helpdesk URL: `http://osticket.lab/osticket/`
* Name: `osTicket Lab`
* Default Email: `support@osticket.lab`
* Admin User Info (your choice)

---

### 🧹 Step 4: Cleanup Permissions

```bash
chmod 0644 /var/www/html/osticket/include/ost-config.php
```

---

## 🧪 Ticket Testing

### ✅ Manual Ticket Creation

Create tickets via the web interface at:

* `http://osticket.lab/osticket/open.php` (Guest)
* `http://osticket.lab/osticket/scp` (Staff/Admin)

Verified in DB with:

```sql
USE osticket;
SELECT t.ticket_id, c.subject, t.created
FROM ost_ticket t
LEFT JOIN ost_ticket__cdata c ON t.ticket_id = c.ticket_id
ORDER BY t.ticket_id DESC
LIMIT 10;
```

### ❌ Automated `curl` Ticket Creation

Tried submitting via `curl`:

```bash
curl -i -X POST \
  -F "847cee9b6e8e53=Test User" \
  -F "87f0b640f12afd=test@example.com" \
  -F "8afd2d634917ab=This is a test message." \
  -F "topicId=1" \
  -F "a=open" \
  http://osticket.lab/osticket/open.php
```

> ⚠️ Did not create ticket due to dynamic field names and required validation. Abandoned for realism.

---

## 📌 Key Paths

| File/Directory                               | Purpose               |
| -------------------------------------------- | --------------------- |
| `/var/www/html/osticket/`                    | osTicket install path |
| `/etc/apache2/sites-available/osticket.conf` | Apache vhost config   |
| `/var/log/apache2/error.log`                 | Web server error log  |
| `/etc/php/8.3/apache2/php.ini`               | PHP settings          |

---

## 🧠 Lessons Learned

* osTicket stores tickets across multiple tables (`ost_ticket`, `ost_ticket__cdata`).
* Dynamic hidden form fields make automation fragile.
* Manual ticket creation better simulates real-world helpdesk workflow.
* Post-install permission fix (`0644`) prevents 500 Internal Server Error on setup page.
* Installation script simplifies deployment but requires database setup verification.

---

## 🗃️ Credentials

Stored securely in Bitwarden:

* **Admin Panel**: `http://osticket.lab/osticket/scp`
* **Username**: (Set during setup)
* **Database**: `osticketuser / SecureP@ssw0rd`

---

## 📈 Strategy Going Forward

* Use osTicket to **track technical issues** across all lab machines.
* Open tickets **manually** as problems arise to simulate real support workflows.
* Consider testing canned responses and SLA behavior in future iterations.

```


