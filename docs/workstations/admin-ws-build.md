# Admin-WS – Build & Baseline

> Opinionated, repeatable setup for the lab’s admin workstation.  
> Priorities: security, reliability, terminal-first ops, and **no secrets in git**.

---

## 🧾 Host Summary
- OS: Parrot OS (rolling)  
- Hostname: `admin-ws`  
- Network: **MGMT** VLAN `192.168.99.0/24` (static or DHCP reservation)  
- Accounts: primary user `john` (sudo); root login disabled over SSH  
- Remote access: WireGuard to MGMT only

> **FIXME:** Record the actual MGMT IP/MAC and DHCP reservation ID.

---

## 1) Fresh Install & System Basics
- Install Parrot OS → full-disk encryption recommended.
- Set timezone, NTP, and hostname.
- Enable auto-security updates.

```bash
sudo apt update && sudo apt -y full-upgrade
sudo apt -y install \
  git vim neovim tmux zsh curl wget unzip jq htop tree \
  openssh-client wireguard openvpn \
  python3 python3-pip python3-venv \
  ansible nmap netcat-traditional socat \
  wireshark tcpdump traceroute whois \
  feroxbuster gobuster wfuzz seclists \
  keepassxc pass gnupg2 age \
  virt-manager qemu-system-x86 remmina \
  make build-essential ripgrep fd-find bat fzf
````

Optional desktop utilities: `gnome-disk-utility`, `flameshot`.

---

## 2) Shell, Editor, and Tmux Quality-of-Life

```bash
chsh -s /bin/zsh "$USER"

# Vim/Neovim minimal defaults (idempotent)
mkdir -p ~/.config/nvim
cat > ~/.vimrc <<'VIM'
set number relativenumber cursorline
set tabstop=2 shiftwidth=2 expandtab
set ignorecase smartcase
set clipboard=unnamedplus
syntax on
VIM
ln -sf ~/.vimrc ~/.config/nvim/init.vim

# Tmux sane defaults
cat > ~/.tmux.conf <<'TMUX'
set -g mouse on
set -g history-limit 20000
setw -g mode-keys vi
TMUX
```

---

## 3) SSH & GPG/Pass (no passwords in plain text)

**SSH**

```bash
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519 -C "admin-ws"
printf "Host *\n  AddKeysToAgent yes\n  IdentityFile ~/.ssh/id_ed25519\n" >> ~/.ssh/config
chmod 700 ~/.ssh && chmod 600 ~/.ssh/*
```

**GPG + pass**

```bash
# Create a primary key (adjust name/email)
gpg --quick-generate-key "John Admin <admin@example.local>" default default never
KEYID=$(gpg --list-secret-keys --keyid-format LONG | awk '/sec/{print $2}' | sed -n '1s|.*/||p')
pass init "$KEYID"
```

> Store service passwords, API tokens, and **WireGuard private keys** in KeePassXC or `pass`.
> Back up the KeePass DB and GPG private key offline.

---

## 4) Local Host Firewall (UFW)

```bash
sudo apt -y install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
# Allow SSH only from MGMT
sudo ufw allow from 192.168.99.0/24 to any port 22 proto tcp
sudo ufw enable
sudo ufw status verbose
```

---

## 5) Network & Name Resolution

* Prefer **DHCP reservation** on MGMT; otherwise static:

```bash
# Example Netplan (if using netplan). Replace IFACE/IP details.
# /etc/netplan/01-mgmt.yaml
network:
  version: 2
  ethernets:
    IFACE0:
      addresses: [192.168.99.10/24]
      routes: [{ to: default, via: 192.168.99.1 }]
      nameservers: { addresses: [192.168.99.1] }
```

Apply with `sudo netplan apply`.

Optional `/etc/hosts` short names for infra (jump host, opnsense, etc.).

---

## 6) WireGuard (Remote Admin)

```bash
umask 077
wg genkey | tee ~/wg-admin.key | wg pubkey > ~/wg-admin.pub
# Store ~/wg-admin.key in pass/KeePassXC (NOT in git)

# Client config (example): /etc/wireguard/wg-mgmt.conf
[Interface]
PrivateKey = <contents of ~/wg-admin.key>
Address = 10.99.0.2/32
DNS = 192.168.99.1

[Peer]
PublicKey = <OPNsense-WG-PublicKey>
Endpoint = <WAN_IP>:51820
AllowedIPs = 192.168.99.0/24
PersistentKeepalive = 25

sudo wg-quick up wg-mgmt
sudo systemctl enable wg-quick@wg-mgmt
```

> **FIXME:** fill actual keys and OPNsense public key (keep private in vault).

---

## 7) Tooling Profiles (CTF + Admin)

* Recon: `nmap`, `feroxbuster`, `gobuster`, `wfuzz`, `seclists`
* Net/packets: `tcpdump`, `wireshark` (add user to `wireshark` group)
* Infra: `ansible`, `virt-manager`, `remmina`
* Developer QoL: `ripgrep`, `fd`, `bat`, `fzf`

**Wireshark permissions**

```bash
sudo dpkg-reconfigure wireshark-common   # allow non-root captures
sudo usermod -aG wireshark "$USER"
newgrp wireshark
```

---

## 8) Ansible (optional but recommended)

Repo path: `~/home-lab/automation/ansible/`

* `inventory.yml` (MGMT IPs)
* `group_vars/` for non-secret vars
* Roles:

  * `roles/workstation_bootstrap` (install pkgs, dotfiles)
  * `roles/opnsense_readonly` (API GETs only for config snapshots)

> Keep secrets in Ansible Vault or `pass`; never commit raw credentials.

---

## 9) Git Hygiene on Admin-WS

Global config tweaks:

```bash
git config --global pull.ff only
git config --global init.defaultBranch main
git config --global commit.gpgsign true   # if using signed commits
git config --global user.signingkey "$KEYID"
```

Helpful aliases (optional):

```ini
# ~/.gitconfig snippet
[alias]
  st = status -sb
  co = checkout
  cb = checkout -b
  fp = fetch --prune
  lol = log --oneline --graph --decorate --all
  amend = commit --amend --no-edit
  wip = commit -m "chore: wip"
  fixup = commit --fixup
  squash = rebase -i --autosquash
```

---

## 10) Backups & Key Escrow

* KeePassXC DB exported to **encrypted** external storage (periodic).
* GPG private key + revocation cert stored offline.
* Timeshift/rsync snapshot to NAS on MGMT only.

---

## 11) Security Notes

* Browser: separate profiles for admin vs. general browsing.
* Disable USB autorun; keep full-disk encryption.
* Review `~/.ssh/known_hosts` periodically.

---

## 12) Smoke Tests

* Access OPNsense GUI from Admin-WS.
* `ssh` to infra nodes on MGMT (as-needed).
* Run an `nmap -sn 192.168.99.0/24` to validate reachability.
* Bring up WireGuard and verify route to MGMT only.
* Capture a quick `tcpdump -i <iface> host 192.168.99.1` (permissions OK).

---

## 13) Change Log

* 2025-08-15 – Baseline created – PR #TBD
  MD
