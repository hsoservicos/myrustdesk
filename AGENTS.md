# RustDesk Server OSS — myrustdesk

**Repo:** https://github.com/hsoservicos/myrustdesk.git

## Goal
Manter documentação completa e scripts automatizados para implantação de servidor RustDesk OSS self-hosted, incluindo guia VPS com 14 provedores analisados.

## Constraints & Preferences
- Documentação em português brasileiro para colaborador inexperiente.
- Servidor-alvo: Ubuntu 22.04/24.04 LTS ou Debian 12 (x86_64 ou arm64).
- Instalação principal via Docker; alternativa com script automatizado.
- Preferência por soluções gratuitas ou de baixo custo para VPS e exposição externa.
- Orçamento VPS: provedores de boa relação custo-benefício globais (Hetzner, Contabo, Oracle, Lightsail, Hostinger, HostGator) e brasileiros (Locaweb, KingHost, HostGator Brasil, Audaks, Umbler, Hostinger Brasil).

## Progress
### Done
- Pesquisa e análise da documentação oficial RustDesk (pt + en); arquitetura hbbs (TCP/UDP 21114-21118) + hbbr (TCP 21117, 21119).
- Criação do `compose.yml` com hbbs + hbbr (network_mode host, restart unless-stopped) e `.env`.
- Criação do `MANUAL_IMPLANTACAO.md` — manual completo passo a passo para iniciante (15 seções, glossário, anexos).
- Criação de `scripts/setup-server.sh` (instala Docker, UFW, containers, exibe chave pública + IP).
- Criação de scripts de deploy: `deploy-client-windows.ps1`, `deploy-client-linux.sh`, `deploy-client-macos.sh`.
- Documentação Cloudflare Tunnel (`docs/07-cloudflare-tunnel.md`) com 4 métodos: A) Zero Trust+WARP (recomendado, suporta UDP), B) Web Client, C) DNS Only, D) Spectrum (Enterprise).
- Criação de `compose-cloudflared.yml` para cloudflared em container com TUNNEL_TOKEN.
- Documentação de hardware (`docs/08-hardware.md`): consumo real ~4 MB RAM por processo; 1 core + 1 GB RAM suficiente para 1000 sessões relay; tabelas para 4 cenários.
- Documentação VPS (`docs/09-vps.md`) completa com 14 provedores:
  - Internacionais: Hetzner, Contabo, DigitalOcean, Vultr, Oracle Cloud Free Tier, Amazon Lightsail (AWS), Hostinger (Global), HostGator US/Global.
  - Nacionais (Brasil): Locaweb, KingHost, HostGator Brasil, Audaks Cloud, Umbler, Hostinger Brasil.
  - Tabelas comparativas (6.1 internacional, 6.2 nacional, 6.3 performance).
  - Matriz de decisão, árvore de decisão, recomendações por perfil.
  - Passo a passo de contratação para cada provedor (seções 8.1 a 8.5).
  - Segurança, manutenção, custos anuais, apêndice de comandos.
- Criação de `scripts/provision-vps.sh` — provisionamento completo de VPS: usuário não-root, SSH hardening, Docker, UFW (portas 21115-21117), fail2ban, unattended-upgrades, swap (se RAM ≤ 2 GB), containers RustDesk, timer semanal de manutenção.
- README.md reescrito como artefato GitHub (banner, badges, arquitetura, docs, tabelas).
- Tabelas comparativas atualizadas: Hostinger KVM 1 corrigido para 4 GB RAM / 50 GB NVMe; HostGator Snappy 2000 adicionado em Internacional; Hostinger e HostGator adicionados em benchmarks.
- Repositório criado e sincronizado com GitHub: `https://github.com/hsoservicos/myrustdesk`

### In Progress
- (none)

### Blocked
- (none)

