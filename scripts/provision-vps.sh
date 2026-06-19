#!/usr/bin/env bash
#
# provision-vps.sh — Provisionamento inicial de VPS para RustDesk Server
#
# Uso:
#   curl -sS https://raw.githubusercontent.com/.../provision-vps.sh | sudo bash
#   ou
#   scp provision-vps.sh root@<IP>:/root/ && ssh root@<IP> ./provision-vps.sh
#
# Este script:
#   1. Atualiza o sistema
#   2. Cria usuário não-root
#   3. Configura SSH hardening
#   4. Instala Docker
#   5. Configura UFW
#   6. Configura swap (se RAM <= 2 GB)
#   7. Instala fail2ban e unattended-upgrades
#   8. Inicia containers RustDesk
#   9. Exibe resumo com chave pública
#
# Requer: Ubuntu 22.04/24.04 LTS ou Debian 12, executado como root.
# ---------------------------------------------------------------------------

set -euo pipefail

# ─── Cores ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err()  { echo -e "${RED}[✗]${NC} $*"; exit 1; }
info() { echo -e "${CYAN}[i]${NC} $*"; }

# ─── Verificações iniciais ──────────────────────────────────────────────────
[[ $EUID -eq 0 ]] || err "Execute como root (sudo)."

if [[ -f /etc/os-release ]]; then
  . /etc/os-release
  case "$ID" in
    ubuntu|debian) ;;
    *) err "Distribuição não suportada: $ID. Use Ubuntu ou Debian." ;;
  esac
else
  err "Não foi possível identificar o sistema operacional."
fi

# ─── Configurações ──────────────────────────────────────────────────────────
RUSTDESK_USER="${RUSTDESK_USER:-rustdesk}"
RUSTDESK_DIR="${RUSTDESK_DIR:-/opt/rustdesk-server}"
SSH_PORT="${SSH_PORT:-22}"
TIMEZONE="${TIMEZONE:-America/Sao_Paulo}"

# ─── 1. Atualizar sistema ───────────────────────────────────────────────────
info "Atualizando pacotes do sistema..."
apt update && apt upgrade -y
apt autoremove -y
log "Sistema atualizado."

# ─── 2. Fuso horário ────────────────────────────────────────────────────────
timedatectl set-timezone "$TIMEZONE"
log "Fuso horário configurado: $TIMEZONE"

# ─── 3. Swap (se RAM <= 2 GB) ───────────────────────────────────────────────
total_ram_mb=$(awk '/MemTotal/ { printf "%d", $2/1024 }' /proc/meminfo)
if [[ $total_ram_mb -le 2048 ]]; then
  swap_size=2048
  if ! swapon --show | grep -q '/swapfile'; then
    info "RAM detectada: ${total_ram_mb} MB. Criando swap de ${swap_size} MB..."
    fallocate -l "${swap_size}M" /swapfile
    chmod 600 /swapfile
    mkswap /swapfile >/dev/null
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    log "Swap criado."
  else
    info "Swap já existe, ignorando."
  fi
else
  info "RAM suficiente (${total_ram_mb} MB), swap não necessário."
fi

# ─── 4. Usuário não-root ────────────────────────────────────────────────────
if id "$RUSTDESK_USER" &>/dev/null; then
  info "Usuário $RUSTDESK_USER já existe, ignorando."
else
  useradd -m -s /bin/bash -G sudo "$RUSTDESK_USER"
  passwd -l "$RUSTDESK_USER"  # sem login por senha
  log "Usuário $RUSTDESK_USER criado (login apenas por chave SSH)."
fi

# ─── 5. SSH hardening ───────────────────────────────────────────────────────
SSH_CFG="/etc/ssh/sshd_config"

# Apenas se houver chave pública no root ou no novo usuário
if [[ -f /root/.ssh/authorized_keys ]] || [[ -f /home/$RUSTDESK_USER/.ssh/authorized_keys ]]; then
  sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin prohibit-password/' "$SSH_CFG"
  sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$SSH_CFG"
  sed -i 's/^#\?ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' "$SSH_CFG"
  sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSH_CFG"
  log "SSH hardening aplicado (login apenas por chave)."
else
  warn "Nenhuma chave SSH pública encontrada. SSH hardening NÃO aplicado."
  warn "Adicione sua chave pública e execute novamente ou configure manualmente."
fi

systemctl restart sshd
log "SSH reiniciado."

# ─── 6. fail2ban ────────────────────────────────────────────────────────────
if ! command -v fail2ban-client &>/dev/null; then
  apt install -y fail2ban >/dev/null
  cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
EOF
  systemctl enable --now fail2ban
  log "fail2ban instalado e configurado."
else
  info "fail2ban já instalado."
fi

# ─── 7. unattended-upgrades ─────────────────────────────────────────────────
if ! dpkg -l unattended-upgrades &>/dev/null; then
  apt install -y unattended-upgrades >/dev/null
  dpkg-reconfigure -plow unattended-upgrades --frontend=noninteractive
  log "unattended-upgrades configurado."
