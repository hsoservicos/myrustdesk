#!/bin/bash
# ============================================================
# RustDesk Client Deployment — macOS
# Execute: bash deploy-client-macos.sh
# ============================================================

# --- CONFIGURE AQUI ---
rustdesk_cfg="configstring"
# ----------------------

rustdesk_pw=$(openssl rand -hex 6)

################################## Nao edite abaixo #########################################

[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

set -e

echo "Obtendo ultima versao..."
tag=$(curl -sL https://api.github.com/repos/rustdesk/rustdesk/releases/latest | grep '"tag_name"' | head -1 | cut -d'"' -f4 | sed 's/^v//')
echo "Versao encontrada: $tag"

if [[ $(arch) == 'arm64' ]]; then
    dmg_file="rustdesk-${tag}.aarch64.dmg"
    url="https://github.com/rustdesk/rustdesk/releases/download/v${tag}/${dmg_file}"
else
    dmg_file="rustdesk-${tag}.x86_64.dmg"
    url="https://github.com/rustdesk/rustdesk/releases/download/v${tag}/${dmg_file}"
fi

echo "Baixando ${dmg_file}..."
curl -L "$url" --output "$dmg_file" --progress-bar

mount_point="/Volumes/RustDesk"
hdiutil attach "$dmg_file" -mountpoint "$mount_point" &> /dev/null

if [ $? -eq 0 ]; then
    echo "Instalando..."
    rm -rf "/Applications/RustDesk.app" 2>/dev/null || true
    cp -R "$mount_point/RustDesk.app" "/Applications/" &> /dev/null
    hdiutil detach "$mount_point" &> /dev/null
else
    echo "Falha ao montar o DMG. Instalacao abortada."
    exit 1
fi

# Limpa o DMG baixado
rm -f "$dmg_file"

cd /Applications/RustDesk.app/Contents/MacOS/

echo "Configurando..."
rustdesk_id=$(./RustDesk --get-id 2>/dev/null || echo "desconhecido")

./RustDesk --server &
sleep 2
./RustDesk --password "$rustdesk_pw" &> /dev/null
./RustDesk --config "$rustdesk_cfg"

# Aguarda configuracao e encerra processo temporario
sleep 2
pkill -f "RustDesk" 2>/dev/null || true

echo "..............................................."
echo "RustDesk ID: $rustdesk_id"
echo "Senha permanente: $rustdesk_pw"
echo "Servidor configurado com sucesso."
echo "..............................................."
echo ""
echo "Complete a instalacao na GUI. Iniciando RustDesk..."
open -n /Applications/RustDesk.app
