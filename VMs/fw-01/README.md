# 🔥 FW-01 – OPNsense Firewall & Gateway

---

## 🔧 Purpose

`FW-01` is the **core firewall and router** for the lab.  
It enforces **default deny** inter-VLAN rules, provides **DHCP/DNS/NTP**, and hosts **Suricata IDS/IPS** for monitoring.

---

## 🛠️ Specs

| Setting     | Value                                |
|-------------|--------------------------------------|
| OS          | OPNsense (latest stable ISO)         |
| Hostname    | `fw-01`                              |
| VBox NIC 1  | NAT (temporary for updates/packages) |
| VBox NIC 2  | Internal Network (MGMT – VLAN 10)    |
| VBox NIC 3  | Internal Network (CORP – VLAN 20)    |
| VBox NIC 4  | Internal Network (DEV – VLAN 30)     |
| VBox NIC 5  | Internal Network (DMZ – VLAN 40)     |
| VBox NIC 6  | Internal Network (LOG – VLAN 50)     |
| VBox NIC 7  | Internal Network (BRIDGE – VLAN 90)  |
| VBox NIC 8  | (Optional) VPN VLAN 99               |
| Gateway IPs | `10.10.X.1` per VLAN                 |

---

## 📥 Install Checklist

### 🔸 Phase 1: Base Install

- [ ] Boot from OPNsense ISO
- [ ] Accept defaults for disk install (UEFI if possible)
- [ ] Set root password
- [ ] Assign interfaces in order:
  - WAN → NAT adapter (temporary)
  - LANs → VLAN adapters (em0–em6)
- [ ] Verify interface mapping

### 🔸 Phase 2: Core Configuration

- [ ] Set hostname: `fw-01`
- [ ] Configure IPs:
  - `10.10.10.1/24` (MGMT)
  - `10.10.20.1/24` (CORP)
  - `10.10.30.1/24` (DEV)
  - `10.10.40.1/24` (DMZ)
  - `10.10.50.1/24` (LOG/MON)
  - `10.10.90.1/24` (BRIDGE)
- [ ] Enable DHCP scopes per VLAN:
  - MGMT: `.100–.150`
  - CORP: `.50–.150`
  - DEV: `.50–.150`
  - DMZ: `.50–.100`
  - LOG: `.50–.60`
  - BRIDGE: `.50–.60`
- [ ] Configure DNS forwarder → AD-DC + external
- [ ] Enable NTP → pool.ntp.org

### 🔸 Phase 3: Security

- [ ] Change default admin password
- [ ] Disable WAN access to web UI
- [ ] Enable SSH (key only, mgmt VLAN only)
- [ ] Install and enable Suricata IDS
- [ ] Enable syslog forwarding → `10.10.50.x` (SIEM-01)
- [ ] Default deny inter-VLAN; add rules:
  - CORP → DMZ (HTTPS)
  - DEV ↔ Git/Artifact
  - BRIDGE-01 only → specific targets

---

## 🔐 Hardening

- [ ] Enable automatic updates (manual approval preferred)
- [ ] Restrict admin GUI to MGMT VLAN
- [ ] Configure 2FA for web UI
- [ ] Block bogon networks, private ranges on WAN
- [ ] Backup config to secrets/ (encrypted)

---

## 🌉 Access

- **Web UI**: https://10.10.10.1 (from Admin-WS)  
- **SSH**: `ssh admin@10.10.10.1` (mgmt VLAN only, key auth)

---

## 🧪 Post-Setup Validation

- [ ] Ping across VLANs (only as allowed by policy)
- [ ] DHCP leases issued correctly
- [ ] DNS resolves through AD-DC forwarder
- [ ] Syslog visible in SIEM
- [ ] Suricata alerts test traffic
- [ ] Default deny confirmed between VLANs
- [ ] Admin GUI restricted to MGMT
- [ ] Backup config saved in secrets/


