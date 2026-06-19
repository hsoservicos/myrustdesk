# Instalação do Servidor RustDesk OSS

Este guia cobre a instalação do servidor RustDesk OSS via Docker (recomendado), script de instalação e pacote Debian.

## Método 1: Docker (Recomendado)

### Pré-requisitos

- Linux (Ubuntu/Debian recomendado)
- Docker e Docker Compose instalados

```bash
# Instalar Docker
bash <(wget -qO- https://get.docker.com)

# Verificar instalação
sudo docker --version
sudo docker compose version
```

### Firewall

Libere as portas necessárias:

```bash
# Se estiver usando UFW
sudo ufw allow 21115:21117/tcp
sudo ufw allow 21116/udp
sudo ufw enable

# Portas opcionais para web client
sudo ufw allow 21118:21119/tcp
```

> Se estiver usando `iptables` ou `firewalld`, ajuste conforme sua distribuição.

### Iniciar Servidores

```bash
# Criar diretório de dados
mkdir -p ./data

# Iniciar containers
sudo docker compose up -d

# Verificar status
sudo docker compose ps
sudo docker compose logs
```

### Obter Chave Pública

A chave pública é gerada automaticamente na primeira execução do `hbbs`:

```bash
sudo cat ./data/id_ed25519.pub
```

Saída esperada (exemplo):
```
MetR3h4jKqRfG7xPm8sL5vB2nW9cQ6yD1oX0zE3uA8=
```

**Guarde esta chave** — ela será necessária em todos os clientes.

### Parâmetros de Configuração

Edite o `compose.yml` para adicionar variáveis de ambiente:

```yaml
services:
  hbbs:
    environment:
      - ALWAYS_USE_RELAY=Y   # Forçar uso de relay
      - ENCRYPTED_ONLY=1     # Conexões apenas criptografadas
```

## Método 2: Script de Instalação (Techahold)

```bash
wget https://raw.githubusercontent.com/techahold/rustdeskinstall/master/install.sh
chmod +x install.sh
sudo ./install.sh
```

Ao final, o script exibirá o IP/DNS e a Key. Anote ambos.

## Método 3: Pacote .deb (Debian/Ubuntu)

```bash
# Baixar a última versão
wget https://github.com/rustdesk/rustdesk-server/releases/latest/download/rustdesk-server-hbbs_amd64.deb
wget https://github.com/rustdesk/rustdesk-server/releases/latest/download/rustdesk-server-hbbr_amd64.deb

# Instalar
sudo apt-get -f install ./rustdesk-server-hbbs_amd64.deb ./rustdesk-server-hbbr_amd64.deb
```

## Verificação pós-instalação

```bash
# Verificar se os serviços estão rodando
sudo docker compose ps

# Testar as portas
sudo ss -tlnp | grep -E '2111[4-9]'
sudo ss -ulnp | grep 21116

# Ver logs
sudo docker compose logs --tail=50
```

---

