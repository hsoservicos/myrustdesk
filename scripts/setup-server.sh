#!/bin/bash
# ============================================================
# RustDesk Server OSS — Script Automático de Implantação
# ============================================================
# Este script instala e configura o RustDesk Server OSS
# em servidores Ubuntu 22.04/24.04 ou Debian 12.
#
# Uso:
#   sudo ./setup-server.sh
#
# O que ele faz:
#   1. Verifica o sistema operacional
#   2. Instala Docker (se necessário)
#   3. Cria estrutura de diretórios
#   4. Baixa e inicia os containers hbbs e hbbr
#   5. Configura o firewall (UFW)
#   6. Exibe e salva as informações do servidor
# ============================================================

# Cores para facilitar a leitura
VERDE='\033[0;32m'
AZUL='\033[0;34m'
AMARELO='\033[1;33m'
VERMELHO='\033[0;31m'
CIANO='\033[0;36m'
NEGRITO='\033[1m'
RESET='\033[0m'

# ============================================================
# FUNÇÃO: Exibir mensagem formatada
# ============================================================
mensagem() {
    local cor=$1
    local texto=$2
    echo -e "${cor}${texto}${RESET}"
}

mensagem_ok() {
    echo -e "${VERDE}[✓]${RESET} $1"
}

mensagem_info() {
    echo -e "${AZUL}[i]${RESET} $1"
}

mensagem_aviso() {
    echo -e "${AMARELO}[!]${RESET} $1"
}

mensagem_erro() {
    echo -e "${VERMELHO}[✗]${RESET} $1"
}

mensagem_titulo() {
    echo ""
    echo -e "${CIANO}${NEGRITO}============================================${RESET}"
    echo -e "${CIANO}${NEGRITO} $1${RESET}"
    echo -e "${CIANO}${NEGRITO}============================================${RESET}"
    echo ""
}

# ============================================================
# FUNÇÃO: Verificar se o comando anterior deu certo
# ============================================================
verificar_erro() {
    local comando=$1
    local mensagem=$2
    if [ $? -ne 0 ]; then
        mensagem_erro "$mensagem"
        mensagem_aviso "Comando que falhou: $comando"
        mensagem_aviso "Verifique o erro acima e tente novamente."
        exit 1
    fi
}

# ============================================================
# INÍCIO DO SCRIPT
# ============================================================

clear
echo -e "${CIANO}${NEGRITO}"
echo "  ____           _        ____            _      "
echo " |  _ \ ___  ___| |_ ___ |  _ \  ___  ___| | ___ "
echo " | |_) / _ \/ __| __/ __|| | | |/ _ \/ __| |/ _ \\"
echo " |  _ <  __/\__ \ |_\__ \| |_| |  __/\__ \ |  __/"
echo " |_| \_\___||___/\__|___/|____/ \___||___/_|\___|"
echo ""
echo -e "${RESET}${AZUL}Servidor OSS — Script Automático de Implantação${RESET}"
echo ""

# ============================================================
# ETAPA 1: Verificar se é root
# ============================================================
mensagem_titulo "Etapa 1/6: Verificando privilégios"

if [ "$EUID" -ne 0 ]; then
    mensagem_erro "Este script precisa ser executado como root (use sudo)."
    mensagem_info "Comando correto: sudo ./setup-server.sh"
    exit 1
fi
mensagem_ok "Privilégios de root confirmados."

# ============================================================
# ETAPA 2: Verificar sistema operacional
# ============================================================
mensagem_titulo "Etapa 2/6: Verificando sistema operacional"

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VER=$VERSION_ID
else
    mensagem_erro "Não foi possível identificar o sistema operacional."
    exit 1
fi

mensagem_info "Sistema detectado: $OS $VER"

case $OS in
    ubuntu|debian)
        mensagem_ok "Sistema compatível: $OS $VER"
        ;;
    *)
        mensagem_erro "Sistema não suportado: $OS"
        mensagem_aviso "Este script funciona apenas em Ubuntu ou Debian."
        exit 1
        ;;
esac

# ============================================================
# ETAPA 3: Instalar Docker
# ============================================================
mensagem_titulo "Etapa 3/6: Verificando e instalando Docker"

if command -v docker &> /dev/null; then
    mensagem_ok "Docker já está instalado."
    docker_version=$(docker --version 2>/dev/null)
    mensagem_info "Versão: $docker_version"
else
    mensagem_info "Docker não encontrado. Instalando..."

    mensagem_info "Atualizando lista de pacotes..."
    apt update -qq
    verificar_erro "apt update" "Falha ao atualizar lista de pacotes."

    mensagem_info "Instalando dependências..."
    apt install -y -qq ca-certificates curl
    verificar_erro "apt install" "Falha ao instalar dependências."

    mensagem_info "Adicionando repositório oficial do Docker..."
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/$OS/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$OS $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

    mensagem_info "Instalando Docker Engine..."
    apt update -qq
    apt install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin
    verificar_erro "apt install docker" "Falha ao instalar Docker."

    systemctl enable docker > /dev/null 2>&1
    systemctl start docker > /dev/null 2>&1

    mensagem_ok "Docker instalado com sucesso!"
