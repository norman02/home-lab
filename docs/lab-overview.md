
---

### 📘 `lab-overview.md`

```markdown
# 🧪 Home IT Lab – Overview and Learning Goals

This document outlines the structure, purpose, and learning outcomes of the Home IT Lab project. The lab simulates a realistic corporate network using 10+ virtual machines segmented by function.

---

## 🎯 Purpose

To demonstrate core IT skills through a hands-on lab environment, including:

- Infrastructure design
- Networking and segmentation
- Automation with scripting
- Security hardening
- Logging and monitoring
- Ticket-based troubleshooting

---

## 🧱 Architecture

The network is segmented using pfSense and internal VirtualBox networks:

- **LAN (10.0.1.0/24)** – Internal servers (AD, osTicket, ELK, etc.)
- **DMZ (10.0.2.0/24)** – Externally-facing services (VPN, DVWA)
- **WORKSTATIONS (10.0.3.0/24)** – Simulated user machines
- **MGMT (10.0.4.0/24)** – Optional admin-only access

---

## 🔢 Core VM Inventory

See `README.md` for full table. Key roles include:

- **pfSense firewall** – Controls routing and access between segments
- **Active Directory** – Identity and domain services
- **osTicket** – Internal ticketing for simulated support tasks
- **ELK Stack** – Log aggregation and SIEM dashboards
- **Arch Linux** – Lightweight utility node for scripting and tooling

---

## 📑 Documentation Approach

All notes are maintained in:

- **Joplin** – Per-VM logs, daily notes, configuration details
- **GitHub** – Markdown-formatted guides, scripts, and outputs

Each section of the lab includes:

- ✅ Clear goals
- ✅ Tasks and scripts
- ✅ Markdown documentation
- ✅ Screenshots and logs where relevant

---

## 📈 Learning Outcomes

| Category           | Skills Demonstrated                              |
|--------------------|--------------------------------------------------|
| Sysadmin           | User management, backups, software installation |
| Networking         | Segmentation, VPN setup, ACLs                    |
| Security           | SSH hardening, IDS tools, log analysis          |
| Scripting          | Bash, Python, regex, log parsing                 |
| Help Desk          | Ticket creation, SLA simulation, email alerts   |
| Documentation      | Markdown, GitHub, workflow notes                 |

---

## 🏗️ Planned Expansion (Phase 4)

The lab will scale up to 20 VMs to simulate:

- Departmental endpoints (HR, Finance, Devs)
- Cloud/DevOps services (Docker, remote app)
- Internal infrastructure (DNS, mail server, file server)
- Security platforms (EDR, Security Onion)

---

## 🚀 Current Status

- ✅ Base 10 VMs selected and planned
- ⬜ Initial VMs under construction
- ⬜ Automation scripts in progress
- ⬜ Documentation and screenshots underway

