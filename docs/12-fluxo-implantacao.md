# Fluxo Completo de Implantação — Do Zero ao RustDesk Funcionando

> **Público:** Administradores de sistemas (iniciantes a intermediários)
> **Tempo estimado:** 30–60 minutos
> **Custo mínimo:** US$ 0 (Oracle Free Tier) a ~US$ 4/mês (Hetzner CX22)

Este documento consolida **todo o processo de implantação** em um único fluxo,
referenciando os documentos detalhados para cada etapa.

---

## Sumário do Fluxo

```
┌──────────────────────────────────────────────┐
│              1. ESCOLHA / CONTRATE           │
│              provedor VPS                    │
└──────────────────┬───────────────────────────┘
                   ▼
┌──────────────────────────────────────────────┐
│              2. PROVISIONE                   │
│              execute provision-vps.sh        │
└──────────────────┬───────────────────────────┘
                   ▼
┌──────────────────────────────────────────────┐
│              3. VERIFIQUE                    │
│              servidor RustDesk rodando       │
│              anote chave pública + IP        │
└──────────────────┬───────────────────────────┘
                   ▼
┌──────────────────────────────────────────────┐
│           (OPCIONAL)                         │
│    4. EXPONHA COM CLOUDFLARE                 │
│    Zero Trust + WARP (recomendado)           │
└──────────────────┬───────────────────────────┘
                   ▼
┌──────────────────────────────────────────────┐
│              5. DEPLOY CLIENTES              │
│              instale + configure             │
│              nos computadores                │
└──────────────────┬───────────────────────────┘
                   ▼
┌──────────────────────────────────────────────┐
│              6. TESTE E USE                  │
│              conexão remota funcionando      │
└──────────────────────────────────────────────┘
```

---

## Etapa 1: Escolher e Contratar a VPS

### 1.1 Decida qual provedor usar

Consulte o **guia completo de VPS** ([docs/09-vps.md](./09-vps.md)) para análise
detalhada dos 14 provedores. Abaixo, um resumo da recomendação por perfil:

| Perfil | Provedor Recomendado | Custo/mês |
|---|---|---|
| Teste / aprendizagem | Oracle Cloud Free Tier | **US$ 0** |
| Melhor custo-benefício global | **Hetzner CAX11** (CX22) | ~€3,79 |
| Precisa de datacenter SP | **Lightsail** (AWS SP) | US$ 7 |
| Melhor custo-benefício nacional | **KingHost 1 GB** | R$ 22,90 |
| Suporte português + preço | **Hostinger Brasil KVM 1** | R$ 29,99 (promo 2 a) |

