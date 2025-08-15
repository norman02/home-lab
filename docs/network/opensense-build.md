# OPNsense – Build & Configuration Guide

> Hands‑on steps to install and configure OPNsense for the Home IT Lab.  
> Pair with `opnsense-overview.md` for topology and policy.

---

## 0) Prep
- **Download:** OPNsense AMD64 (VGA) ISO from official site; verify SHA256.
- **Create media:** `dd`/Rufus/Ventoy.
- **Plan addressing:** See overview for LAN/MGMT/VLANs.
- **Have ready:** switch port map, ISP modem/ONT info.

> **FIXME:** Record ISO version and SHA: `OPNsense x.y.z – sha256: <...>`

---

## 1) Install
1. Boot installer → login `installer` (password `opnsense`) → launch guided install.
2. **Filesystem:** ZFS (single‑disk) or UFS (simple).
3. Create admin user `opn_admin`; disable root SSH.
4. Set hostname `opnsense`, timezone, NTP pool.
5. Reboot, remove install media.

---

## 2) Interface Assignment
From console menu: **Assign interfaces**.
- **WAN** → `ix0` (DHCP)  
- **LAN** → `ix1` (static `192.168.10.1/24`)  
- **MGMT** → `ix2` (static `192.168.99.1/24`)

> **FIXME:** Replace `ix0/ix1/ix2` with real NICs.

Confirm LAN access: connect laptop → `https://192.168.10.1` (self‑signed cert).

---

## 3) Base Hardening
- **System ▸ Settings ▸ Administration**
  - Protocol: HTTPS only (modern TLS)
  - **SSH:** disabled by default; if enabled → MGMT net only, key‑auth only
  - Idle timeout: 10–15 min
- **System ▸ Trust ▸ Authorities**
  - Import internal CA; issue firewall cert; set as GUI cert.
- **System ▸ Firmware**
  - Update to latest stable; reboot if required.

---

## 4) VLANs & Interface Setup
- **Interfaces ▸ Other Types ▸ VLAN**
  - Add trunk VLANs on the LAN uplink (e.g., `ix1`):
    - VLAN **20** (Servers), **30** (Clients), **40** (CTF)
- **Interfaces ▸ Assignments**
  - Add OPT interfaces for each VLAN, then enable:
    - `VLAN20` → `192.168.20.1/24`
    - `VLAN30` → `192.168.30.1/24`
    - `VLAN40` → `192.168.40.1/24`

> **FIXME:** Confirm actual VLAN tags and trunk port on the switch.

---

## 5) DHCPv4
- **Services ▸ DHCPv4** (per interface)
  - **LAN:** pool `192.168.10.100–192.168.10.200`
  - **MGMT:** **reservations only** (or tiny pool)
  - **VLAN20:** narrow pool (servers mostly static/reserved)
  - **VLAN30/40:** pools sized to expected clients
  - Register DHCP leases in DNS (for Unbound)

Add **static mappings** for infra nodes (MAC/IP/hostname notes in repo).

---

## 6) DNS Resolver (Unbound)
- **Services ▸ Unbound DNS**
  - Enable; DNSSEC on
  - Register DHCP leases; static host overrides for core services
  - (Optional) **Conditional forwarding** for any lab AD domain

> Consider blocking outbound 53/853/DoH from clients to the Internet; force internal resolver.

---

## 7) Outbound NAT
- **Firewall ▸ NAT ▸ Outbound**
  - Mode: **Hybrid** (start from automatic, add explicit rules as needed)
  - Ensure RFC1918 nets egress via WAN; add per‑VLAN overrides if using multiple WANs.

---

## 8) Firewall Policy (examples)
**WAN**
- Default deny inbound; allow established/related.

**LAN/VLANs**
- Default allow egress 80/443 via internal DNS only; deny inter‑VLAN by default.
- Create **aliases** (FQDN/IP lists) for destinations; reference in rules.

**MGMT**
- Allow to infra mgmt ports (22/443/853) and resolver only.

Example: allow `VLAN30` → GitHub (443) only:
```

Src: VLAN30 net
Dst: Alias: GITHUB\_FQDNS
Port: 443/TCP
Action: Pass
Description: Dev clients → GitHub

```

Log first, then tune.

---

## 9) VPN (WireGuard)
- **VPN ▸ WireGuard**
  - Add **Local**: UDP 51820 on WAN; Address: `10.99.0.1/24`
  - Peers: Admin‑WS, phone (assign `10.99.0.2/32`, `10.99.0.3/32`)
- **Firewall rules**
  - WAN: allow UDP 51820
  - WG interface: allow to **MGMT** subnet
- **Routing**
  - Add allowed‑IPs to include `192.168.99.0/24` (MGMT)

> **FIXME:** Store private keys in your password vault, not the repo.

---

## 10) IDS/IPS (Suricata)
- **Services ▸ Intrusion Detection**
  - Interfaces: WAN (optionally LAN/VLANs later)
  - Enable **IPS mode**
  - Rule sets: **ET Open**, **abuse.ch**; auto‑update daily
  - Suppress noisy FPs; maintain **suppress list** (no secrets) in repo as text

---

## 11) Port‑Forwards (if any)
Document each forward with **justification** and **review date**:
```

Service: HTTPS to reverse proxy
Src: WAN:443 → Dst: 192.168.20.10:443 (VLAN20)
Why: External docs demo
Risk: Exposed surface; WAF/Fail2Ban in front
Review by: 2025‑10‑01

```

---

## 12) Backups & Config History
- **System ▸ Configuration ▸ Backups**
  - Enable remote/automatic backups (Nextcloud/WebDAV/S3)
  - **Encrypt** with strong passphrase (store in vault)
- Export manual backup after major changes; label with date & PR #.

---

## 13) Monitoring & Health
- **System ▸ Health** (CPU/mem/net)
- **Firewall ▸ Logs ▸ Live View**
- **Services ▸ Unbound/Suricata ▸ Logs**
- (Optional) Netflow/Insight for traffic analysis.

---

## 14) Post‑Build Smoke Tests
- Internet reachability from each VLAN (ICMP + HTTP)
- DNS works via firewall resolver; external DNS blocked
- Inter‑VLAN isolation holds
- VPN connects; routes to MGMT only
- IDS/IPS catching basic test signatures

---

## 15) Change Log
- 2025‑08‑15 – Initial baseline build – PR #TBD
- **Future:** record policy/rule changes here with rationale.