fi

# Verificar se o Docker está rodando
if ! systemctl is-active --quiet docker; then
    mensagem_info "Iniciando serviço do Docker..."
    systemctl start docker
    verificar_erro "systemctl start docker" "Falha ao iniciar o serviço Docker."
fi
mensagem_ok "Docker está rodando."

# ============================================================
# ETAPA 4: Criar estrutura de diretórios e arquivos
# ============================================================
mensagem_titulo "Etapa 4/6: Criando estrutura do projeto"

# Diretório base (diretório onde o script foi executado ou o home)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ "$SCRIPT_DIR" = "/root" ] || [ "$SCRIPT_DIR" = "$HOME" ]; then
    # Se o script foi executado de /root ou $HOME, cria em $HOME/rustdesk
    WORK_DIR="$HOME/rustdesk"
else
    WORK_DIR="$SCRIPT_DIR"
fi

mkdir -p "$WORK_DIR"
cd "$WORK_DIR" || exit 1
mensagem_info "Diretório de trabalho: $WORK_DIR"

# Criar diretório de dados
DATA_DIR="$WORK_DIR/rustdesk-data"
mkdir -p "$DATA_DIR"
mensagem_ok "Diretório de dados criado: $DATA_DIR"

# ============================================================
# ETAPA 5: Baixar e iniciar containers
# ============================================================
mensagem_titulo "Etapa 5/6: Iniciando servidores RustDesk"

# Primeiro baixa a imagem
mensagem_info "Baixando imagem do RustDesk Server..."
docker pull rustdesk/rustdesk-server:latest
verificar_erro "docker pull" "Falha ao baixar a imagem do RustDesk."
mensagem_ok "Imagem baixada com sucesso."

# Remove containers antigos se existirem
docker rm -f hbbs 2>/dev/null
docker rm -f hbbr 2>/dev/null

# Inicia hbbs (servidor de ID)
mensagem_info "Iniciando servidor de ID (hbbs)..."
docker run -d \
    --name hbbs \
    -v "$DATA_DIR:/root" \
    -p 21115:21115/tcp \
    -p 21116:21116/tcp \
    -p 21116:21116/udp \
    -p 21118:21118/tcp \
    --restart unless-stopped \
    rustdesk/rustdesk-server:latest hbbs
verificar_erro "docker run hbbs" "Falha ao iniciar o servidor hbbs."
mensagem_ok "Servidor de ID (hbbs) iniciado."

# Inicia hbbr (servidor de relay)
mensagem_info "Iniciando servidor de Relay (hbbr)..."
docker run -d \
    --name hbbr \
    -v "$DATA_DIR:/root" \
    -p 21117:21117/tcp \
    -p 21119:21119/tcp \
    --restart unless-stopped \
    rustdesk/rustdesk-server:latest hbbr
verificar_erro "docker run hbbr" "Falha ao iniciar o servidor hbbr."
mensagem_ok "Servidor de Relay (hbbr) iniciado."

# Aguarda alguns segundos para os containers gerarem as chaves
mensagem_info "Aguardando geração das chaves de segurança..."
sleep 3

# ============================================================
# ETAPA 6: Configurar firewall
# ============================================================
mensagem_titulo "Etapa 6/6: Configurando firewall"

if command -v ufw &> /dev/null; then
    mensagem_info "Configurando UFW (firewall)..."

    # Verifica se o UFW está ativo
    ufw status | grep -q "Status: active"
    if [ $? -ne 0 ]; then
        mensagem_info "UFW não está ativo. Ativando..."
        echo "y" | ufw enable > /dev/null 2>&1
    fi

    # Libera portas do RustDesk
    ufw allow 21115:21117/tcp > /dev/null 2>&1
    ufw allow 21116/udp > /dev/null 2>&1
    ufw allow 21118:21119/tcp > /dev/null 2>&1
    ufw reload > /dev/null 2>&1

    mensagem_ok "Portas liberadas no firewall:"
    echo -e "  ${AZUL}TCP 21115-21117${RESET} (sinalização e relay)"
    echo -e "  ${AZUL}UDP 21116${RESET}       (registro de ID)"
    echo -e "  ${AZUL}TCP 21118-21119${RESET} (web client - opcional)"
else
    mensagem_aviso "UFW não encontrado. Verifique se há outro firewall e libere manualmente:"
    mensagem_aviso "  Portas TCP: 21115, 21116, 21117, 21118, 21119"
    mensagem_aviso "  Porta  UDP: 21116"
