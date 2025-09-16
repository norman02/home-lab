
# 🖥️ BRIDGE-01 – Lab Jump Host (Arch Linux)


---

## 🔧 Purpose

`BRIDGE-01` acts as the **only entry point** from the Parrot OS host into the isolated virtual lab.  
It functions as a jump host, proxy relay (SOCKS), and staging point for internal access.

---

## 🛠️ Specs

| Setting     | Value                          |
|-------------|---------------------------------|
| OS          | Arch Linux (2025 ISO)          |
| Hostname    | `bridge-01`                    |
| User        | `labadmin` (non-root)          |
| VBox NIC 1  | Host-only Adapter (`vboxnet0`) |
| VBox NIC 2  | Internal Network: `BRIDGE`     |
| IP 1        | `192.168.56.10` (host-only)     |
| IP 2        | `10.10.90.10` (VLAN 90)        |
| Gateway     | `10.10.90.1` (FW-OPNsense)     |

---

## 📥 Install Checklist

### 🔸 Phase 1: Base Arch Install

- [ ] Boot from latest Arch ISO (UEFI or BIOS mode)
- [ ] Partition disk with ext4 + swap
- [ ] Format and mount `/mnt`
- [ ] `pacstrap` base + base-devel
- [ ] Install and configure GRUB
- [ ] Set timezone, locale, hostname (`bridge-01`)
- [ ] Create user `labadmin`, add to wheel
- [ ] Enable sudo with `sudoedit /etc/sudoers`
- [ ] Enable `sshd` service

### 🔸 Phase 2: Network Configuration

- [ ] NIC 1 → `vboxnet0` (host-only)
  - Static IP: `192.168.56.10/24`
- [ ] NIC 2 → `Internal Network: BRIDGE`
  - Static IP: `10.10.90.10/24`
  - Gateway: `10.10.90.1`
- [ ] No DHCP, manual config using `systemd-networkd`
- [ ] Set `/etc/hosts` entries for:
  - `bridge-01`
  - `fw-opnsense.lab.local` → `10.10.90.1`

---

## 🔐 Hardening & Access

### 🔑 SSH Configuration

- [ ] Disable root login  
- [ ] Use **SSH key only** authentication  
- [ ] Set `PermitRootLogin no`, `PasswordAuthentication no`  
- [ ] Create key pair: `~/.ssh/lab_ed25519`  
- [ ] Install public key for `labadmin`

### 🔒 Firewall (nftables or UFW)

- [ ] Default deny all  
- [ ] Allow:
  - Host-only SSH: `192.168.56.0/24` → `22`
  - Optional internal SSH to lab

### 🔒 Additional Security

- [ ] Install & configure `fail2ban`  
- [ ] Disable IPv6 (optional)  
- [ ] Disable `IP_FORWARD` (no routing!)  
- [ ] Install `htop`, `ufw`, `nmap`, `vim`, `man-db`

---

## 🌉 Access from Host

Once configured, access the lab via:

### 🔹 SSH Jump:

```bash
ssh -i ~/.ssh/lab_ed25519 labadmin@192.168.56.10
````

### 🔹 SOCKS Proxy:

```bash
ssh -D 1080 -N -i ~/.ssh/lab_ed25519 labadmin@192.168.56.10
```

### 🔹 Port Forward (e.g., Jenkins)

```bash
ssh -L 8080:10.10.40.10:8080 labadmin@192.168.56.10
```

---

## 🧪 Post-Setup Validation

* [ ] Can SSH from host → `192.168.56.10`
* [ ] Can ping → `10.10.90.1` (FW-OPNsense)
* [ ] Can resolve `lab.local` once DNS configured
* [ ] Firewall rules verified
* [ ] Encrypted backup of SSH keys stored in `secrets/`



