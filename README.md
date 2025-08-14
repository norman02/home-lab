# 🧪 Home IT Lab – Virtual Corporate Network Simulation

This project simulates a small-to-medium corporate IT environment using VirtualBox, Parrot OS, and a mix of Linux and Windows virtual machines. It is designed to demonstrate hands-on skills in system administration, cybersecurity, automation, and documentation.

---

## 📌 Project Goals

- Build and manage a segmented internal network with firewalls, SIEMs, vulnerable systems, and user endpoints.
- Automate common IT tasks using Bash and Python.
- Simulate help desk workflows using osTicket and a library of scripted tickets.
- Apply real-world system hardening and security practices.
- Document everything clearly for professional review.

---

## 🧱 Core Architecture (10 VMs)

| VM Name          | OS                     | Segment      | Role                                     |
| ---------------- | ---------------------- | ------------ | ---------------------------------------- |
| `pfSense-fw`     | pfSense                | Router       | Internal firewall & segmentation         |
| `vpn-server`     | Debian/Ubuntu Server   | DMZ          | Remote access with WireGuard/OpenVPN     |
| `win10-target`   | Windows 10             | Workstation  | Employee endpoint                        |
| `metasploitable` | Metasploitable 2       | Workstation  | Red team target                          |
| `dvwa-lamp`      | Ubuntu + DVWA          | DMZ          | Vulnerable web app                       |
| `osTicket`       | Ubuntu + LAMP          | Internal     | Ticketing system                         |
| `ubuntu-log`     | Ubuntu Server          | Internal     | Centralized logs (rsyslog/journald)      |
| `elk-stack`      | Ubuntu + ELK           | Internal     | SIEM + log aggregation                   |
| `win-server-ad`  | Windows Server         | Internal     | Active Directory Domain Controller       |
| `arch-utils`     | Arch Linux             | Internal     | Utility node for scripting & monitoring  |

---

## 🧪 Lab Features

- ✅ Segmented Virtual Network using pfSense
- ✅ Help Desk simulation with osTicket
- ✅ Security monitoring with ELK stack
- ✅ Scripting with Bash, Python, and Arch Linux tools
- ✅ Red Team targets (DVWA, Metasploitable2)
- ✅ Centralized logging and monitoring
- ✅ System hardening and firewall policies
- 🔜 Expansion to 20 machines (HR, Finance, EDR, DNS, DevOps, etc.)

---

## 📂 Repository Structure

```plaintext
home-lab/
├── automation/        # Scripts for automation tasks
├── docs/              # Setup guides, hardening checklists, lab overview
├── tickets/           # Simulated ticket markdown exports
├── VMs/               # Per-VM notes and configuration tracking
├── .gitignore
├── README.md
└── lab-overview.md


## Contributing
Open PRs from feature branches; see .github/PULL_REQUEST_TEMPLATE.md.