fi

# ============================================================
# VERIFICAR INSTALAÇÃO
# ============================================================
mensagem_titulo "Verificando instalação"

sleep 2

# Verificar containers
CONTAINERS=$(docker ps --format "{{.Names}}" 2>/dev/null)
if echo "$CONTAINERS" | grep -q "hbbs" && echo "$CONTAINERS" | grep -q "hbbr"; then
    mensagem_ok "Ambos os containers estão rodando: hbbs e hbbr"
else
    mensagem_erro "Algum container não está rodando."
    mensagem_info "Verifique com: docker ps"
    docker ps 2>/dev/null
    mensagem_aviso "Tente executar manualmente:"
    mensagem_aviso "  docker start hbbs hbbr"
fi

# Verificar portas
MENSAGEM_PORTAS=""
for porta in 21115 21116 21117; do
    if ss -tlnp 2>/dev/null | grep -q ":$porta "; then
        MENSAGEM_PORTAS="$MENSAGEM_PORTAS\n  ${VERDE}[✓]${RESET} Porta $porta (TCP) — OK"
    else
        MENSAGEM_PORTAS="$MENSAGEM_PORTAS\n  ${VERMELHO}[✗]${RESET} Porta $porta (TCP) — FECHADA"
    fi
done
if ss -ulnp 2>/dev/null | grep -q ":21116 "; then
    MENSAGEM_PORTAS="$MENSAGEM_PORTAS\n  ${VERDE}[✓]${RESET} Porta 21116 (UDP) — OK"
else
    MENSAGEM_PORTAS="$MENSAGEM_PORTAS\n  ${VERMELHO}[✗]${RESET} Porta 21116 (UDP) — FECHADA"
fi

echo -e "Status das portas:$MENSAGEM_PORTAS"

# ============================================================
# OBTER INFORMAÇÕES DO SERVIDOR
# ============================================================

# Obter IP do servidor
SERVER_IP=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -n1)
if [ -z "$SERVER_IP" ]; then
    SERVER_IP=$(hostname -I | awk '{print $1}')
fi

# Obter chave pública
PUB_KEY=""
KEY_FILE="$DATA_DIR/id_ed25519.pub"
if [ -f "$KEY_FILE" ]; then
    PUB_KEY=$(cat "$KEY_FILE")
fi

# ============================================================
# SALVAR ARQUIVO DE RESUMO
# ============================================================
SUMMARY_FILE="$WORK_DIR/rustdesk-server-info.txt"

cat > "$SUMMARY_FILE" << EOF
=============================================
 RustDesk Server — Informações do Servidor
=============================================
 Data de instalação: $(date '+%d/%m/%Y %H:%M')
 Sistema operacional: $OS $VER

 ENDEREÇOS DO SERVIDOR:
   IP: $SERVER_IP
   Servidor ID (hbbs): $SERVER_IP:21116
   Servidor Relay (hbbr): $SERVER_IP:21117

 CHAVE PÚBLICA:
   $PUB_KEY

 PORTAS NECESSÁRIAS:
   TCP: 21115, 21116, 21117, 21118, 21119
   UDP: 21116

 COMANDOS ÚTEIS:
   Ver containers:    sudo docker ps
   Ver logs:          sudo docker logs hbbs --tail=20
   Parar servidor:    sudo docker stop hbbs hbbr
   Iniciar servidor:  sudo docker start hbbs hbbr
   Atualizar:         sudo docker pull rustdesk/rustdesk-server:latest
                      sudo docker restart hbbs hbbr
   Chave pública:     sudo cat $KEY_FILE

 CONFIGURAÇÃO DO CLIENTE:
   Servidor ID:  $SERVER_IP:21116
   Servidor Relay: (deixe em branco)
   Chave:        $PUB_KEY

=============================================
 Guarde estas informações em local seguro!
=============================================
EOF

mensagem_ok "Informações salvas em: $SUMMARY_FILE"

# ============================================================
# EXIBIR RESUMO FINAL
# ============================================================
clear
echo ""
echo -e "${CIANO}${NEGRITO}============================================${RESET}"
echo -e "${CIANO}${NEGRITO}  RustDesk Server — Instalação Concluída!   ${RESET}"
echo -e "${CIANO}${NEGRITO}============================================${RESET}"
echo ""
echo -e " ${AZUL}Endereço do servidor:${RESET}  ${NEGRITO}$SERVER_IP${RESET}"
echo -e " ${AZUL}Porta do servidor ID:${RESET}  ${NEGRITO}21116${RESET}"
echo ""
echo -e " ${AZUL}Chave Pública:${RESET}"
echo -e " ${NEGRITO}$PUB_KEY${RESET}"
echo ""
echo -e " ${AZUL}Arquivo de resumo:${RESET}  $SUMMARY_FILE"
echo ""
echo -e " ${VERDE}${NEGRITO}Para configurar os clientes:${RESET}"
echo ""
echo -e "   1. Abra o RustDesk no computador do usuário"
echo -e "   2. Menu → Configurações → Rede"
echo -e "   3. Servidor ID: ${NEGRITO}$SERVER_IP:21116${RESET}"
echo -e "   4. Chave: ${NEGRITO}$PUB_KEY${RESET}"
echo -e "   5. Relay: (deixe em branco)"
echo -e "   6. Clique em OK"
echo ""
echo -e "${CIANO}${NEGRITO}============================================${RESET}"
echo ""

