<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://rustdesk.com/logo.svg">
    <img src="https://rustdesk.com/logo.svg" alt="RustDesk" width="200">
  </picture>
</p>

<h1 align="center">RustDesk Server OSS — Self-Hosted Infrastructure</h1>

<p align="center">
  <strong>Implante seu próprio servidor de acesso remoto</strong> — elimine dependência de servidores públicos,
  tenha controle total sobre suas conexões.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Docker-compose-blue?logo=docker" alt="Docker">
  <img src="https://img.shields.io/badge/Ubuntu-22.04%2F24.04-orange?logo=ubuntu" alt="Ubuntu">
  <img src="https://img.shields.io/badge/Debian-12-red?logo=debian" alt="Debian">
  <img src="https://img.shields.io/badge/Cloudflare-WARP-f38020?logo=cloudflare" alt="Cloudflare">
  <img src="https://img.shields.io/badge/RustDesk-1.3.x-8bc0d0" alt="RustDesk">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
</p>

---

## Visão Geral

Este projeto fornece **infraestrutura completa** para implantação do servidor
[RustDesk](https://rustdesk.com) OSS em modo self-hosted — seja em uma máquina
local, numa VPS na nuvem, ou atrás de um túnel Cloudflare.

Inclui:

- **Orquestração Docker** pronta (`compose.yml`) para hbbs + hbbr
- **Manual completo** para iniciantes absolutos
- **Scripts de deploy** para servidor e clientes (Windows, Linux, macOS)
- **Guia VPS** com 14 provedores analisados e comparados
- **Cloudflare Tunnel + WARP** para exposição externa segura
- **Provisionamento automatizado** do zero na VPS
- **Fluxo único de implantação** — 6 etapas para sair do zero
- **CI integrado** — validação de sintaxe de todos os scripts

---

## Funcionalidades

- **🔒 Privacidade total** — seus dados nunca passam por servidores de terceiros
- **⚡ Self-hosted** — controle total sobre o servidor de sinalização e relay
- **🐳 Docker Compose** — deploy em segundos com `docker compose up -d`
- **📦 Script automático** — setup-server.sh instala Docker, firewall e containers
- **🖥️ Deploy em massa** — scripts prontos para configurar centenas de clientes
- **☁️ Multi-nuvem** — guia com 14 provedores VPS globais e nacionais
- **🛡️ Cloudflare WARP** — exposição externa gratuita com suporte a UDP
- **📘 Manual para leigos** — passo a passo desde "o que é uma VPS" até "cliente conectado"
- **🔧 Provisionamento completo** — SSH hardening, fail2ban, unattended-upgrades, swap
- **🗺️ Fluxo único de implantação** — visão geral + guias separados para VPS e Cloudflare
- **📖 Guias para leigos** — documentação específica para instaladores sem experiência em TI
- **✅ CI integrado** — validação automática de sintaxe de todos os scripts

---

## Arquitetura

```
┌─────────────────────────────────────────────────────────────────┐
│                        Servidor RustDesk                        │
│                                                                 │
│   ┌──────────┐                    ┌──────────┐                  │
│   │   hbbs   │  TCP 21114-21116   │   hbbr   │                  │
│   │  (ID/R)  │◄──────────────────►│  (Relay) │                  │
│   │          │  UDP 21116         │          │                  │
│   └────┬─────┘                    └────┬─────┘                  │
│        │                               │                        │
│        └───────────┬───────────────────┘                        │
│                    │                                            │
│        ┌───────────▼────────────┐                               │
│        │    Cliente remoto      │                               │
│        │  (hbbs descobre ID,    │                               │
│        │   hbbr relay tráfego)  │                               │
│        └────────────────────────┘                               │
└─────────────────────────────────────────────────────────────────┘
```

| Componente | Função | Portas |
|---|---|---|
| **hbbs** | Servidor de ID / Registro / Sinalização | TCP 21114–21116, 21118 |
| | | UDP 21116 (heartbeat/ID) |
| **hbbr** | Servidor de Retransmissão (Relay) | TCP 21117, 21119 |

> O cliente RustDesk primeiro contata o **hbbs** para se registrar e descobrir
> o endpoint do relay. O tráfego de tela/arquivos passa pelo **hbbr**, que pode
> estar no mesmo servidor ou em outro.

---

## Início Rápido

### Pré-requisitos

- Servidor Linux (Ubuntu 22.04/24.04 ou Debian 12)
- Acesso root ou sudo
- Git instalado

### Opção 1 — Script Automático (recomendado)

```bash
git clone https://github.com/hsoservicos/myrustdesk.git
cd myrustdesk
sudo ./scripts/setup-server.sh
```

O script instala Docker + Compose, configura UFW, inicia os containers e exibe
a chave pública. Tudo automático.

### Opção 2 — Manual com Docker Compose

```bash
# Clone o repositório
git clone https://github.com/hsoservicos/myrustdesk.git
cd myrustdesk

# Inicie os servidores
sudo docker compose up -d

# Obtenha a chave pública para configurar os clientes
sudo cat ./rustdesk-data/id_ed25519.pub
```

### Opção 3 — Provisionamento Completo de VPS

```bash
# Em uma VPS recém-contratada (Ubuntu 22.04+):
sudo ./scripts/provision-vps.sh
```

Este script faz tudo: cria usuário não-root, hardening SSH, Docker, UFW,
fail2ban, unattended-upgrades, swap (se RAM ≤ 2 GB), containers RustDesk
e timer semanal de manutenção.

### Guias Passo a Passo para Instaladores Iniciantes

| Guia | O que cobre |
|---|---|
| 👉 [`docs/13-implantacao-vps.md`](docs/13-implantacao-vps.md) | Contratar VPS → executar script → verificar — explicado para quem nunca fez isso |
| 👉 [`docs/14-implantacao-cloudflare.md`](docs/14-implantacao-cloudflare.md) | Criar conta Cloudflare → configurar túnel → instalar WARP — passo a passo |
| 👉 [`docs/12-fluxo-implantacao.md`](docs/12-fluxo-implantacao.md) | Visão geral dos 3 fluxos para coordenadores |

---

## Documentação

| Documento | Para quem | O que cobre |
|---|---|---|
| [`MANUAL_IMPLANTACAO.md`](MANUAL_IMPLANTACAO.md) | Iniciantes | Passo a passo completo, do zero ao cliente conectado — não precisa saber Linux |
| [`docs/01-arquitetura.md`](docs/01-arquitetura.md) | Técnicos | Topologia, fluxo de conexão, portas, protocolos |
| [`docs/02-instalacao-servidor.md`](docs/02-instalacao-servidor.md) | Técnicos | Instalação manual detalhada (Docker + nativo) |
| [`docs/03-configuracao-clientes.md`](docs/03-configuracao-clientes.md) | Todos | Configuração manual de clientes Windows/Linux/macOS/Android/iOS |
| [`docs/04-deployment-clientes.md`](docs/04-deployment-clientes.md) | Sysadmin | Deploy em massa via GPO, MDM, scripts |
| [`docs/05-manutencao.md`](docs/05-manutencao.md) | Sysadmin | Atualizações, backup, logs, monitoramento |
| [`docs/06-solucao-de-problemas.md`](docs/06-solucao-de-problemas.md) | Todos | Troubleshooting organizado por sintoma |
| [`docs/07-cloudflare-tunnel.md`](docs/07-cloudflare-tunnel.md) | Técnicos | ★ Exposição externa: 4 métodos Cloudflare (recomendado: WARP) |
| [`docs/08-hardware.md`](docs/08-hardware.md) | Tomadores de decisão | Dimensionamento de hardware para 4 cenários |
| [`docs/09-vps.md`](docs/09-vps.md) | Tomadores de decisão | ★ Guia completo: 14 provedores, tabelas, matriz de decisão, passo a passo de contratação |
| [`docs/10-estudo-custo-beneficio.md`](docs/10-estudo-custo-beneficio.md) | Tomadores de decisão | ★ Estudo custo-benefício: 6 métodos de exposição, 3 licenças, alternativas gerenciadas |
| [`docs/11-manual-operacional-cliente.md`](docs/11-manual-operacional-cliente.md) | Usuários finais | ★ Manual completo: instalação em 7 plataformas, configuração, uso, troubleshooting |
| [`docs/12-fluxo-implantacao.md`](docs/12-fluxo-implantacao.md) | Coordenadores | ★ Visão geral dos 3 fluxos: VPS → Cloudflare → Clientes |
| [`docs/13-implantacao-vps.md`](docs/13-implantacao-vps.md) | Instaladores (iniciantes) | ★ Guia VPS: contratar → provisionar → verificar — passo a passo para leigos |
| [`docs/14-implantacao-cloudflare.md`](docs/14-implantacao-cloudflare.md) | Instaladores (iniciantes) | ★ Guia Cloudflare: túnel → WARP → testar — passo a passo para leigos |
| [`docs/15-auditoria-aplicativos.md`](docs/15-auditoria-aplicativos.md) | Todos | ★ Auditoria dos apps baixados + links oficiais v1.4.7 |

---

## Scripts Disponíveis

| Script | Função |
|---|---|
| [`scripts/setup-server.sh`](scripts/setup-server.sh) | Implantação automática do servidor (Docker + UFW + containers) |
| [`scripts/provision-vps.sh`](scripts/provision-vps.sh) | Provisionamento completo de VPS (usuário, SSH, Docker, fail2ban, swap) |
| [`scripts/deploy-client-windows.ps1`](scripts/deploy-client-windows.ps1) | Deploy em massa para Windows (PowerShell) |
| [`scripts/deploy-client-linux.sh`](scripts/deploy-client-linux.sh) | Deploy em massa para Linux |
| [`scripts/deploy-client-macos.sh`](scripts/deploy-client-macos.sh) | Deploy em massa para macOS |

## Manual do Cliente

Para usuários finais e operadores sem conhecimento técnico:

👉 [`docs/11-manual-operacional-cliente.md`](docs/11-manual-operacional-cliente.md)

Cobre instalação, configuração e uso em **todas as plataformas** (Windows, macOS,
Linux, Android, iOS e Web), com linguagem acessível, glossário e solução de problemas.

---

## Acesso Externo — Cloudflare

Para usar o RustDesk fora da rede local (acesso remoto verdadeiro), você precisa
expor o servidor. O método **recomendado** é o **Cloudflare Zero Trust + WARP**:

| Método | Custo | UDP | TCP | Recomendado? |
|---|---|---|---|---|
| **Zero Trust + WARP** | Gratuito (50 usuários) | ✅ | ✅ | **⭐ Método A** |
| Cloudflare Tunnel (DNS Only) | Gratuito | ❌ | ✅ | Alternativa limitada |
| Cloudflare Spectrum | US$ 200/mês | ✅ | ✅ | Empresarial |
| Porta direta (DDNS + firewall) | Zero | ✅ | ✅ | Avançado |

> ⚠️ O túnel gratuito do Cloudflare **não suporta UDP**. O RustDesk depende
> da porta UDP 21116 para heartbeat/ID. A única forma gratuita de expor UDP
> via Cloudflare é usando o **WARP** (túnel WireGuard na camada de rede).

👉 Guia completo: [`docs/07-cloudflare-tunnel.md`](docs/07-cloudflare-tunnel.md)

---

## Escolhendo um Provedor VPS

Analisamos 14 provedores para você escolher o melhor custo-benefício:

| Perfil | Recomendação | Custo |
|---|---|---|
| Testar (custo zero) | Oracle Cloud Free Tier (24 GB RAM!) | **US$ 0** |
| Pessoal — melhor custo | **Hetzner CAX11** (4 GB, NVMe) | **~US$ 4/mês** |
| Pessoal — suporte em PT | **Hostinger KVM 1** (4 GB, NVMe) | **~US$ 6,50/mês** |
| Datacenter Brasil | **KingHost** (1-4 GB, SSD) | ~US$ 5-10/mês |
| Brasil — custo-benefício | **Hostinger BR KVM 1** (4 GB, NVMe) | **R$ 29,99/mês** |
| Equipe — AWS Brasil | **Lightsail $7** (1 GB, SP) | US$ 7/mês |

👉 Guia completo com tabelas, benchmarks e passo a passo de contratação:
[`docs/09-vps.md`](docs/09-vps.md)

---

## Estrutura do Repositório

```
myrustdesk/
├── README.md                         # Este arquivo
├── MANUAL_IMPLANTACAO.md             # ★ Manual completo para iniciantes
├── .github/
│   └── workflows/
│       └── syntax-checks.yml         # CI: ShellCheck + PSScriptAnalyzer + yamllint
├── compose.yml                       # Orquestração Docker (hbbs + hbbr)
├── compose-cloudflared.yml           # Orquestração Docker (cloudflared)
├── .env                              # Variáveis de ambiente
├── docs/
│   ├── 01-arquitetura.md             # Topologia e fluxo de conexão
│   ├── 02-instalacao-servidor.md     # Instalação detalhada
│   ├── 03-configuracao-clientes.md   # Configuração manual de clientes
│   ├── 04-deployment-clientes.md     # Deploy em massa
│   ├── 05-manutencao.md              # Atualizações, backup, logs
│   ├── 06-solucao-de-problemas.md    # Troubleshooting
│   ├── 07-cloudflare-tunnel.md       # ★ Exposição via Cloudflare
│   ├── 08-hardware.md                # ★ Dimensionamento de hardware
│   ├── 09-vps.md                     # ★ Guia de 14 provedores VPS
│   ├── 10-estudo-custo-beneficio.md  # ★ Estudo custo-benefício acesso externo
│   ├── 11-manual-operacional-cliente.md # ★ Manual operacional do cliente
│   ├── 12-fluxo-implantacao.md       # ★ Visão geral: fluxo de implantação
│   ├── 13-implantacao-vps.md         # ★ Guia VPS para leigos
│   ├── 14-implantacao-cloudflare.md  # ★ Guia Cloudflare para leigos
│   └── 15-auditoria-aplicativos.md   # ★ Auditoria de apps + links oficiais
└── scripts/
    ├── provision-vps.sh              # ★ Provisionamento automático de VPS
    ├── setup-server.sh               # ★ Implantação do servidor
    ├── deploy-client-windows.ps1     # Deploy cliente Windows
    ├── deploy-client-linux.sh        # Deploy cliente Linux
    └── deploy-client-macos.sh        # Deploy cliente macOS
```

---

## Requisitos de Hardware

| Cenário | Dispositivos | vCPU | RAM | Disco |
|---|---|---|---|---|
| Uso pessoal / família | 1–10 | 1 | 512 MB–1 GB | 5 GB |
| Pequena equipe | 10–50 | 2 | 2 GB | 10 GB |
| Média empresa | 50–200 | 2 | 4 GB | 20 GB |
| Grande escala | 200+ | 4 | 8 GB | 40 GB |

> 📊 Consumo real de referência: servidor público oficial do RustDesk atende
> **mais de 1 milhão de endpoints** com apenas **2 vCPU e 4 GB RAM**.

👉 Guia completo: [`docs/08-hardware.md`](docs/08-hardware.md)

---

## Segurança

- **Firewall (UFW):** apenas portas 21115–21117 abertas
- **Fail2ban:** proteção contra força bruta SSH
- **SSH hardening:** autenticação por chave, desabilitação de root login
- **Unattended-upgrades:** atualizações de segurança automáticas
- **Criptografia fim-a-fim:** RustDesk usa criptografia nativa nas conexões
- **Cloudflare WARP:** túnel WireGuard sem expor portas na rede

Tudo configurável via [`scripts/provision-vps.sh`](scripts/provision-vps.sh).

---

## Tecnologias

- [RustDesk Server OSS](https://github.com/rustdesk/rustdesk-server) — Servidor de acesso remoto
- [Docker](https://docker.com) + [Compose V2](https://docs.docker.com/compose/) — Orquestração de containers
- [Cloudflare](https://cloudflare.com) — Zero Trust, WARP, Tunnel
- [Ubuntu](https://ubuntu.com) / [Debian](https://debian.org) — Sistemas-alvo
- [UFW](https://wiki.ubuntu.com/UncomplicatedFirewall) — Gerenciamento de firewall
- [Fail2ban](https://www.fail2ban.org) — Proteção contra intrusão

---

## Como Contribuir

Contribuições são bem-vindas!

1. **Issues:** reporte bugs, sugira melhorias, tire dúvidas
2. **Pull Requests:** correções, novos scripts, documentação adicional

Antes de abrir um PR, verifique a sintaxe dos scripts:

```bash
bash -n scripts/*.sh                 # Validação de sintaxe Bash
pwsh -c "Get-Command scripts/*.ps1"  # Validação PowerShell
```

O CI ([`.github/workflows/syntax-checks.yml`](.github/workflows/syntax-checks.yml))
executa automaticamente ShellCheck, PSScriptAnalyzer e yamllint em cada push/PR.

---

## Roadmap

- [x] Docker Compose para hbbs + hbbr
- [x] Script automático de implantação
- [x] Guia Cloudflare Tunnel + WARP
- [x] Guia de hardware (4 cenários)
- [x] Guia VPS com 14 provedores
- [x] Script de provisionamento de VPS
- [x] Deploy scripts para clientes (Win/Lin/macOS)
- [x] Manual completo para iniciantes
- [x] Fluxo unificado VPS → provisionar → Cloudflare → deploy clientes
- [x] CI com testes de sintaxe (ShellCheck + PSScriptAnalyzer + yamllint)
- [ ] Suporte a Docker Compose com rede bridge (alternativa a host)
- [ ] Template de configuração Ansible

---

## Licença

Este projeto é distribuído sob a licença **MIT**. Consulte o arquivo `LICENSE`
para mais detalhes.

O RustDesk Server OSS é distribuído sob a [licença AGPL-3.0](https://github.com/rustdesk/rustdesk-server/blob/master/LICENSE).

---

## Links Oficiais

- [RustDesk](https://rustdesk.com) — Site oficial
- [RustDesk Self-Host Docs](https://rustdesk.com/docs/en/self-host/) — Documentação oficial
- [rustdesk-server (GitHub)](https://github.com/rustdesk/rustdesk-server) — Código-fonte do servidor
- [Docker Setup](https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/docker/) — Setup oficial Docker
- [Cloudflare Zero Trust](https://www.cloudflare.com/zero-trust/) — Solução de acesso externo

---

