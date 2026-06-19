#!/bin/bash
# ============================================================
# RustDesk Client Deployment — Linux
# Execute como root: sudo bash deploy-client-linux.sh
# ============================================================

# --- CONFIGURE AQUI ---
rustdesk_cfg="configstring"
# ----------------------

rustdesk_pw=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 12 | head -n 1)

################################## Nao edite abaixo #########################################

if [[ $EUID -ne 0 ]]; then
    echo "Execute como root: sudo bash $0"
    exit 1
fi

set -e

# Detecta arquitetura
arch=$(uname -m)
case "$arch" in
    x86_64)  pkg_arch="x86_64" ;;
    aarch64) pkg_arch="aarch64" ;;
    armv7l)  pkg_arch="armv7"  ;;
    *)
        echo "Arquitetura nao suportada: $arch"
        exit 1
        ;;
esac

# Detecta ultima versao no GitHub
echo "Obtendo ultima versao..."
tag=$(curl -sL https://api.github.com/repos/rustdesk/rustdesk/releases/latest | grep '"tag_name"' | head -1 | cut -d'"' -f4 | sed 's/^v//')
echo "Versao encontrada: $tag"

# Detecta OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    OS_LIKE=$ID_LIKE
else
    echo "Nao foi possivel detectar o sistema operacional."
    exit 1
fi

DOWNLOAD_URL="https://github.com/rustdesk/rustdesk/releases/download/v${tag}"

case "$OS" in
    debian|ubuntu|linuxmint|pop)
        pkg="rustdesk-${tag}-${pkg_arch}.deb"
        echo "Baixando $pkg ..."
        wget -q "${DOWNLOAD_URL}/${pkg}"
        apt-get install -fy "./${pkg}" > /dev/null
        ;;
    fedora|centos|rhel|rocky|almalinux)
        pkg="rustdesk-${tag}-0.${pkg_arch}.rpm"
        echo "Baixando $pkg ..."
        wget -q "${DOWNLOAD_URL}/${pkg}"
        yum localinstall -y "./${pkg}" > /dev/null
        ;;
    arch|manjaro)
        pacman -S --noconfirm rustdesk > /dev/null 2>&1 || {
            echo "RustDesk nao encontrado nos repositorios. Instale manualmente."
            exit 1
        }
        ;;
    *)
        # Tenta identificar por ID_LIKE
        if echo "$OS_LIKE" | grep -qi "debian\|ubuntu"; then
            pkg="rustdesk-${tag}-${pkg_arch}.deb"
            echo "Baixando $pkg ..."
            wget -q "${DOWNLOAD_URL}/${pkg}"
            apt-get install -fy "./${pkg}" > /dev/null
        elif echo "$OS_LIKE" | grep -qi "rhel\|fedora\|centos"; then
            pkg="rustdesk-${tag}-0.${pkg_arch}.rpm"
            echo "Baixando $pkg ..."
            wget -q "${DOWNLOAD_URL}/${pkg}"
            yum localinstall -y "./${pkg}" > /dev/null
        else
            echo "SO nao suportado: $OS ($OS_LIKE)"
            echo "Tente a versao AppImage: ${DOWNLOAD_URL}/rustdesk-${tag}-${pkg_arch}.AppImage"
            exit 1
        fi
        ;;
esac

echo "Configurando..."
rustdesk_id=$(rustdesk --get-id)
rustdesk --password "$rustdesk_pw" &> /dev/null
rustdesk --config "$rustdesk_cfg"
systemctl restart rustdesk 2>/dev/null || true

echo "..............................................."
echo "RustDesk ID: $rustdesk_id"
echo "Senha permanente: $rustdesk_pw"
echo "Servidor configurado com sucesso."
echo "..............................................."
