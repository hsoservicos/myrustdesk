# Fluxo de Implantação — Visão Geral

> **Público:** Coordenadores e tomadores de decisão
> **Tempo estimado:** 2 a 4 horas (com ambos os guias)
> **Custo mínimo:** US$ 0 a ~R$ 23/mês

Este documento é um **mapa geral** do processo de implantação. Cada etapa tem
um guia detalhado próprio para o colaborador que vai executar a instalação.

---

## O Fluxo Completo

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│    ┌──────────────────────┐                                     │
│    │  1. IMPLANTAÇÃO VPS  │  ← Guia detalhado: 13-implantacao-vps.md │
│    │  (contratar, rodar   │                                     │
│    │   script, verificar) │                                     │
│    └──────────┬───────────┘                                     │
│               ▼                                                  │
│    ┌──────────────────────┐                                     │
│    │  2. IMPLANTAÇÃO      │  ← Guia detalhado: 14-implantacao-cloudflare.md │
│    │     CLOUDFLARE       │                                     │
│    │  (túnel, WARP,       │                                     │
│    │   testar)            │                                     │
│    └──────────┬───────────┘                                     │
│               ▼                                                  │
│    ┌──────────────────────┐                                     │
│    │  3. CONFIGURAR       │  ← Guia: 11-manual-operacional-cliente.md │
│    │     CLIENTES         │                                     │
│    │  (Windows, Mac,      │                                     │
│    │   Linux, celular)    │                                     │
│    └──────────────────────┘                                     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Etapa 1: Servidor na VPS

**O que fazer:** Contratar um servidor na nuvem e instalar o RustDesk nele.

**Guia completo (para o instalador):**
👉 **[13-implantacao-vps.md](13-implantacao-vps.md)**

**Neste guia, o instalador aprenderá:**
- O que é uma VPS (explicado para leigos)
- Qual provedor escolher (Oracle, KingHost, Hostinger, Hetzner)
- Como contratar passo a passo
- Como acessar o servidor pela primeira vez
- Como executar o script de instalação
- Como verificar se está funcionando
- O que fazer em caso de problemas

> ⏱ Tempo estimado: 30 a 60 minutos.

---

## Etapa 2: Túnel Cloudflare (acesso externo)

**O que fazer:** Configurar o Cloudflare Tunnel para acessar o RustDesk de
qualquer lugar (casa, celular, outro país).

**Guia completo (para o instalador):**
👉 **[14-implantacao-cloudflare.md](14-implantacao-cloudflare.md)**

**Neste guia, o instalador aprenderá:**
- O que é Cloudflare (explicado para leigos)
- Por que precisamos do WARP (para funcionar com UDP)
- Como criar uma conta Cloudflare
- Como configurar o domínio
- Como criar o túnel Zero Trust
- Como instalar o cloudflared no servidor
- Como instalar o WARP nos computadores
- Como testar a conexão remota

> ⏱ Tempo estimado: 30 a 60 minutos.

---

## Etapa 3: Configurar os Clientes

**O que fazer:** Instalar o RustDesk nos computadores da empresa e configurar
para usar o servidor próprio.

**Guia completo (para o usuário final):**
👉 **[11-manual-operacional-cliente.md](11-manual-operacional-cliente.md)**

**Neste manual, o usuário aprenderá:**
- Instalação no Windows (passo a passo)
- Instalação no macOS
- Instalação no Linux
- Instalação no Android e iPhone
- Como configurar o servidor da empresa
- Como usar o RustDesk (conectar, transferir arquivos)
- Como resolver problemas comuns

> ⏱ Tempo por computador: 5 a 10 minutos.

---

## Documentação Técnica Adicional

Para consulta do suporte técnico ou administradores experientes:

| Documento | O que cobre |
|---|---|
| [07-cloudflare-tunnel.md](07-cloudflare-tunnel.md) | 4 métodos técnicos de exposição Cloudflare |
| [09-vps.md](09-vps.md) | Análise completa de 14 provedores VPS |
| [10-estudo-custo-beneficio.md](10-estudo-custo-beneficio.md) | Estudo de custos por perfil de uso |
| [08-hardware.md](08-hardware.md) | Dimensionamento de servidor |
| [05-manutencao.md](05-manutencao.md) | Rotinas de manutenção técnica |
| [06-solucao-de-problemas.md](06-solucao-de-problemas.md) | Troubleshooting avançado |

---

## Resumo para o Coordenador

| Etapa | Guia | Quem executa | Tempo |
|---|---|---|---|
| 1. Contratar VPS + instalar RustDesk | [13-implantacao-vps.md](13-implantacao-vps.md) | Instalador | 30–60 min |
| 2. Configurar Cloudflare + WARP | [14-implantacao-cloudflare.md](14-implantacao-cloudflare.md) | Instalador | 30–60 min |
| 3. Configurar clientes | [11-manual-operacional-cliente.md](11-manual-operacional-cliente.md) | Usuário final | 5–10 min cada |

> 💡 **Ordem recomendada:** Faça a Etapa 1 primeiro, depois a Etapa 2,
> e por último a Etapa 3 em cada computador.
