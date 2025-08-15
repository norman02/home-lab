# Network Topology – Home IT Lab

> **Current state** (flat LAN): ParrotOS (physical) → bridge‑node (L2) → OPNsense → LAN (10.0.1.0/24).  
> **On LAN:** Admin‑WS (`10.0.1.30`), osTicket (`10.0.1.20`).  
> Related: [`opnsense-overview.md`](./opnsense-overview.md) · [`opnsense-build.md`](./opnsense-build.md) · [`bridge-node.md`](./bridge-node.md)

---

## 🗺️ High‑Level Diagram (Current)


```
            (Internet)
                │
      ParrotOS (physical host)
                │
      ┌──────── bridge-node ───────┐
      │  NIC1: Bridged (DHCP)      │  ← outside/host network
      │  NIC2: Host-Only vboxnet0  │  ← lab transit to OPNsense WAN
      └───────────┬────────────────┘
                  │  (OPNsense WAN on vboxnet0 side)
            ┌─────┴─────┐
            │  OPNsense  │  FW/Router
            └─────┬──────┘
                  │  (LAN 10.0.1.0/24, GW 10.0.1.1)
     ┌────────────┴────────────┐
     │                         │
  Admin-WS                 osTicket
  10.0.1.30                10.0.1.20
     │                         │
     └────── other LAN nodes (ELK, Win10 target, etc.)


```

---

## 🧭 Segments & Addressing (Current)

| Segment  | Purpose                              | GW / Interface IP | Notes |
|---------:|--------------------------------------|-------------------|------|
| TRANSIT  | ParrotOS ↔ bridge‑node ↔ OPNsense WAN | **FIXME**         | L2 via `vboxnet0`; WAN gets IP via bridge‑node side |
| LAN      | Flat lab network (all nodes)          | `10.0.1.1/24`     | OPNsense LAN; DHCP or static reservations |

**Known LAN assignments**
- **OPNsense (LAN):** `10.0.1.1`  
- **Admin‑WS:** `10.0.1.30`  
- **osTicket:** `10.0.1.20`  
- **bridge‑node host‑only (example):** `10.0.1.5` *(adjust if different)*

> Keep DHCP leases/reservations in OPNsense; document MAC/IP/hostnames in the repo’s inventory.

---

## 🔑 Key Nodes (Current)

| Node          | Segment | Address         | Role/Notes |
|---------------|---------|-----------------|------------|
| OPNsense FW   | LAN     | `10.0.1.1`      | Router/Firewall, DHCP/DNS (Unbound) |
| Admin‑WS      | LAN     | `10.0.1.30`     | Ops box (SSH/Ansible/Remmina/WG) |
| osTicket      | LAN     | `10.0.1.20`     | Help desk server |
| bridge‑node   | TRANSIT | **FIXME**       | L2 bridge between ParrotOS and OPNsense WAN (VirtualBox: Bridged + Host‑Only) |

---

## 🔐 Policy Snapshot (Current)

- Inbound from Internet: **default‑deny** on OPNsense.
- Flat LAN (no VLANs yet): Admin‑WS reaches lab nodes as needed.
- DNS: clients resolve via **OPNsense Unbound** (`10.0.1.1`).
- VPN/IDS/IPS: optional for current bring‑up (enable later).

---

## 🧭 Planned Segmentation (Next Phase)

To mirror your firewall rules draft:

| Segment | CIDR          | Purpose         |
|--------:|---------------|-----------------|
| LAN     | `10.0.1.0/24` | Infra/Admin     |
| DMZ     | `10.0.2.0/24` | Internet‑facing |
| WKSTN   | `10.0.3.0/24` | User endpoints  |

**Admin‑WS policy sketch**
- From `10.0.1.30` → DMZ (`10.0.2.0/24`): allow `22, 3389`, ICMP; block else.
- From `10.0.1.30` → WKSTN (`10.0.3.0/24`): allow `22, 3389`, ICMP; block else.
- From DMZ → `10.0.1.30`: block.
- From LAN → `10.0.1.30`: allow `22`, ICMP; block else.

> Implement after creating VLANs/NIC mapping in OPNsense; reference aliases for destinations to keep rules readable.

---

## 🧪 Smoke Tests

1. **LAN reachability:** `ping 10.0.1.1` from Admin‑WS; browser `https://10.0.1.1`.
2. **DNS:** `dig a example.com @10.0.1.1` from Admin‑WS and osTicket.
3. **Egress:** `curl -I https://example.com` from LAN hosts.
4. **Bridge path:** `tcpdump -i <bridge-node host-only NIC>` to confirm packets between LAN and OPNsense WAN.
5. **(When segmented)** verify Admin‑WS access rules to DMZ/WKSTN and blocks in reverse.

---

## 📝 Change Log
- 2025‑08‑15 – Corrected to: ParrotOS → bridge‑node → OPNsense → LAN; Admin‑WS & osTicket on LAN. Added planned segmentation. – PR #TBD
MD