else
  info "unattended-upgrades já instalado."
fi

# ─── 8. Docker ──────────────────────────────────────────────────────────────
if ! command -v docker &>/dev/null; then
  info "Instalando Docker..."
  curl -fsSL https://get.docker.com | bash >/dev/null
  systemctl enable --now docker
  log "Docker instalado."
else
  info "Docker já instalado."
fi

# ─── 9. UFW ─────────────────────────────────────────────────────────────────
ufw --force reset >/dev/null 2>&1 || true
ufw default deny incoming
ufw default allow outgoing

# SSH (manter porta personalizada)
if [[ "$SSH_PORT" != "22" ]]; then
  ufw allow "$SSH_PORT"/tcp comment 'SSH'
else
  ufw allow ssh comment 'SSH'
fi

# RustDesk
ufw allow 21115/tcp  comment 'RustDesk NAT type test'
ufw allow 21116/tcp  comment 'RustDesk TCP hole punching'
ufw allow 21116/udp  comment 'RustDesk ID registration / heartbeat'
ufw allow 21117/tcp  comment 'RustDesk relay'

ufw --force enable
log "UFW configurado."

# ─── 10. Diretório de dados ─────────────────────────────────────────────────
mkdir -p "$RUSTDESK_DIR"
chmod 755 "$RUSTDESK_DIR"

# ─── 11. Containers RustDesk ────────────────────────────────────────────────
info "Iniciando containers RustDesk..."

docker pull rustdesk/rustdesk-server-s6:latest >/dev/null

# Remove containers existentes se houver
docker rm -f hbbs hbbr 2>/dev/null || true

docker run -d --name hbbs \
  -v "$RUSTDESK_DIR:/data" \
  -p 21115:21115/tcp \
  -p 21116:21116/tcp \
  -p 21116:21116/udp \
  --restart unless-stopped \
  rustdesk/rustdesk-server-s6:latest hbbs 2>/dev/null

docker run -d --name hbbr \
  -v "$RUSTDESK_DIR:/data" \
  -p 21117:21117/tcp \
  --restart unless-stopped \
  rustdesk/rustdesk-server-s6:latest hbbr 2>/dev/null

log "Containers RustDesk iniciados."

# ─── 12. Aguardar chave pública ─────────────────────────────────────────────
info "Aguardando geração da chave pública..."
for i in {1..10}; do
  if [[ -f "$RUSTDESK_DIR/id_ed25519.pub" ]]; then
    break
  fi
  sleep 1
done

# ─── 13. Resumo final ──────────────────────────────────────────────────────
clear
echo ""
echo "=============================================="
echo "  ✅  PROVISIONAMENTO CONCLUÍDO"
echo "=============================================="
echo ""
echo "  IP do servidor:  $(curl -s ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}')"
echo "  Usuário:         $RUSTDESK_USER"
echo "  Diretório dados: $RUSTDESK_DIR"
echo ""

if [[ -f "$RUSTDESK_DIR/id_ed25519.pub" ]]; then
  echo "  ┌─ Chave Pública ──────────────────────────┐"
  while IFS= read -r line; do
    printf "  │  %-42s │\n" "$line"
  done < "$RUSTDESK_DIR/id_ed25519.pub"
  echo "  └───────────────────────────────────────────┘"
else
  warn "  Chave pública ainda não gerada. Verifique com:"
  echo "    cat $RUSTDESK_DIR/id_ed25519.pub"
fi

echo ""
echo "  🔹 Próximos passos:"
echo "     1. Configure os clientes com o IP e a chave acima"
echo "     2. Para acesso externo, veja docs/07-cloudflare-tunnel.md"
echo "     3. Para escolher VPS, veja docs/09-vps.md"
echo ""
echo "  🔹 Comandos úteis:"
echo "     docker logs hbbs    — logs do servidor de sinalização"
echo "     docker logs hbbr    — logs do servidor relay"
echo "     docker restart hbbs — reiniciar servidor"
echo ""
echo "=============================================="
echo ""

# ─── 14. Timer de manutenção ────────────────────────────────────────────────
if ! systemctl is-enabled rustdesk-maintenance.timer &>/dev/null; then
  cat > /etc/systemd/system/rustdesk-maintenance.service << 'EOF'
[Unit]
Description=RustDesk maintenance — pull images and restart
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
ExecStartPre=/usr/bin/docker pull rustdesk/rustdesk-server-s6:latest
ExecStart=/usr/bin/docker restart hbbs hbbr
EOF

  cat > /etc/systemd/system/rustdesk-maintenance.timer << 'EOF'
[Unit]
Description=Weekly RustDesk maintenance

[Timer]
OnCalendar=weekly
Persistent=true

[Install]
WantedBy=timers.target
EOF

  systemctl daemon-reload
  systemctl enable rustdesk-maintenance.timer
  log "Timer semanal de manutenção criado."
fi
