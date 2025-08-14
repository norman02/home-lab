# 🛰️ Bridge Node – Internal Routing & Utility VM

> Part of the `home-lab` virtual network  
> Role: lightweight Linux node bridging networks and providing essential utility functions.

---

## 📌 Purpose

- Bridges internal network segments (LAN, DMZ, WRK)
- Runs simple routing, firewalling, and test scripts
- Ideal for scripting, traffic simulation, and diagnostics

---

## 🛠️ Base Configuration

| Setting         | Value                          |
|----------------|----------------------------------|
| OS             | Arch Linux (minimal install)    |
| Hostname       | `bridge-node`                   |
| Interfaces     | `enp0s3` (mgmt), `enp0s8` (LAN), `enp0s9` (DMZ) |
| Shell          | `zsh` with plugins              |
| Services       | `openssh`, `iptables`, `systemd-networkd` |
| User Accounts  | `john` (admin), `bridge` (limited) |

---

## 🧱 Network Role

- NAT, packet inspection, routing
- Interface mapping controlled by `systemd-networkd`
- Optionally acts as:
  - testbed
  - access point
  - DNS cache or NTP proxy

---

## 🔐 Credentials

Stored securely in `config/bridge-node.creds` (not tracked by git)

---

## 📁 Notable Paths

| Path                           | Description                  |
|--------------------------------|------------------------------|
| `/etc/systemd/network/`       | Static IP configs            |
| `/etc/iptables/rules.v4`      | Firewall rules               |
| `/opt/scripts/`               | Custom utility scripts       |
| `/home/bridge/`               | Automation user shell config |

---

## 🧪 TODO

- [ ] Add DNS cache or proxy
- [ ] Install `fail2ban`
- [ ] Add `vnstat` or `bmon` for bandwidth monitoring
- [ ] Optionally bridge into host-only LAN for VM-to-real-network testing

---

## 📝 Notes

- No GUI or unused services installed
- SSH access configured
- Will likely expand to include diagnostics and health checks

