# 🖥️ osTicket VM – Ticketing System Simulation

## 📦 Base OS
- **Ubuntu Server 22.04 LTS**
- Hosted via: VirtualBox / QEMU
- Role: Ticketing system lab for IT support workflows

## 🎯 Purpose
This VM runs `osTicket` to simulate a help desk environment. It is used to practice ticket triage, SLA configuration, ticket automation, and end-user interaction workflows.

## 🧰 Installed Software
- Apache2
- MariaDB
- PHP 8.x + required extensions
- osTicket v1.17.4
- UFW firewall

## 🔐 Security Configuration
- MySQL root secured via `mysql_secure_installation`
- Admin panel password-protected
- Firewall allows HTTP/HTTPS only (SSH optional)
- Apache hardened with basic headers

## 🗂️ File Notes
- Installed to: `/var/www/html/osticket`
- Config file: `/var/www/html/osticket/include/ost-config.php`
- MySQL DB: `osticket`, user: `osticketuser`

## 📓 Documentation
- Setup Guide: [`docs/osTicket-setup.md`](../../docs/osTicket-setup.md)
- Sample Tickets: [`tickets/`](../../tickets/)
- Automation: Planned for future scripting

## 🧠 To-Do
- [ ] Complete full setup and admin login
- [ ] Configure ticket types, users, and agents
- [ ] Create and close 40+ simulated support tickets
- [ ] Export reports + screenshots for portfolio

