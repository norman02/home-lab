# OPNsense – Overview & Runbook

> High‑level reference for our edge firewall/router. Pair with `opnsense-build.md` for step‑by‑step configuration.

## 📦 Role
- Perimeter firewall, router, DHCP/DNS, VPN, IDS/IPS, and traffic shaping for the Home IT Lab.

## 🗺️ Topology
- **WAN**: DHCP from ISP (bridge mode if supported)
- **LAN**: 192.168.10.0/24 (gateway 192.168.10.1)
- **MGMT**: 192.168.99.0/24 (gateway 192.168.99.1)  ← Admin‑WS lives here
- **LAB VLANs (planned)**
  - VLAN 20 – Servers (192.168.20.0/24)
  - VLAN 30 – Clients (192.168.30.0/24)
  - VLAN 40 – Attacker/CTF (192.168.40.0/24)

> **FIXME:** Replace interface names (e.g., `ix0/ix1/ix2`), actual VLAN tags, and switch ports.

## 🔐 Access
- Web UI: `https://opnsense.mgmt.local` (self‑signed or internal CA)
- SSH: disabled by default (enable only during maintenance)
- Admin user: `opn_admin` (key‑auth only; no password auth)

> **Secrets live in vault/password manager; never in repo.**

## 🧩 Core Services
- **DHCPv4**: LAN + VLANs; reservations for infra nodes
- **DNS Resolver (Unbound)**: host overrides + split‑horizon
- **NAT**: automatic outbound for RFC1918; explicit port‑forwards documented in build guide
- **VPN**: WireGuard for remote Admin‑WS access
- **IDS/IPS**: Suricata in IPS mode on WAN (ET Open + abuse.ch; tuned)

## ✅ Policy (Golden Rules)
1. Default‑deny inbound; allow egress by policy.
2. Inter‑VLAN is deny by default; allow via tight rules (FQDN/ports).
3. Admin‑WS can reach infra (SSH/HTTPS) but not client VLANs except break‑glass.
4. Management only over TLS/SSH key‑auth.

## 🔄 Change Control
- Track config backups (`System ▸ Configuration ▸ Backups`) and store encrypted off‑box.
- Document meaningful changes in PRs referencing this doc.

## 🧯 Break‑Glass
- Console (VGA/serial) available.
- If needed: factory reset → restore last known‑good config from encrypted backup.

## 🧪 Post‑Change Smoke Tests
- WAN up? (`Interfaces ▸ Overview`)
- DHCP leases issuing on LAN/VLANs?
- DNS resolution from Admin‑WS (`dig a example.com @192.168.10.1`)
- VLAN separation enforced?
- VPN up and routes to MGMT?

## 🛠️ Troubleshooting Pointers
- DNS: `Services ▸ Unbound DNS ▸ Log File`
- VPN: `VPN ▸ WireGuard ▸ Status`
- Firewall: `Firewall ▸ Log Files ▸ Live View` (filter src/dst)
- Packet capture: `Interfaces ▸ Diagnostics ▸ Packet Capture`

## 📎 References
- OPNsense docs (stable), Suricata tuning notes (local), WireGuard keys (vault item).
