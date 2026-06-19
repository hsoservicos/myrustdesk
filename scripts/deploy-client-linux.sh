#!/bin/bash
# ============================================================
# RustDesk Client Deployment — Linux
# Execute como root: sudo bash deploy-client-linux.sh
# ============================================================

# --- CONFIGURE AQUI ---
rustdesk_cfg="configstring"
# ----------------------

# Gera senha aleatória de 8 caracteres
rustdesk_pw=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)

################################## Nao edite abaixo #########################################

if [[ $EUID -ne 0 ]]; then
    echo "Este script deve ser executado como root."
    exit 1
fi

# Identifica SO
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
    UPSTREAM_ID=${ID_LIKE,,}
    if [ "${UPSTREAM_ID}" != "debian" ] && [ "${UPSTREAM_ID}" != "ubuntu" ]; then
        UPSTREAM_ID="$(echo ${ID_LIKE,,} | sed s/\"//g | cut -d' ' -f1)"
    fi
elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSE-release ]; then
    OS=SuSE
    VER=$(cat /etc/SuSE-release)
elif [ -f /etc/redhat-release ]; then
    OS=RedHat
    VER=$(cat /etc/redhat-release)
else
    OS=$(uname -s)
    VER=$(uname -r)
fi

echo "Instalando RustDesk para $OS $VER"

if [ "${ID}" = "debian" ] || [ "$OS" = "Ubuntu" ] || [ "$OS" = "Debian" ] || [ "${UPSTREAM_ID}" = "ubuntu" ] || [ "${UPSTREAM_ID}" = "debian" ]; then
    wget -q https://github.com/rustdesk/rustdesk/releases/download/1.2.6/rustdesk-1.2.6-x86_64.deb
    apt-get install -fy ./rustdesk-1.2.6-x86_64.deb > /dev/null
elif [ "$OS" = "CentOS" ] || [ "$OS" = "RedHat" ] || [ "$OS" = "Fedora Linux" ] || [ "${UPSTREAM_ID}" = "rhel" ] || [ "$OS" = "Almalinux" ] || [ "$OS" = "Rocky"* ]; then
    wget -q https://github.com/rustdesk/rustdesk/releases/download/1.2.6/rustdesk-1.2.6-0.x86_64.rpm
    yum localinstall ./rustdesk-1.2.6-0.x86_64.rpm -y > /dev/null
else
    echo "SO nao suportado: $OS"
    exit 1
fi

rustdesk_id=$(rustdesk --get-id)
rustdesk --password $rustdesk_pw &> /dev/null
rustdesk --config $rustdesk_cfg
systemctl restart rustdesk

echo "..............................................."
echo "RustDesk ID: $rustdesk_id"
echo "Password: $rustdesk_pw"
echo "..............................................."
