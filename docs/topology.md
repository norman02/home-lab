# 🧱 Lab Topology – Software Development Company (v2)

## 📌 Context
- **Notebook:** Execution and Active Projects → Projects → Home Cyber Lab → Topology  
- **Type:** Lab topology / network design  
- **Status:** v2 – active reference  
- **Tags:** `home-lab` `network-topology` `vm-architecture` `opnsense` `bridge-node` `virtualbox` `project-docs`

---

## 🔭 High-Level Architecture

```

```
     ┌────────────────────────────────────────────────────┐
     │                     WAN/ISP                        │
     └────────────▲───────────────────────▲───────────────┘
                  │                       │
           (FW-OPNsense)             (VPN Users) ← future
                  │
 ╔════════════════╩════════════════════════════════════╗
 ║                    CORE SWITCH (Virtual)            ║
 ╚═══╤══════════════╤══════════════╤═════════════╤══════╝
     │              │              │             │
 VLAN 10         VLAN 30        VLAN 40       VLAN 50
 MGMT            DEV/BUILD      DMZ           LOG/MON
10.10.10.0/24   10.10.30.0/24  10.10.40.0/24  10.10.50.0/24
│              │              │             │
┌───────┴──────┐  ┌────┴─────┐  ┌─────┴─────┐   ┌────┴──────┐
│ AD-DC-01     │  │ DEV-WS   │  │ GitLab    │   │ SIEM-01   │
│ ADMIN-WS-01  │  │          │  │ Jenkins   │   │ Suricata  │
│ ADMIN-WS-02  │              │ osTicket    │
└──────▲───────┘              └─────▲───────┘
│                            │
VLAN 90 (Bridge) ←────┐     VLAN 60 (Targets)
10.10.90.0/24          │     10.10.60.0/24
│        │
┌────────────────────┴──┐  ┌──┴────────────┐
│     BRIDGE-01         │  │ META-01, DVWA │
│ (Arch, Host-only + 90)│  │ TARGET-\*      │
└───────────────────────┘  └───────────────┘


---

## 🧭 VLAN Plan

| VLAN | Name        | CIDR             | Gateway       | Notes                          |
|------|-------------|------------------|---------------|--------------------------------|
| 10   | MGMT        | 10.10.10.0/24    | 10.10.10.1    | AD DC, admin workstations      |
| 20   | CORP        | 10.10.20.0/24    | 10.10.20.1    | (future) user workstations     |
| 30   | DEV/BUILD   | 10.10.30.0/24    | 10.10.30.1    | Jenkins runners, dev tools     |
| 40   | DMZ         | 10.10.40.0/24    | 10.10.40.1    | Git/Wiki/osTicket              |
| 50   | LOG/MON     | 10.10.50.0/24    | 10.10.50.1    | SIEM stack (Wazuh/ELK)         |
| 60   | LAB/TARGETS | 10.10.60.0/24    | 10.10.60.1    | DVWA, Metasploitable, targets  |
| 90   | BRIDGE      | 10.10.90.0/24    | 10.10.90.1    | Access VLAN from host → lab    |
| 99   | VPN         | 10.10.99.0/24    | 10.10.99.1    | Remote VPN access (future)     |

---

## 🖥️ VM Layout by Role

### 🧱 Foundation – MGMT & Bridge

| Hostname        | Role                                     | VLAN      |
|-----------------|------------------------------------------|-----------|
| `BRIDGE-01`     | Arch Linux jumpbox (host-only + VLAN 90) | 90        |
| `FW-OPNsense`   | Firewall, VLAN router, DHCP, Suricata    | All       |
| `AD-DC-01`      | Windows Server 2022 – AD, DNS            | 10        |
| `ADMIN-WS-01`   | Linux admin workstation (Ubuntu)         | 10        |
| `ADMIN-WS-02`   | Windows admin workstation (Win11)        | 10        |

### 💻 Dev / DMZ (VLAN 30–40)

| Hostname        | Role                                | VLAN     |
|-----------------|-------------------------------------|----------|
| `GIT-01`        | Git (Gitea/GitLab)                  | 40       |
| `CI-01`         | Jenkins CI                          | 40       |
| `ARTIFACT-01`   | Nexus or Harbor                     | 40       |
| `WIKI-01`       | Internal wiki                       | 40       |
| `TICKETS-01`    | osTicket helpdesk system            | 40       |
| `DEV-WS-01`     | Dev box for pipelines / dev test    | 30       |

### 🔍 Monitoring (VLAN 50)

| Hostname        | Role                               | VLAN     |
|-----------------|------------------------------------|----------|
| `SIEM-01`       | Wazuh or ELK / OpenSearch stack    | 50       |
| `LOGSTASH-01`   | Log pipeline processor (optional)  | 50       |
| `SURICATA-01`   | IDS system                         | 50       |

### 🧪 Target Zone (VLAN 60)

| Hostname        | Role                              | VLAN     |
|-----------------|-----------------------------------|----------|
| `META-01`       | Metasploitable2                   | 60       |
| `DVWA-01`       | Damn Vulnerable Web App           | 60       |
| `TARGET-WIN-01` | Windows target                    | 60       |
| `TARGET-LIN-01` | Linux target (LAMP)               | 60       |

---

## 🌉 Bridge Access Design

- **Parrot Host ↔ BRIDGE-01 (Host-only):** `192.168.56.10`
- **BRIDGE-01 ↔ Lab VLAN 90:** `10.10.90.10`
- **OPNsense Gateway (VLAN 90):** `10.10.90.1`

#### 💻 Access Methods from Host
- SSH jump:  
  ```bash
  ssh -i ~/.ssh/lab user@192.168.56.10
````

* SOCKS Proxy:

  ```bash
  ssh -D 1080 -N user@192.168.56.10
  ```

* Local Port Forward:

  ```bash
  ssh -L 8080:10.10.40.10:80 user@192.168.56.10
  ```

---

## 🔒 Security Policy Highlights

* Default deny on all inter-VLAN routing
* Only specific flows allowed (e.g., Admin → AD, Jenkins → Git)
* All logs forward to `LOG/MON` VLAN
* VLAN 90 access restricted to BRIDGE-01 only
* Secrets tracked in `secrets/` (never committed)

---

## 🔗 Related Files

* `docs/rebuild-plan.md` – Build phases + checklists
* `secrets/lab.md` – IPs, credentials (excluded via `.gitignore`)
* `docs/opnsense-checklist.md` – Firewall setup notes

