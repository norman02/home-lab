# 🛠️ Home Cyber Lab – Rebuild Plan (v2)

## 📌 Context
- **Notebook:** Projects → Home Cyber Lab  
- **Type:** Infrastructure Plan  
- **Status:** In Progress  
- **Tags:** `home-lab` `rebuild` `vm-setup` `networking` `virtualbox` `bridge-node` `opnsense` `ad-dc`

---

## 🧱 Phase 0 – Prerequisites & Cleanup

- [x] Delete all broken or misconfigured VMs  
- [x] Clear out unused snapshots, stale configs  
- [x] Back up current lab files (e.g., `secrets/`, `*.md`)  
- [x] Confirm VirtualBox networking is clean:
  - [x] Host-only: `vboxnet0` → `192.168.56.0/24`
  - [x] Internal Networks created: `LAN`, `DMZ`, `MON`, `DEV`, `CORP`, `BRIDGE`
- [x] Confirm required ISOs available:
  - [x] Windows Server 2022 (GUI)
  - [x] Ubuntu (Admin WS)
  - [x] Arch Linux ISO (Bridge)
  - [x] Parrot OS (Host)
  - [x] Others: Metasploitable, DVWA, etc.

---

## 🔌 Phase 1 – Bridge & Networking Foundation

### 🖥️ `BRIDGE-01` (Arch Linux)

- [ ] VM: Arch Linux
- [ ] Network:
  - NIC1: Host-only (vboxnet0) – `192.168.56.10`
  - NIC2: Internal Network: `BRIDGE` – `10.10.90.10`
- [ ] Packages:
  - [ ] `openssh`, `iptables`, `nftables`, `fail2ban`
- [ ] Hardening:
  - [ ] Disable root login
  - [ ] SSH key only
  - [ ] UFW or nftables default deny
- [ ] Manual IP config:
  - [ ] Use `/etc/systemd/network/` or `ip addr add` for now
- [ ] Confirm:
  - [ ] SSH from host to 192.168.56.10
  - [ ] Can ping `10.10.90.1` (FW-01)

---

## 🔥 Phase 2 – Firewall & VLAN Routing

### 🔥 `FW-OPNsense`

- [ ] VM: OPNsense
- [ ] Network:
  - NIC1: BRIDGE (WAN) – `10.10.90.1`
  - NIC2: LAN (MGMT) – `10.10.10.1`
  - NIC3: DMZ – `10.10.40.1`
- [ ] Configure Interfaces + VLANs
- [ ] Set static IPs, disable DHCP (except optional test scopes)
- [ ] Add inter-VLAN routing rules:
  - [ ] Allow MGMT ↔ BRIDGE
  - [ ] Deny all else by default
- [ ] Confirm:
  - [ ] Ping FW from BRIDGE-01 (→ `10.10.90.1`)
  - [ ] Ping BRIDGE from FW (→ `10.10.90.10`)

---

## 🧱 Phase 3 – Core Infrastructure

### 🧱 `AD-DC-01` (Windows Server 2022)

- [ ] Install Windows Server 2022 (GUI)
- [ ] Network: Internal Network `LAN` → `10.10.10.10`
- [ ] Set static IP, gateway `10.10.10.1`, DNS `127.0.0.1`
- [ ] Promote to Domain Controller:
  - Domain: `lab.local`
  - NetBIOS: `LAB`
- [ ] Roles:
  - [ ] Active Directory Domain Services
  - [ ] DNS
- [ ] Confirm:
  - [ ] Hostname: `AD-DC-01`
  - [ ] Ping from FW-01 and BRIDGE via VLAN routing

### 🖥️ `ADMIN-WS-01` (Ubuntu) + `ADMIN-WS-02` (Windows)

- [ ] Ubuntu:
  - IP: `10.10.10.20`
  - Join `LAN` VLAN
- [ ] Windows:
  - IP: `10.10.10.21`
  - Join domain `lab.local`
  - Confirm GPO, RDP, RSAT install

---

## 🧪 Phase 4 – DMZ & DEV Stack

### 🌐 DMZ Services (VLAN 40)

- [ ] `GIT-01` (Gitea or GitLab)
- [ ] `CI-01` (Jenkins)
- [ ] `ARTIFACT-01` (Harbor or Nexus)
- [ ] `WIKI-01` (DokuWiki)
- [ ] `TICKETS-01` (osTicket)

### 🛠 DEV Workstations (VLAN 30)

- [ ] `DEV-WS-01` (Linux or Windows)

---

## 🎯 Phase 5 – Targets & Monitoring

- [ ] `TARGET-WIN-01` – Windows 10/11 (vuln)
- [ ] `TARGET-LIN-01` – DVWA / LAMP
- [ ] `SIEM-01` – Wazuh or ELK
- [ ] `SURICATA-01` – IDS optional

---

## 🔐 Phase 6 – Security & Hardening

- [ ] Apply firewall rules (allowlists)
- [ ] Confirm VLAN segmentation
- [ ] Confirm DNS/hostname resolution
- [ ] Snapshots for:
  - Clean states
  - Post-domain join
  - Post-tool install

---

## 🔗 Related Notes

- `docs/topology.md` → VLAN & service diagram  
- `secrets/lab.md` → Static IPs, creds, tokens (gitignored)  
- `docs/opnsense-checklist.md` → Firewall config  