# ============================================================
# VERIFICAÇÃO FINAL
# ============================================================

# Verifica se a chave pública foi gerada
if [ -z "$PUB_KEY" ]; then
    mensagem_aviso "A chave pública não foi encontrada em $KEY_FILE"
    mensagem_aviso "Isso pode ocorrer na primeira execução. Aguarde alguns segundos e verifique:"
    mensagem_aviso "  sudo cat $KEY_FILE"
    mensagem_aviso "Se o arquivo não existir, reinicie os containers:"
    mensagem_aviso "  sudo docker restart hbbs"
fi

# Verificar de forma geral
mensagem_titulo "Checklist de Verificação"

CHECKS=0
CHECKS_OK=0

# Check 1: Docker
CHECKS=$((CHECKS + 1))
if command -v docker &> /dev/null; then
    mensagem_ok "[$CHECKS/6] Docker instalado"
    CHECKS_OK=$((CHECKS_OK + 1))
else
    mensagem_erro "[$CHECKS/6] Docker NÃO instalado"
fi

# Check 2: Container hbbs
CHECKS=$((CHECKS + 1))
if docker ps --format "{{.Names}}" 2>/dev/null | grep -q "^hbbs$"; then
    mensagem_ok "[$CHECKS/6] Container hbbs rodando"
    CHECKS_OK=$((CHECKS_OK + 1))
else
    mensagem_erro "[$CHECKS/6] Container hbbs NÃO está rodando"
fi

# Check 3: Container hbbr
CHECKS=$((CHECKS + 1))
if docker ps --format "{{.Names}}" 2>/dev/null | grep -q "^hbbr$"; then
    mensagem_ok "[$CHECKS/6] Container hbbr rodando"
    CHECKS_OK=$((CHECKS_OK + 1))
else
    mensagem_erro "[$CHECKS/6] Container hbbr NÃO está rodando"
fi

# Check 4: Porta 21116
CHECKS=$((CHECKS + 1))
if ss -tlnp 2>/dev/null | grep -q ":21116 "; then
    mensagem_ok "[$CHECKS/6] Porta 21116 TCP liberada"
    CHECKS_OK=$((CHECKS_OK + 1))
else
    mensagem_erro "[$CHECKS/6] Porta 21116 TCP NÃO liberada"
fi

# Check 5: Porta 21117
CHECKS=$((CHECKS + 1))
if ss -tlnp 2>/dev/null | grep -q ":21117 "; then
    mensagem_ok "[$CHECKS/6] Porta 21117 TCP liberada"
    CHECKS_OK=$((CHECKS_OK + 1))
else
    mensagem_erro "[$CHECKS/6] Porta 21117 TCP NÃO liberada"
fi

# Check 6: Chave pública
CHECKS=$((CHECKS + 1))
if [ -f "$KEY_FILE" ]; then
    mensagem_ok "[$CHECKS/6] Chave pública disponível"
    CHECKS_OK=$((CHECKS_OK + 1))
else
    mensagem_erro "[$CHECKS/6] Chave pública NÃO encontrada"
fi

echo ""
if [ "$CHECKS_OK" -eq "$CHECKS" ]; then
    echo -e "${VERDE}${NEGRITO}✓ Todos os $CHECKS verificações passaram!${RESET}"
    echo ""
    echo -e "O servidor RustDesk está pronto para uso."
    echo -e "Configure os clientes conforme as instruções no manual (MANUAL_IMPLANTACAO.md)."
elif [ "$CHECKS_OK" -ge 4 ]; then
    echo -e "${AMARELO}${NEGRITO}⚠ $CHECKS_OK de $CHECKS verificações passaram.${RESET}"
    echo -e "Verifique os itens com erro acima."
else
    echo -e "${VERMELHO}${NEGRITO}✗ Apenas $CHECKS_OK de $CHECKS verificações passaram.${RESET}"
    echo -e "Algo deu errado. Consulte o manual de solução de problemas."
fi

echo ""
echo -e "${AZUL}Arquivo de resumo:${RESET} $SUMMARY_FILE"
echo -e "${AZUL}Diretório de dados:${RESET} $DATA_DIR"
echo ""