Consulte a **[árvore de decisão](./09-vps.md#73-árvore-de-decisão)** e a
**[matriz de decisão](./09-vps.md#72-matriz-de-decisão)** para escolha precisa.

### 1.2 Contrate a VPS

Veja o **passo a passo de contratação** para cada provedor em:
[09-vps.md — Seção 8](./09-vps.md#8-passo-a-passo-contratação-e-provisionamento)

**Requisitos mínimos do plano:**
- **RAM:** 1 GB (512 MB funciona com swap, mas não recomendado)
- **CPU:** 1 core (x86_64 ou arm64)
- **Disco:** 10 GB SSD (sistema ~5 GB + RustDesk ~100 MB)
- **SO:** Ubuntu 22.04/24.04 LTS ou Debian 12
- **Tráfego:** Qualquer plano (RustDesk consome ~1-5 GB/mês para 10 dispositivos)
- **IP público:** IPv4 (a maioria dos provedores inclui)

### 1.3 Acesse a VPS

Após a contratação, você receberá:
- **IP público** da VPS (ex: `203.0.113.10`)
- **Senha root** (ou chave SSH)

Acesse via SSH:

```bash
ssh root@<IP-DA-VPS>
```

---

## Etapa 2: Provisionar a VPS

### 2.1 Execute o script de provisionamento

O script `provision-vps.sh` ([scripts/provision-vps.sh](../scripts/provision-vps.sh))
faz **tudo automaticamente**:

| O que faz | Detalhes |
|---|---|
| Atualiza o sistema | `apt update && apt upgrade` |
| Cria usuário não-root | `rustdesk` (sudo) |
| SSH hardening | Desabilita root login por senha |
| Docker | Instala via script oficial |
| UFW | Bloqueia tudo, libera SSH + portas RustDesk |
| fail2ban | 5 tentativas = ban por 1h |
| unattended-upgrades | Atualizações de segurança automáticas |
| Swap | Cria se RAM ≤ 2 GB |
| Containers RustDesk | hbbs + hbbr via Docker |
| Timer semanal | `docker pull` + restart automático |

**Execute:**

```bash
# Como root na VPS (recomendado via pipe):
curl -sS https://raw.githubusercontent.com/hsoservicos/myrustdesk/main/scripts/provision-vps.sh | sudo bash

# Ou copie e execute:
scp scripts/provision-vps.sh root@<IP>:/root/
ssh root@<IP> ./provision-vps.sh
```

> ⏱ O script leva de **3 a 10 minutos**, dependendo da velocidade da VPS.

### 2.2 Anote as informações de saída

Ao final, o script exibirá:

```
═══════════════════════════════════════════════════
         ✅  RUSTDESK — PROVISIONAMENTO CONCLUÍDO
═══════════════════════════════════════════════════

  📌 IP do servidor: 203.0.113.10
  🔑 Chave Pública:
  ====== CONFIG_STRING ======
  ...chave aqui...
  ===========================
```

**Salve a chave pública** — você precisará dela para configurar os clientes.

---

## Etapa 3: Verificar o Servidor

### 3.1 Containers rodando?

```bash
docker ps
```

Deverá ver dois containers: `hbbs` e `hbbr`, ambos com status `Up`.

### 3.2 Portas abertas?

```bash
ss -tulpn | grep -E '2111[5-9]'
```

Deverá ver as portas **21115** (TCP), **21116** (TCP + UDP), **21117** (TCP).

### 3.3 Logs sem erro?

```bash
docker logs hbbs --tail=10
docker logs hbbr --tail=10
```

Não deve conter mensagens de erro. Consulte [06-solucao-de-problemas.md](./06-solucao-de-problemas.md) se houver problemas.

### 3.4 Obter a chave novamente (se perdeu)

```bash
cat /opt/rustdesk-server/data/id_ed25519.pub
```

> ⚠️ **A chave nunca muda.** Se você perder, o arquivo está sempre neste caminho.

---

## Etapa 4: (Opcional) Expor com Cloudflare Tunnel

### Por que fazer?

Sem Cloudflare, seus clientes precisam do **IP público da VPS** para conectar.
Com Cloudflare Zero Trust + WARP, você ganha:
- **Criptografia ponta a ponta** (sobreposição ao TLS do RustDesk)
- **Sem expor portas** na internet
- **Domínio personalizado** (ex: `rd.minhaempresa.com`)
- **Firewall de rede** da Cloudflare (DDoS, bots, geoblocking)

### Método recomendado: Zero Trust + WARP

É o **único método gratuito** que suporta UDP (essencial para heartbeat do RustDesk).

**Passos — detalhes completos em:** [07-cloudflare-tunnel.md](./07-cloudflare-tunnel.md)

1. Crie conta Cloudflare Zero Trust
2. Instale cloudflared no servidor (ou use `compose-cloudflared.yml`)
3. Crie um Tunnel e associe à rede privada
4. Instale WARP nos clientes e ative para a rede da sua equipe

```bash
# Iniciar cloudflared com Docker Compose:
docker compose -f compose-cloudflared.yml up -d
```

> ⚠️ **Importante:** O Cloudflare Tunnel gratuito (**não** o WARP) **não proxy UDP**,
> portanto a porta 21116/UDP não funcionaria. A combinação Zero Trust + WARP
> resolve isso criando uma rede privada overlay.

### Outros métodos

| Método | Documentação | Custo | UDP? |
|---|---|---|---|
| **A) Zero Trust + WARP** | [07-cloudflare.md](./07-cloudflare-tunnel.md) | Grátis (50 usuários) | ✅ |
| B) Web Client (navegador) | [07-cloudflare.md](./07-cloudflare-tunnel.md) | Grátis | ❌ |
| C) DNS Only (IP direto) | [07-cloudflare.md](./07-cloudflare-tunnel.md) | Grátis | ✅ |
| D) Spectrum | [07-cloudflare.md](./07-cloudflare-tunnel.md) | Enterprise | ✅ |
| **Tailscale Free** | [10-estudo-custo.md](./10-estudo-custo-beneficio.md) | Grátis (3 users) | ✅ |

---

## Etapa 5: Deploy nos Clientes

### 5.1 Escolha o método de deploy

