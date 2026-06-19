#!/bin/bash
# ============================================================
# RustDesk Client Deployment — macOS
# Execute: bash deploy-client-macos.sh
# ============================================================

# --- CONFIGURE AQUI ---
rustdesk_cfg="configstring"
# ----------------------

# Gera senha aleatória de 8 caracteres hex
rustdesk_pw=$(openssl rand -hex 4)

################################## Nao edite abaixo #########################################

[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

mount_point="/Volumes/RustDesk"

echo "Baixando RustDesk..."

if [[ $(arch) == 'arm64' ]]; then
    rd_link=$(curl -sL https://github.com/rustdesk/rustdesk/releases/latest | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*/\d{1}.\d{1,2}.\d{1,2}/rustdesk.\d{1}.\d{1,2}.\d{1,2}.aarch64.dmg")
    dmg_file=$(echo $rd_link | grep -Eo "rustdesk.\d{1}.\d{1,2}.\d{1,2}.aarch64.dmg")
    curl -L "$rd_link" --output "$dmg_file"
else
    rd_link=$(curl -sL https://github.com/rustdesk/rustdesk/releases/latest | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*/\d{1}.\d{1,2}.\d{1,2}/rustdesk.\d{1}.\d{1,2}.\d{1,2}.x86_64.dmg")
    dmg_file=$(echo $rd_link | grep -Eo "rustdesk.\d{1}.\d{1,2}.\d{1,2}.x86_64.dmg")
    curl -L "$rd_link" --output "$dmg_file"
fi

hdiutil attach "$dmg_file" -mountpoint "$mount_point" &> /dev/null

if [ $? -eq 0 ]; then
    cp -R "$mount_point/RustDesk.app" "/Applications/" &> /dev/null
    hdiutil detach "$mount_point" &> /dev/null
else
    echo "Falha ao montar o DMG. Instalacao abortada."
    exit 1
fi

cd /Applications/RustDesk.app/Contents/MacOS/
rustdesk_id=$(./RustDesk --get-id)

./RustDesk --server &
/Applications/RustDesk.app/Contents/MacOS/RustDesk --password $rustdesk_pw &> /dev/null
/Applications/RustDesk.app/Contents/MacOS/RustDesk --config $rustdesk_cfg

rdpid=$(pgrep RustDesk)
kill $rdpid &> /dev/null

echo "..............................................."
if [ -n "$rustdesk_id" ]; then
    echo "RustDesk ID: $rustdesk_id"
else
    echo "Falha ao obter RustDesk ID."
fi
echo "Password: $rustdesk_pw"
echo "..............................................."

echo "Complete a instalacao na GUI. Iniciando RustDesk..."
open -n /Applications/RustDesk.app
