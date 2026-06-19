# Publicação do RustDesk via Cloudflare Tunnel

## Objetivo

Permitir que terminais **fora da rede local** (internet) se conectem ao servidor
RustDesk sem expor portas no firewall da rede, usando a infraestrutura da Cloudflare.

---

## Entendendo o Problema

O RustDesk Server OSS exige dois tipos de tráfego de rede:

| Porta | Protocolo | Serviço | Crítico? |
|---|---|---|---|
| 21115 | TCP | Teste de tipo NAT | Sim |
| 21116 | **TCP** | Hole punching e conexão | Sim |
| 21116 | **UDP** | Registro de ID e heartbeat | **Sim** |
| 21117 | TCP | Retransmissão (relay) | Sim |
| 21118 | TCP | Cliente Web (WebSocket) | Opcional |
| 21119 | TCP | Cliente Web (WebSocket) | Opcional |

**O desafio:** O Cloudflare Tunnel gratuito **não suporta UDP**.
A porta 21116/UDP é essencial para o registro de ID dos clientes — sem ela,
o RustDesk não funciona. Diversas fontes confirmam esta limitação:

- [Cloudflare Community — RustDesk compatible?](https://community.cloudflare.com/t/rustdesk-compatible/507510)
- [Home Assistant Community — RustDesk Cloudflare](https://community.home-assistant.io/t/self-host-rustdesk-server-inside-home-assistant/1004868)
- Cloudflare Docs: UDP requer [Spectrum (Enterprise)](https://developers.cloudflare.com/spectrum/) ou [Private Network + WARP](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/private-net/)

---

## Métodos Disponíveis

| Método | TCP | UDP | Precisa de software no cliente? | Custo |
|---|---|---|---|---|
| **A: Cloudflare Zero Trust + WARP** | ✅ | ✅ | WARP Client | Gratuito (até 50 usuários) |
| **B: Cloudflare Tunnel (Web Client)** | ✅ (parcial) | ❌ | Navegador web | Gratuito |
| **C: DNS Only (Grey Cloud)** | ✅ | ✅ | Nenhum | Gratuito |
| **D: Cloudflare Spectrum** | ✅ | ✅ | Nenhum | Enterprise (alto custo) |

---

## Método A: Cloudflare Zero Trust + WARP (Recomendado)

### Como funciona

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Cliente Remoto  │     │   Cloudflare     │     │    Servidor      │
│  (com WARP)      │◄───►│   Edge Network   │◄───►│  (cloudflared)   │
│                  │     │  (Zero Trust)    │     │                  │
│  RustDesk →      │     │  Rota Private:   │     │  Rota:           │
│  192.168.1.100   │     │  192.168.1.0/24  │     │  192.168.1.100   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

O cliente WARP + cloudflared criam uma **rede privada virtual** sobre a
infraestrutura Cloudflare. Todo o tráfego (TCP e UDP) entre cliente e servidor
é encapsulado e criptografado. **Nenhuma porta precisa ser aberta no firewall**.

### Pré-requisitos

1. **Conta Cloudflare** ([cloudflare.com](https://dash.cloudflare.com/sign-up)) — gratuita
2. **Domínio** com DNS gerenciado pela Cloudflare (ex: `meudominio.com`)
3. **Servidor Linux** (Ubuntu/Debian) com Docker e RustDesk rodando
4. **Clientes** que conectarão remotamente (Windows, macOS, Linux, Android, iOS)

### Passo a Passo

#### Passo 1: Criar uma conta Cloudflare Zero Trust

1. Acesse [dash.cloudflare.com](https://dash.cloudflare.com)
2. Vá em **Zero Trust** (no menu lateral)
3. Clique em **Create account** ou **Free plan**
4. Escolha um nome para sua equipe (ex: `minha-empresa`)
5. Siga as instruções iniciais

#### Passo 2: Instalar cloudflared no servidor

No servidor onde o RustDesk já está rodando:

```bash
# Baixar e instalar cloudflared
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb

# Verificar instalação
cloudflared --version
```

#### Passo 3: Autenticar o servidor na Cloudflare

```bash
cloudflared tunnel login
```

Será exibido um link no terminal. Copie e abra no navegador.
Autorize o domínio que você gerenciar na Cloudflare.
Um certificado será baixado automaticamente.

#### Passo 4: Criar o túnel

```bash
cloudflared tunnel create rustdesk-tunnel
```

Saída esperada:
```
Tunnel created: a1b2c3d4-e5f6-7890-abcd-ef1234567890
Credentials file created: /home/usuario/.cloudflared/a1b2c3d4...json
```

Anote o **UUID do túnel** (a1b2c3d4-e5f6-7890-abcd-ef1234567890).

#### Passo 5: Configurar a rede privada (Private Network)

1. No **Zero Trust Dashboard**:
   - Vá em **Networks → Tunnels**
   - Clique no túnel criado (`rustdesk-tunnel`)
   - Na aba **Private Networks**, clique em **Add a private network**
   - Adicione o CIDR da sua rede local (ex: `192.168.1.0/24`)
   - Clique em **Save**

   > **Dica:** Descubra o CIDR da sua rede com `ip addr show | grep "inet "`

#### Passo 6: Instalar o cloudflared como serviço

Para que o túnel fique sempre ativo:

```bash
# Instalar como serviço systemd
sudo cloudflared --config /home/usuario/.cloudflared/config.yml service install

# Iniciar o serviço
sudo systemctl start cloudflared

# Habilitar para iniciar com o sistema
sudo systemctl enable cloudflared

# Verificar status
sudo systemctl status cloudflared
```

> **Arquivo de configuração:** Se não existir, crie em `/home/usuario/.cloudflared/config.yml`:

```yaml
tunnel: a1b2c3d4-e5f6-7890-abcd-ef1234567890
credentials-file: /home/usuario/.cloudflared/a1b2c3d4-e5f6-7890-abcd-ef1234567890.json
ingress:
  - service: http_status:404
```

> A rota privada (Private Network) é configurada pelo dashboard, não pelo config.yml.

#### Passo 7: Configurar o WARP nos clientes

**No servidor (uma vez):**

1. No **Zero Trust Dashboard**, vá em **Settings → WARP Client → Device Enrollment**
2. Crie uma política de inscrição:
   - Name: `Acesso RustDesk`
   - Rule: `Everyone` (ou restrinja por e-mail)
   - Clique em **Save**

**Em cada computador/cliente que acessará remotamente:**

1. Baixe o **Cloudflare WARP Client**:
   - [Windows / macOS / Linux](https://developers.cloudflare.com/cloudflare-one/connections/connect-devices/warp/download-warp/)
   - [Android](https://play.google.com/store/apps/details?id=com.cloudflare.onedotone)
   - [iOS](https://apps.apple.com/app/1-1-1-1-faster-internet/id1423538627)

2. **Configure o WARP para sua equipe** (método 1 — comando):
   ```bash
   # Windows (PowerShell como Admin)
   warp-cli team-enroll minha-empresa

   # Linux/macOS
   sudo warp-cli team-enroll minha-empresa
   ```

   **Método 2 — arquivo de configuração (deploy automatizado)**:
   Crie um arquivo `mdm.xml` ou `warp.json` com o nome da equipe, ou
   use o link: `https://cloudflarewarp.com/[equipe]` no navegador.

3. **Autentique-se** — o navegador abrirá para login no Google/Microsoft/qualquer
   provedor configurado no Zero Trust

4. Vá em **Settings → Split Tunnels** e certifique-se de que o CIDR da sua
   rede local (`192.168.1.0/24`) está roteado pelo WARP.
   No dashboard do Zero Trust: **Settings → WARP Client → Split Tunnels**,
   inclua o CIDR.

5. Verifique a conexão: o WARP deve mostrar "Connected" ou "Protegido"

#### Passo 8: Configurar o RustDesk nos clientes remotos

Com o WARP ativo e conectado, os clientes remotos "enxergam" o servidor como
se estivessem na rede local.

Configure o RustDesk normalmente (Settings → Network):

| Campo | Valor |
|---|---|
| **Servidor ID** | `<IP_LOCAL_DO_SERVIDOR>:21116` (ex: `192.168.1.100:21116`) |
| **Chave** | Chave pública do servidor (`id_ed25519.pub`) |
| **Servidor Relay** | Deixe em branco |

> **Importante:** O IP do servidor deve ser o **IP local** da rede (ex: `192.168.1.100`),
> não o IP público. O WARP cuida do roteamento.

#### Passo 9: Testar

1. Em um cliente remoto (fora da rede local):
   - Ative o WARP (deve conectar ao Zero Trust)
   - Abra o RustDesk
   - O ID do dispositivo remoto deve aparecer no RustDesk
   - Tente conectar a outro dispositivo na rede local

2. Verifique se a conexão está passando pelo túnel:
   ```bash
   # No servidor, verifique os logs do cloudflared
   sudo journalctl -u cloudflared -f
   ```

### Vantagens do Método A

- ✅ **TCP e UDP funcionam completamente** — sem limitações
- ✅ **Nenhuma porta aberta** no firewall — apenas saída para Cloudflare
- ✅ **Criptografia ponta-a-ponta** via WireGuard (WARP)
- ✅ **Gratuito** para até 50 usuários
- ✅ **Sem IP público** necessário no servidor
- ✅ **Funciona em qualquer rede** (CGNAT, 4G/5G, redes corporativas restritivas)

### Limitações do Método A

- ⚠️ Todos os clientes remotos precisam instalar o WARP
- ⚠️ Requer conta Cloudflare e domínio configurado
- ⚠️ Acesso aos dispositivos dentro da rede local pelo nome/IP local
- ⚠️ Latência adicional (tráfego passa pela Cloudflare)

---

## Método B: Cloudflare Tunnel para Cliente Web (WebSocket)

Este método expõe apenas os WebSocket (portas 21118/21119) usados pelo
[Cliente Web RustDesk](https://rustdesk.com/web/).

**Não permite** que o cliente desktop se conecte, apenas o navegador.

### Passo 1: Instalar cloudflared

```bash
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb
cloudflared tunnel login
```

### Passo 2: Criar túnel com DNS

```bash
cloudflared tunnel create rustdesk-web
cloudflared tunnel route dns rustdesk-web rd.mydomain.com
```

### Passo 3: Configurar ingress

Edite `~/.cloudflared/config.yml`:

```yaml
tunnel: <UUID>
credentials-file: /root/.cloudflared/<UUID>.json
ingress:
  - hostname: rd.meudominio.com
    service: http://localhost:21118
  - service: http_status:404
```

### Passo 4: Configurar Nginx para WSS

O RustDesk Web Client precisa de WebSocket Seguro (WSS). Configure um
proxy reverso no servidor:

```bash
sudo apt install -y nginx
```

Crie `/etc/nginx/sites-available/rustdesk-web`:

```nginx
server {
    listen 80;
    server_name rd.meudominio.com;

    location / {
        proxy_pass http://127.0.0.1:21118;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_read_timeout 86400;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/rustdesk-web /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

### Passo 5: Iniciar túnel

```bash
sudo cloudflared --config ~/.cloudflared/config.yml service install
sudo systemctl start cloudflared
```

### Limitações do Método B

- ⚠️ Apenas para **cliente web** (navegador)
- ⚠️ Não substitui o cliente desktop RustDesk
- ⚠️ UDP não funciona — conexões web têm suporte limitado

---

## Método C: DNS Only (Grey Cloud) — Alternativa Sem Túnel

Esta **não é** uma solução de túnel. Usa apenas o **DNS da Cloudflare**
para resolver o nome do servidor, sem proxy. O tráfego vai **direto**
para o IP público do servidor.

**Exige porta aberta no firewall/roteador.**

### Configuração

1. No **Cloudflare Dashboard**, crie um registro DNS:

   | Tipo | Nome | Conteúdo | Proxy |
   |---|---|---|---|
   | A | `rd` | `<IP_PUBLICO_DO_SERVIDOR>` | **DNS Only** (cinza) |

   > ⚠️ **Proxy (laranja) não funciona** — Cloudflare bloqueará o tráfego
   > por não ser HTTP/HTTPS.

2. No roteador, faça **port forwarding** das portas para o servidor:

   | Porta Externa | Protocolo | IP Interno | Porta Interna |
   |---|---|---|---|
   | 21115 | TCP | 192.168.1.100 | 21115 |
   | 21116 | TCP+UDP | 192.168.1.100 | 21116 |
   | 21117 | TCP | 192.168.1.100 | 21117 |

3. Configure os clientes com o domínio:

   ```text
   Servidor ID: rd.meudominio.com:21116
   Chave: <chave_publica>
   ```

### Limitações

- ⚠️ **IP público** necessário no servidor
- ⚠️ **Portas abertas** no firewall — maior superfície de ataque
- ⚠️ **NAT Loopback**: clientes na mesma rede local podem não conseguir
  acessar pelo domínio público (consulte `docs/06-solucao-de-problemas.md`)
- ⚠️ Sujeito a ataques de força bruta nas portas expostas

---

## Método D: Cloudflare Spectrum (Enterprise)

O Spectrum permite proxy TCP/UDP diretamente, sem cliente WARP.
Porém, é um produto **Enterprise** com custo elevado (contrato mínimo anual).

Não é recomendado para uso pessoal ou de pequenas equipes.

---

## Comparação Final

| Característica | A: Zero Trust+WARP | B: Web Tunnel | C: DNS Only | D: Spectrum |
|---|---|---|---|---|
| **TCP** | ✅ Completo | ✅ Parcial | ✅ Completo | ✅ Completo |
| **UDP** | ✅ Completo | ❌ | ✅ Completo | ✅ Completo |
| **Cliente desktop** | ✅ Funciona | ❌ | ✅ Funciona | ✅ Funciona |
| **Cliente web** | ✅ | ✅ | ✅ | ✅ |
| **Portas abertas?** | ❌ Nenhuma | ❌ Nenhuma | ✅ Sim | ❌ Nenhuma |
| **IP público?** | ❌ Não precisa | ❌ Não precisa | ✅ Sim | ❌ Não precisa |
| **Software no cliente** | WARP Client | Navegador | Nenhum | Nenhum |
| **Custo** | Gratuito (50 usuários) | Gratuito | Gratuito | Enterprise |
| **Complexidade** | Média | Média | Baixa | Alta (contrato) |
| **Segurança** | Alta (Zero Trust) | Média | Baixa | Alta |

---

## Recomendação

**Para a maioria dos casos** (equipes de até 50 pessoas, servidor em rede
local sem IP público), o **Método A (Zero Trust + WARP)** é a escolha ideal:

- ✅ Suporta TCP e UDP completamente
- ✅ Não expõe portas na internet
- ✅ Gratuito
- ✅ Fácil de configurar com o script automatizado

**Se você tem IP público** e pode abrir portas no firewall com segurança,
o **Método C (DNS Only)** é mais simples — mas lembre-se de proteger o
acesso com regras de firewall restritivas.

---

## Referências

- [Cloudflare Tunnel Documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)
- [Zero Trust Free Plan](https://www.cloudflare.com/plans/zero-trust/)
- [WARP Client Download](https://developers.cloudflare.com/cloudflare-one/connections/connect-devices/warp/download-warp/)
- [Cloudflare Community — RustDesk](https://community.cloudflare.com/t/rustdesk-compatible/507510)
- [RustDesk Web Client](https://rustdesk.com/web/)
- [Private Network with WARP](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/private-net/)