| Cenário | Método | Documentação |
|---|---|---|
| **Um computador** (manual) | Configurar manualmente no app | [11-manual-operacional.md](./11-manual-operacional-cliente.md#8-configurando-para-usar-o-servidor-da-empresa) |
| **Vários Windows** (deploy) | Script PowerShell | [scripts/deploy-client-windows.ps1](../scripts/deploy-client-windows.ps1) |
| **Vários Linux** (deploy) | Script shell | [scripts/deploy-client-linux.sh](../scripts/deploy-client-linux.sh) |
| **Vários macOS** (deploy) | Script shell | [scripts/deploy-client-macos.sh](../scripts/deploy-client-macos.sh) |
| **Deploy em massa** (GPO, MDM) | AD / Gerenciador de tarefas | [04-deployment-clientes.md](./04-deployment-clientes.md) |

### 5.2 Informações necessárias para configurar

- **IP do servidor** (ou domínio, se usou Cloudflare WARP)
- **Chave pública** (obtida na Etapa 3)
- **Senha permanente** (opcional — para acesso sem supervisão)

### 5.3 Deploy rápido via scripts

**Windows** (PowerShell como Administrador):
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/hsoservicos/myrustdesk/main/scripts/deploy-client-windows.ps1'))
```

**Linux**:
```bash
curl -sS https://raw.githubusercontent.com/hsoservicos/myrustdesk/main/scripts/deploy-client-linux.sh | sudo bash
```

**macOS**:
```bash
curl -sS https://raw.githubusercontent.com/hsoservicos/myrustdesk/main/scripts/deploy-client-macos.sh | sudo bash
```

> Os scripts detectam automaticamente a arquitetura, baixam a versão mais recente,
> instalam, configuram o servidor e definem senha aleatória.

### 5.4 Configuração manual

Para configurar manualmente em cada dispositivo, consulte o
**[Manual Operacional do Cliente](./11-manual-operacional-cliente.md)** com
instruções passo a passo para Windows, macOS, Linux, Android, iOS e Web.

---

## Etapa 6: Testar e Usar

### 6.1 Teste local (mesma rede)

Em um computador com o cliente configurado: veja se o **ID do dispositivo**
aparece e se o status mostra "Pronto" / "Conectado ao servidor".

### 6.2 Teste remoto

De outra rede (ex: 4G do celular), tente conectar em um computador da empresa.
Se configurou Cloudflare WARP, ative o WARP no dispositivo antes de conectar.

### 6.3 Verifique o relay

Se a conexão direta falhar, o RustDesk usa o relay (hbbr) automaticamente.
Consulte [06-solucao-de-problemas.md](./06-solucao-de-problemas.md) se:
- O ID não aparece
- A conexão cai após alguns segundos
- Velocidade muito baixa

---

## Manutenção Contínua

| Tarefa | Frequência | Como fazer |
|---|---|---|
| Atualizar containers | Semanal (automático) | Timer systemd criado pelo provision-vps.sh |
| Atualizar SO | Automático | unattended-upgrades configurado |
| Verificar logs | Mensal | `docker logs hbbs --tail=20` |
| Backup (snapshot) | Mensal | Painel do provedor VPS |
| Verificar tráfego | Mensal | Painel do provedor |

Consulte **[05-manutencao.md](./05-manutencao.md)** para detalhes.

---

## Referência Rápida de Documentos

| Documento | O que cobre |
|---|---|
| [01-arquitetura.md](./01-arquitetura.md) | Topologia, portas, fluxo de conexão |
| [02-instalacao-servidor.md](./02-instalacao-servidor.md) | 4 métodos de instalação manual |
| [03-configuracao-clientes.md](./03-configuracao-clientes.md) | Config manual de clientes |
| [04-deployment-clientes.md](./04-deployment-clientes.md) | Deploy em massa (GPO, script, task) |
| [05-manutencao.md](./05-manutencao.md) | Atualização, backup, logs |
| [06-solucao-de-problemas.md](./06-solucao-de-problemas.md) | Troubleshooting por sintoma |
| [07-cloudflare-tunnel.md](./07-cloudflare-tunnel.md) | Exposição externa (4 métodos) |
| [08-hardware.md](./08-hardware.md) | Dimensionamento de hardware |
| [09-vps.md](./09-vps.md) | 14 provedores, tabelas, contratação |
| [10-estudo-custo-beneficio.md](./10-estudo-custo-beneficio.md) | 5 perfis, 6 métodos, 3 licenças |
| [11-manual-operacional-cliente.md](./11-manual-operacional-cliente.md) | Manual do usuário final (7 plataformas) |

---