## Key Decisions
- Docker + Docker Compose como método principal de instalação.
- `network_mode: host` necessário para UDP 21116 e performance de rede.
- Cloudflare Zero Trust + WARP (Método A) como abordagem recomendada para acesso externo: única solução gratuita TCP+UDP.
- Script `provision-vps.sh` unificado que cobre todo o setup inicial da VPS.
- Hetzner CX22 (~US$ 4/mês) como melhor custo-benefício global; Lightsail como opção AWS com datacenter SP; KingHost/Hostinger Brasil como líderes nacionais.
- HostGator US/Global não recomendado (custo 8x maior que Hetzner para mesma RAM).

## Next Steps
- Consolidar todos os documentos em um fluxo único de implantação do zero: contratar VPS → provisionar → setup RustDesk → expor com Cloudflare → deploy clientes.
- (Opcional) Adicionar testes de sintaxe para scripts.

## Critical Context
- RustDesk depende de **UDP** (porta 21116) para heartbeat/ID registration. Cloudflare Tunnel gratuito **não** proxy UDP — apenas WARP (overlay WireGuard) suporta UDP.
- Consumo real: servidor público RustDesk atende 1M+ endpoints com 2 vCPU / 4 GB RAM.
- Ubuntu 24.04 LTS cloud image requer mínimo de 1 GB RAM e ~5 GB de disco.
- Lightsail: datacenter São Paulo; planos com IPv4 desde US$ 5/mês (512 MB RAM — insuficiente), mínimo viável é US$ 7/mês (1 GB RAM).
- Hostinger Global: KVM 1 (4 GB RAM, NVMe) por US$ 6,49/mês (promo 2 anos) — competitivo com Hetzner.
- HostGator US: Snappy 2000 (2 vCPU, 4 GB DDR5, NVMe) a US$ 34,99/mês — **não recomendado** pelo custo elevado.
- Hostinger Brasil: KVM 1 (4 GB RAM, NVMe) por R$ 29,99/mês (promo 2 anos) — melhor custo-benefício nacional.
- Tabela 6.2 corrigida: Hostinger KVM 1 agora reflete 4 GB RAM (não 1 GB como anteriormente).

## Relevant Files
- `/home/hsantos/projetos/rustdesk/compose.yml`: orquestração Docker hbbs + hbbr (network_mode host).
- `/home/hsantos/projetos/rustdesk/compose-cloudflared.yml`: container cloudflared com TUNNEL_TOKEN.
- `/home/hsantos/projetos/rustdesk/.env`: variáveis de ambiente (ALWAYS_USE_RELAY, ENCRYPTED_ONLY).
- `/home/hsantos/projetos/rustdesk/MANUAL_IMPLANTACAO.md`: manual completo para iniciante.
- `/home/hsantos/projetos/rustdesk/scripts/setup-server.sh`: implantação automática do servidor.
- `/home/hsantos/projetos/rustdesk/scripts/provision-vps.sh`: provisionamento completo de VPS.
- `/home/hsantos/projetos/rustdesk/scripts/deploy-client-windows.ps1`: deploy cliente Windows (PowerShell).
- `/home/hsantos/projetos/rustdesk/scripts/deploy-client-linux.sh`: deploy cliente Linux.
- `/home/hsantos/projetos/rustdesk/scripts/deploy-client-macos.sh`: deploy cliente macOS.
- `/home/hsantos/projetos/rustdesk/README.md`: landing page GitHub do repositório.
- `/home/hsantos/projetos/rustdesk/docs/01-arquitetura.md` a `06-solucao-de-problemas.md`: documentação técnica.
- `/home/hsantos/projetos/rustdesk/docs/07-cloudflare-tunnel.md`: 4 métodos de exposição externa via Cloudflare.
- `/home/hsantos/projetos/rustdesk/docs/08-hardware.md`: dimensionamento de hardware (4 cenários + calculadora).
- `/home/hsantos/projetos/rustdesk/docs/09-vps.md`: guia completo de VPS com 14 provedores.
