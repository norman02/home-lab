# 🧪 Home IT Lab – Virtual Corporate Network Simulation

This project simulates a small-to-medium corporate IT environment using **VirtualBox**, [**OPNsense**](docs/network/opnsense-overview.md), and a mix of Linux and Windows virtual machines.  
It is designed to demonstrate hands-on skills in system administration, cybersecurity, automation, and documentation.

---

## 📌 Project Goals

- Build and manage a segmented internal network with [**OPNsense firewall**](docs/network/opnsense-overview.md), bridge-node, SIEM, application servers, and user endpoints.
- Automate common IT tasks using Bash and Python.
- Simulate help desk workflows using [**osTicket**](docs/workstations/osTicket.md) and a library of scripted tickets.
- Apply real-world system hardening and security practices.
- Document everything clearly for professional review.

---

## 🧱 Core Architecture (current build)

| VM / Node       | OS                     | Segment       | Role                                     |
| --------------- | ---------------------- | ------------- | ---------------------------------------- |
| **ParrotOS Host** | Parrot OS (physical)   | Host          | Main host running VirtualBox and lab VMs |
| **bridge-node** | Arch Linux              | Transit       | L2 bridge between host network and lab   |
| **opnsense-fw** | [OPNsense](docs/network/opnsense-overview.md) | Router/LAN    | Perimeter firewall & segmentation        |
| **admin-ws**    | [Parrot OS](docs/workstations/admin-ws-build.md) | LAN           | Admin workstation (lab management)       |
| **osTicket**    | Ubuntu + LAMP           | LAN           | Ticketing system                         |
| **elk-stack**   | Ubuntu + ELK            | LAN           | SIEM + log aggregation                   |
| **win10-target**| Windows 10              | LAN           | Employee endpoint                        |
| **metasploitable** | Metasploitable 2     | LAN           | Red team target                          |
| **arch-utils**  | Arch Linux              | LAN           | Utility node for scripting & monitoring  |

---

## 🗺️ Network Topology

See the [**Network Topology**](docs/network/topology.md) doc for a detailed ASCII diagram, segments, and planned VLAN layout.

**Current state:**  
ParrotOS (physical) → **bridge-node** → **OPNsense** → LAN ([**Admin-WS**](docs/workstations/admin-ws-build.md), [**osTicket**](docs/workstations/osTicket.md), and other lab nodes)

---

## 🧪 Lab Features

- ✅ Segmented Virtual Network using **OPNsense**
- ✅ Dedicated **[Admin Workstation](docs/workstations/admin-ws-build.md)** on LAN
- ✅ Help Desk simulation with **[osTicket](docs/workstations/osTicket.md)**
- ✅ Security monitoring with **ELK stack**
- ✅ Scripting with Bash, Python, and Arch Linux tools
- ✅ Red Team targets (DVWA, Metasploitable2)
- ✅ Centralized logging and monitoring
- ✅ System hardening and firewall policies
- 🔜 VLAN segmentation for DMZ, Workstations, and Servers

---

## 📂 Repository Structure

```plaintext
home-lab/
├── automation/        # Scripts for automation tasks
├── docs/              # Setup guides, hardening checklists, lab overview
│   ├── network/       # OPNsense, bridge-node, topology
│   ├── workstations/  # Admin-WS, osTicket
│   ├── ctf/           # CTF walkthroughs and notes
│   └── tickets/       # Simulated help desk tickets
├── VMs/               # (legacy location, being phased out)
├── .gitignore
├── README.md
└── lab-overview.md

