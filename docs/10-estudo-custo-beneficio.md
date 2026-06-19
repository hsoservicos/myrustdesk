# Estudo de Custo-Benefício — RustDesk Server para Acesso Externo

> **Data:** Junho 2026
> **Versão RustDesk:** 1.4.7 (server) / 1.4.7 (client)
> **Propósito:** Auxiliar na escolha da melhor combinação de servidor,
> método de exposição externa e plano de licenciamento para cada perfil de uso.

---

## Sumário

1. [Cenários de Uso](#1-cenários-de-uso)
2. [Opções de Licenciamento](#2-opções-de-licenciamento)
3. [Métodos de Exposição Externa](#3-métodos-de-exposição-externa)
4. [Tabela Comparativa Completa](#4-tabela-comparativa-completa)
5. [Análise por Perfil](#5-análise-perfil)
6. [Custos Ocultos e Riscos](#6-custos-ocultos-e-riscos)
7. [Recomendações Finais](#7-recomendações-finais)
8. [Fluxo de Decisão](#8-fluxo-de-decisão)

---

## 1. Cenários de Uso

| # | Perfil | Dispositivos | Usuários | Orçamento mensal |
|---|---|---|---|---|
| A | Uso pessoal / família | 1–10 | 1–3 | US$ 0–6 |
| B | Profissional autônomo (suporte) | 10–30 | 1 | US$ 6–15 |
| C | Pequena empresa / equipe | 30–100 | 2–10 | US$ 15–30 |
| D | MSP / empresa em crescimento | 100–500 | 5–20 | US$ 30–80 |
| E | Grande empresa / compliance | 500+ | 10+ | US$ 80+ |

---

## 2. Opções de Licenciamento

### 2.1 RustDesk Server OSS (Gratuito)

| Característica | OSS |
|---|---|
| **Preço** | **US$ 0** |
| hbbs + hbbr | ✅ |
| Conexões simultâneas | Ilimitadas |
| Dispositivos gerenciados | Ilimitados |
| Console web | ❌ |
| Catálogo de endereços | ❌ |
| Gerenciamento de dispositivos | ❌ |
| Multi-relay automático | ❌ |
| OIDC / LDAP / 2FA | ❌ |
| Cliente personalizado | ❌ |
| Suporte | Comunidade (GitHub/Discord) |
| Atualizações | Manuais (Docker pull) |

### 2.2 RustDesk Server Pro (Pago)

| Característica | Individual | Basic | Customized |
|---|---|---|---|
| **Preço/mês (anual)** | **US$ 9,90** | **US$ 19,90** | **US$ 19,90 + variável** |
| Usuários logados | 1 | 10 | 10+ (US$ 1/user) |
| Dispositivos | 20 | 100 | 100+ (US$ 0,10/dev) |
| Console web | ✅ | ✅ | ✅ |
| Catálogo de endereços | ✅ | ✅ | ✅ |
| Gerenciamento de dispositivos | ✅ | ✅ | ✅ |
| 2FA | ✅ | ✅ | ✅ |
| OIDC / LDAP | ❌ | ✅ | ✅ |
| Cliente personalizado | ❌ | ✅ | ✅ |
| WebSocket / Web Client | ❌ | ❌ | ✅ (+US$ 39,90) |
| Suporte | Email | Email | Email |

> **Nota:** A licença é vinculada ao servidor `hbbs`, não ao `hbbr`. Múltiplos relays
> não exigem licenças adicionais. Renovação é anual — não há plano mensal avulso.

### 2.3 Alternativas Gerenciadas (Fork)

| Serviço | Preço | Modelo | Diferencial |
|---|---|---|---|
| [GoDesk](https://godeskflow.com) | US$ 2,99/mês (Lite) | Relay gerenciado | Zero setup, suporte, SLA |
| [SoftAcesso](https://softacesso.com) | R$ 29/mês | Relay gerenciado BR | Português, PIX, servidor Brasil |
| [RDP.sh](https://rdp.sh) | US$ 5–15/mês | Relay gerenciado | Setup em 1 clique |

> Alternativas gerenciadas eliminam a necessidade de operar servidor próprio,
> com custo tipicamente inferior ao tempo de manutenção de um servidor self-hosted.

---

## 3. Métodos de Exposição Externa

### Método A — Porta Direta (VPS com IP Público)

**Como funciona:** O servidor RustDesk é instalado em uma VPS com IP público.
As portas TCP/UDP 21115–21117 são abertas no firewall. Clientes apontam
diretamente para o IP ou domínio da VPS.

**Componentes:** VPS + Docker + UFW

| Prós | Contras |
|---|---|
| ✅ Mais simples de configurar | ❌ IP exposto — sujeito a scan e ataques |
| ✅ Latência mínima (sem camadas extras) | ❌ Portas abertas no firewall |
| ✅ Suporte nativo a UDP | ❌ Depende de provedor com IP público |
| ✅ Custo: apenas VPS | ❌ DDoS potencial sem proteção |

**Custo total:** US$ 4–7/mês (VPS Hetzner/Contabo/Hostinger)

---

### Método B — Cloudflare Zero Trust + WARP (Recomendado)

**Como funciona:** Cloudflare Tunnel + WARP Client criam uma rede privada
sobre WireGuard. O servidor RustDesk roda atrás do tunnel. Clientes
conectam via WARP (UDP suportado). Nenhuma porta precisa ser aberta.

**Componentes:** Cloudflare Zero Trust (gratuito) + WARP Client + Tunnel + VPS
ou servidor local

| Prós | Contras |
|---|---|
| ✅ Nenhuma porta exposta na internet | ❌ Necessário criar conta Cloudflare |
| ✅ WARP suporta UDP (obrigatório RustDesk) | ❌ WARP Client obrigatório nos clientes |
| ✅ Gratuito para até 50 usuários | ❌ Latência adicional do tunnel |
| ✅ DDoS protection nativa | ❌ Tráfego passa pela Cloudflare |
| ✅ Funciona atrás de CGNAT | ❌ Complexidade inicial de setup |

> ⚠️ O túnel gratuito (cloudflared) **não** suporta UDP. A porta 21116/UDP
> só funciona através do **WARP** (sobreposição WireGuard na camada de rede).
> Para todos os detalhes, consulte [`docs/07-cloudflare-tunnel.md`](07-cloudflare-tunnel.md).

**Custo total:** **US$ 0** (Cloudflare Free Tier) + VPS (US$ 0–7/mês)

---

### Método C — Tailscale / Headscale (VPN Mesh)

**Como funciona:** Tailscale cria uma rede mesh WireGuard entre todos os
dispositivos. O RustDesk roda em modo "Direct IP Access" — sem precisar
de servidor hbbs/hbbr. A conexão é P2P direta entre os dispositivos.

**Componentes:** Tailscale (gratuito 3 usuários, US$ 6/user/mês premium)
ou Headscale (self-hosted, gratuito)

| Prós | Contras |
|---|---|
| ✅ Elimina necessidade de servidor RustDesk | ❌ Plano grátis limitado a 3 usuários |
| ✅ Conexão P2P direta (menor latência) | ❌ Todos os dispositivos precisam de Tailscale |
| ✅ UDP nativo (WireGuard) | ❌ RustDesk ID/relay server não usado |
| ✅ Zero portas abertas | ❌ Headscale requer outro servidor |
| ✅ Nat traversal imbatível | ❌ Sem catálogo de endereços automático |
| ✅ Setup em minutos | ❌ Dependência de serviço externo (Tailscale) |

**Custo total:** US$ 0 (Tailscale free, 3 users) ou US$ 6/user/mês (Tailscale Premium)
ou US$ 4–7/mês (Headscale em VPS)

---

### Método D — Pangolin (Self-Hosted Tunnel + Reverse Proxy)

**Como funciona:** Pangolin (AGPL-3.0) executa em uma VPS e cria túneis
WireGuard outbound para redes privadas. Clientes acessam via browser
ou Pangolin Client. Suporta TCP/UDP. Substitui Cloudflare Tunnel.

**Componentes:** VPS + Pangolin (Docker) + Newt (tunnel client)

| Prós | Contras |
|---|---|
| ✅ 100% self-hosted (nenhum terceiro) | ❌ Precisa de VPS com IP público |
| ✅ WireGuard nativo (UDP suportado) | ❌ Setup inicial ~1h |
| ✅ Interface web + RBAC | ❌ Projeto mais novo (maturação) |
| ✅ Gratuito (AGPL-3.0) | ❌ Precisa de domínio + Let's Encrypt |
| ✅ Suporte a RDP/SSH/VNC via browser | ❌ Menos documentação que Cloudflare |
| ✅ Funciona atrás de CGNAT | ❌ Comunidade menor |

**Custo total:** US$ 4–7/mês (VPS) + US$ 0 (software) + US$ 0 (Let's Encrypt)

---

### Método E — Caddy TLS Termination (Porta 443)

**Como funciona:** Caddy termina TLS na porta 443 e faz proxy reverso
para hbbs/hbbr. Clientes se conectam via domínio com TLS.
UDP ainda precisa ser exposto separadamente.

**Componentes:** VPS + Docker + Caddy + Let's Encrypt

| Prós | Contras |
|---|---|
| ✅ Conexão TLS automática | ❌ UDP continua precisando de porta aberta |
| ✅ Supera firewalls restritivos (saída 443) | ❌ Complexidade adicional de configuração |
| ✅ Certificados automáticos | ❌ Caddy reverse_proxy TCP é experimental |
| ✅ Custo zero de licenciamento | ❌ Pode exigir stunnel/HAProxy como fallback |

**Custo total:** US$ 4–7/mês (VPS) + US$ 0 (Caddy + Let's Encrypt)

---

### Método F — Roteamento Direto CGNAT (Sem IP Público)

**Como funciona:** Usa um servidor Linux como jump box com relay RustDesk.
O jump box tem IP público. Clientes atrás de CGNAT se conectam via relay.
Indicado quando o provedor de internet não fornece IP público.

**Componentes:** VPS (jump box) + RustDesk hbbs/hbbr

| Prós | Contras |
|---|---|
| ✅ Única opção quando ISP usa CGNAT | ❌ Relay sempre usado (nunca P2P) |
| ✅ Setup simples | ❌ Maior latência (tráfego sempre via relay) |
| ✅ Custo baixo | ❌ Consumo de banda do relay |
| ✅ Documentado e testado | ❌ Dependência 100% do relay |

**Custo total:** US$ 4–7/mês (VPS)

---

## 4. Tabela Comparativa Completa

### 4.1 Custo Total Estimado (12 meses)

| Método | VPS (12m) | Licença | Software | Manutenção\* | **Total 12m** |
|---|---|---|---|---|---|
| **A — Porta direta (OSS)** | US$ 60 | US$ 0 | US$ 0 | US$ 0 | **US$ 60** |
| **A — Porta direta (Pro Individual)** | US$ 60 | US$ 119 | US$ 0 | US$ 0 | **US$ 179** |
| **A — Porta direta (Pro Basic)** | US$ 60 | US$ 239 | US$ 0 | US$ 0 | **US$ 299** |
| **B — Cloudflare WARP (OSS)** | US$ 0–60 | US$ 0 | US$ 0 | US$ 0 | **US$ 0–60** |
| **B — Cloudflare WARP (Pro Individual)** | US$ 0–60 | US$ 119 | US$ 0 | US$ 0 | **US$ 119–179** |
| **C — Tailscale Free (3 users)** | US$ 0 | US$ 0 | US$ 0 | US$ 0 | **US$ 0** |
| **C — Tailscale Premium (5 users)** | US$ 0 | US$ 360 | US$ 0 | US$ 0 | **US$ 360** |
| **C — Headscale (self-hosted)** | US$ 60 | US$ 0 | US$ 0 | US$ 0 | **US$ 60** |
| **D — Pangolin (self-hosted)** | US$ 60 | US$ 0 | US$ 0 | US$ 0 | **US$ 60** |
| **E — Caddy TLS** | US$ 60 | US$ 0 | US$ 0 | US$ 0 | **US$ 60** |
| **GoDesk (gerenciado)** | US$ 0 | US$ 36 | US$ 0 | US$ 0 | **US$ 36** |
| **SoftAcesso (gerenciado BR)** | US$ 0 | R$ 348 | US$ 0 | US$ 0 | **R$ 348** |

> \* Manutenção considerada **US$ 0** para operadores experientes. Para
> profissionais sem experiência em Linux, adicione 1–2h/mês (~US$ 20–80/mês).
>
> Preços do RustDesk Pro são anuais (Individual US$ 119/ano, Basic US$ 239/ano).

### 4.2 Comparativo Funcional

| Funcionalidade | A — Porta | B — CF WARP | C — Tail | D — Pangolin | E — Caddy |
|---|---|---|---|---|---|
| **Setup inicial** | ⭐ Rápido | 🔶 Médio | ⭐ Rápido | 🔶 Médio | 🔴 Complexo |
| **Conexão P2P direta** | ✅ | 🔶 Via WARP | ✅ | 🔶 Via relay | ✅ |
| **UDP (21116)** | ✅ | ✅ (WARP) | ✅ | ✅ | ❌ |
| **NAT traversal** | 🔶 Relay | ✅ | ✅ | ✅ | 🔶 Relay |
| **Sem portas abertas** | ❌ | ✅ | ✅ | ✅ | ❌ |
| **Zero trust / RBAC** | ❌ | ✅ | 🔶 ACLs | ✅ | ❌ |
| **Self-hosted 100%** | ✅ | ❌ (CF) | 🔶 (Headscale) | ✅ | ✅ |
| **Web client RustDesk** | 🔶 | 🔶 | ❌ | ✅ (proxy) | 🔶 |
| **Domínio próprio** | Opcional | ✅ | Opcional | ✅ | ✅ |
| **Custo mensal** | US$ 4–7 | US$ 0 | US$ 0–6/user | US$ 4–7 | US$ 4–7 |

### 4.3 Consumo de Banda do Relay

Quando o hole-punching falha e o relay é usado:

| Resolução | Codec | Bits/s (estimado) | Banda/mês (8h/dia) |
|---|---|---|---|
| 720p | VP8 | ~1 Mbps | ~108 GB |
| 1080p | VP9 | ~2 Mbps | ~216 GB |
| 4K | H.265 | ~5 Mbps | ~540 GB |

> Planos de VPS mais básicos (1 TB/mês) suportam de 4 a 5 sessões
> simultâneas em 1080p via relay. A maioria das conexões usa P2P,
> então o relay raramente é o gargalo.

---

## 5. Análise por Perfil

### Perfil A — Uso Pessoal / Família

**Necessidades:** 1–5 dispositivos, acesso ocasional, sem custo.

**Recomendação primária:** **Tailscale Free + RustDesk Direct IP**
- Custo: **US$ 0**
- Setup: instalar Tailscale em cada dispositivo, habilitar Direct IP no RustDesk
- Sem servidor, sem manutenção
- 3 usuários gratis — suficiente para família

**Alternativa:** Cloudflare WARP (se já usa Cloudflare)
- Custo: US$ 0
- Útil se já tem domínio e conta Cloudflare

> ✅ **Custo total 12 meses: US$ 0**

---

### Perfil B — Profissional Autônomo (Suporte Remoto)

**Necessidades:** 10–30 dispositivos de clientes, acesso confiável,
suporte remoto frequente.

**Recomendação primária:** **VPS Hetzner + OSS + Cloudflare WARP**
- VPS CAX11: ~US$ 4/mês
- Cloudflare Zero Trust (gratuito): tunnel + WARP
- Setup rápido com [`scripts/provision-vps.sh`](../scripts/provision-vps.sh)
- Mantém controle total sem expor portas

**Recomendação econômica:** **SoftAcesso (R$ 29/mês)**
- Se não quer gerenciar servidor
- Suporte em português, PIX
- Sem setup técnico

> ✅ **Custo total 12 meses: US$ 48–60** (self-hosted VPS + Cloudflare)
> ou **R$ 348** (SoftAcesso)

---

### Perfil C — Pequena Empresa / Equipe

**Necessidades:** 30–100 dispositivos, 2–10 usuários, catálogo de endereços,
registro de conexões.

**Recomendação primária:** **VPS + RustDesk Pro Basic**
- VPS: Hetzner CAX11 ou Hostinger KVM 1 (~US$ 4–7/mês)
- Licença Pro Basic: US$ 19,90/mês (anual)
- Exposição: Cloudflare WARP (recomendado) ou porta direta
- Total: US$ 24–27/mês

**Alternativa econômica:** **VPS + OSS + Cloudflare WARP**
- Sem console web, mas funcional
- Setup com [`provision-vps.sh`](../scripts/provision-vps.sh)
- Total: US$ 4–7/mês

> ✅ **Custo total 12 meses: US$ 288–324** (Pro Basic + VPS + WARP)

---

### Perfil D — MSP / Empresa em Crescimento

**Necessidades:** 100–500 dispositivos, 5–20 usuários, LDAP/OIDC,
clientes personalizados, multi-relay.

**Recomendação primária:** **VPS + RustDesk Pro Basic + múltiplos relays**
- VPS principal: Hetzner CX22 (~US$ 5/mês)
- Relays regionais: 1–3 VPS extras (~US$ 4–12/mês cada)
- Licença Pro Basic: US$ 19,90/mês (comporta até 100 dispositivos)
- Exposição: Cloudflare WARP ou porta direta com UFW restrito
- Client personalizado para deploy nos clientes

**Alternativa Pangolin:** **VPS + Pangolin + OSS**
- Se prefere zero trust autogerenciado
- Substitui Cloudflare no caminho
- RBAC + identidade próprios

> ✅ **Custo total 12 meses: US$ 360–600** (Pro Basic + VPS + relays)

---

### Perfil E — Grande Empresa / Compliance

**Necessidades:** 500+ dispositivos, compliance (LGPD, SOC2, ISO),
LDAP/OIDC, auditoria, suporte 24/7.

**Recomendação:** **RustDesk Pro Customized + Headscale + relay dedicado**
- Servidor dedicado ou VPS grande (Hetzner CX32, ~US$ 10/mês)
- Licença Customized: US$ 19,90/mês + US$ 1/user extra + US$ 0,10/device extra
- Headscale self-hosted para overlay Zero Trust
- Relays regionais dedicados
- Suporte contratado

> ✅ **Custo total 12 meses: US$ 1.000+** (Customized + infra + suporte)

---

## 6. Custos Ocultos e Riscos

### 6.1 Tempo de Setup e Manutenção

| Nível de experiência | Setup inicial | Manutenção mensal | Custo oportunidade (R$/ano) |
|---|---|---|---|
| Inexperiente (precisa aprender) | 8–16h | 2–4h | R$ 1.920–7.680 |
| Intermediário (já usou Linux) | 2–4h | 0,5–1h | R$ 480–1.920 |
| Avançado (sysadmin) | 0,5–1h | ~0,25h | R$ 120–480 |

> Considerando valor da hora técnica entre R$ 60–80/h (Brasil 2026).

### 6.2 Riscos por Método

| Risco | Porta direta | CF WARP | Tailscale | Pangolin |
|---|---|---|---|---|
| **Segurança** | 🔴 Portas expostas | 🟢 Tunnel seguro | 🟢 Mesh criptografado | 🟢 Tunnel + RBAC |
| **Vendor lock-in** | 🟢 Nenhum | 🔶 Cloudflare | 🔶 Tailscale Inc | 🟢 Self-hosted |
| **Disponibilidade** | 🔶 Depende VPS | 🟢 CF global | 🟢 Tailscale infra | 🔶 Depende VPS |
| **Complexidade** | 🟢 Baixa | 🔶 Média | 🟢 Baixa | 🔶 Média |
| **Custo imprevisível** | 🟢 Fixo | 🟢 Gratuito | 🔶 Cresce com users | 🟢 Fixo |

### 6.3 Quando o "Gratuito" Não é Grátis

| Cenário | Custo real/mês | Justificativa |
|---|---|---|
| OSS + VPS ingressada | US$ 4–7 | Só VPS, sem licença |
| OSS + VPS + manutenção (iniciante) | US$ 20–80 | Inclui horas técnicas |
| Pro Individual + VPS | US$ 14–17 | Licença rateada + VPS |
| Pro Basic + VPS + manutenção | US$ 40–80 | Licença + VPS + horas |
| Alternativa gerenciada (SoftAcesso) | R$ 29 | Tudo incluso |
| Alternativa gerenciada (GoDesk) | US$ 2,99 | Relay gerenciado |

> A lição: para quem **não tem** conhecimento técnico, uma alternativa
> gerenciada (SoftAcesso, GoDesk) pode ser mais barata que self-hosted
> quando o custo de oportunidade do tempo é considerado.

---

## 7. Recomendações Finais

### Por Perfil

| Perfil | **Escolha principal** | **Custo/mês** | **Por quê** |
|---|---|---|---|
| **A — Pessoal** | Tailscale Free + RustDesk Direct IP | **US$ 0** | Zero custo, zero servidor |
| **B — Autônomo (técnico)** | VPS Hetzner + OSS + CF WARP | **US$ 4** | Controle total, grátis |
| **B — Autônomo (não técnico)** | SoftAcesso (R$ 29) | **R$ 29** | Tudo pronto, PT-BR |
| **C — Pequena empresa** | VPS + Pro Basic + CF WARP | **US$ 24–27** | Console + gerenciamento |
| **D — MSP** | VPS + Pro Basic + relays + Pangolin | **US$ 30–50** | Zero trust + multi-relay |
| **E — Grande empresa** | Pro Customized + Headscale + relays | **US$ 80+** | Compliance + auditoria |

### Por Prioridade

| Prioridade | Método recomendado |
|---|---|
| 🔒 **Segurança máxima** | Pangolin (100% self-hosted) ou Tailscale (mesh criptografado) |
| 💰 **Menor custo** | Tailscale Free + Direct IP (US$ 0) |
| ⚡ **Simplicidade** | Porta direta VPS + script provision-vps.sh |
| 🌐 **Acessibilidade universal** | Cloudflare WARP (funciona em qualquer rede) |
| 📋 **Gestão centralizada** | RustDesk Pro Basic (console + LDAP/OIDC) |
| 🇧🇷 **Sem conhecimento técnico** | SoftAcesso (R$ 29/mês, português) |

---

## 8. Fluxo de Decisão

```
Tem experiência com Linux / Docker?
├── SIM
│   ├── Quer custo ZERO?
│   │   └── Tailscale Free + Direct IP (US$ 0) ←── USO PESSOAL
│   ├── Quer controle total + grátis?
│   │   └── VPS + OSS + CF WARP (US$ 4-7) ←── AUTÔNOMO
│   ├── Precisa de console web + gestão?
│   │   └── VPS + Pro Basic + CF WARP (US$ 24) ←── EMPRESA
│   └── Quer zero trust auto-gerido?
│       └── VPS + OSS + Pangolin (US$ 4-7) ←── MSP
│
└── NÃO
    ├── Orçamento mínimo?
    │   └── Tailscale Free + Direct IP (US$ 0) ←── FAMÍLIA
    └── Quer suporte em português?
        └── SoftAcesso (R$ 29/mês) ←── AUTÔNOMO / EMPRESA
```

---

## Referências

- [RustDesk Self-Host Documentation](https://rustdesk.com/docs/en/self-host/)
- [RustDesk Server Pro Licensing](https://rustdesk.com/pricing)
- [RustDesk GitHub FAQ](https://github.com/rustdesk/rustdesk/wiki/FAQ)
- [Tailscale + RustDesk Docs](https://tailscale.com/docs/solutions/access-remote-desktops-with-rustdesk)
- [Pangolin Self-Hosted Tunnel](https://github.com/fosrl/pangolin)
- [GoDeskFlow RustDesk + Caddy Tutorial](https://godeskflow.com/blog/rustdesk-self-hosted-tutorial)
- [Guia Cloudflare Tunnel deste projeto](07-cloudflare-tunnel.md)
- [Guia de Hardware](08-hardware.md)
- [Guia de Provedores VPS](09-vps.md)

---

