# RustDesk Server OSS — myrustdesk

**Repo:** https://github.com/hsoservicos/myrustdesk.git

## Goal
Manter documentação completa, scripts automatizados e estudos de custo-benefício para implantação de servidor RustDesk OSS self-hosted com acesso externo seguro, abrangendo 14 provedores VPS, 6 métodos de exposição, deploy de clientes em 7 plataformas e manual operacional para leigos.

## Constraints & Preferences
- Documentação em português brasileiro para colaborador inexperiente.
- Servidor-alvo: Ubuntu 22.04/24.04 LTS ou Debian 12 (x86_64 ou arm64).
- Instalação principal via Docker; alternativa com script automatizado.
- Preferência por soluções gratuitas ou de baixo custo para VPS e exposição externa.
- Orçamento VPS: provedores de boa relação custo-benefício globais (Hetzner, Contabo, Oracle, Lightsail, Hostinger, HostGator) e brasileiros (Locaweb, KingHost, HostGator Brasil, Audaks, Umbler, Hostinger Brasil).
- Repositório GitHub: `https://github.com/hsoservicos/myrustdesk` (branch `main`).

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
- Criação de `docs/10-estudo-custo-beneficio.md` — estudo completo de custo-benefício para acesso externo:
  - 5 perfis de uso (pessoal a enterprise)
  - 6 métodos de exposição externa analisados (Porta direta, Cloudflare WARP, Tailscale, Pangolin, Caddy TLS, CGNAT relay)
  - Tabelas comparativas (custo 12 meses, funcional, consumo banda)
  - 3 opções de licenciamento (OSS, Pro Individual, Pro Basic/Customized)
  - Alternativas gerenciadas nacionais e internacionais (SoftAcesso, GoDesk, RDP.sh)
  - Custos ocultos (tempo de manutenção, riscos, vendor lock-in)
  - Fluxo de decisão e recomendações por perfil
- Criação de `docs/11-manual-operacional-cliente.md` — manual operacional completo para operadores leigos:
  - Instalação no Windows (exe + MSI), macOS (Intel + Apple Silicon), Linux (deb/rpm/AppImage/Flatpak), Android, iOS, Web
  - Configuração do servidor corporativo (importar config + manual)
  - Uso do RustDesk (conectar, transferir arquivos, encerrar)
  - Acesso remoto sem supervisão (senha permanente, serviço em segundo plano)
  - Solução de problemas (11 cenários), glossário, anexos com atalhos e portas
- Scripts de deploy revisados com detecção dinâmica de versão via API GitHub:
  - `scripts/deploy-client-windows.ps1`: suporte a x86_64/x86_32, download via API, instalação MSI
  - `scripts/deploy-client-linux.sh`: detecção de arquitetura (x86_64/aarch64/armv7), RPM + DEB + pacman
  - `scripts/deploy-client-macos.sh`: detecção Intel vs Apple Silicon, download via API
- Criação de `docs/12-fluxo-implantacao.md` — visão geral dos 3 fluxos para coordenadores, com referências cruzadas.
- Criação de `docs/13-implantacao-vps.md` — guia detalhado para leigos: contratar VPS → provisionar → verificar, explicando cada conceito e comando.
- Criação de `docs/14-implantacao-cloudflare.md` — guia detalhado para leigos: criar conta Cloudflare → configurar túnel Zero Trust + WARP → testar, com glossário e anexo.
- Criação de `.github/workflows/syntax-checks.yml` — CI com 4 jobs: ShellCheck (.sh), PSScriptAnalyzer (.ps1), yamllint (compose), ShellCheck (raiz).

### In Progress
- (none)

### Blocked
- (none)

## Key Decisions
- Docker + Docker Compose como método principal de instalação.
- `network_mode: host` necessário para UDP 21116 e performance de rede.
- Cloudflare Zero Trust + WARP (Método A) como abordagem recomendada para acesso externo: única solução gratuita TCP+UDP (cloudflared gratuito não proxy UDP).
- Script `provision-vps.sh` unificado que cobre todo o setup inicial da VPS.
- Hetzner CAX11 (~US$ 4/mês) como melhor custo-benefício global; Lightsail AWS SP como opção com datacenter Brasil.
- Hostinger KVM 1 (4 GB RAM, NVMe) a US$ 6,50/mês (global) ou R$ 29,99/mês (BR promo 2 anos) — melhor custo-benefício nacional, com suporte em português.
- HostGator US/Global não recomendado (custo 8x maior que Hetzner para mesma RAM).
- Tailscale Free + Direct IP (US$ 0) recomendado para uso pessoal/família — elimina servidor RustDesk.
- Alternativas gerenciadas (SoftAcesso, GoDesk) mais baratas que self-hosted para quem não tem conhecimento técnico.

## Next Steps
- (nenhum pendente — ambos os itens concluídos)
- Possíveis próximos: adicionar testes de integração Docker, validar scripts em container Ubuntu 24.04 real, criar vídeo tutorial ou documentação em vídeo.

## Critical Context
- RustDesk depende de **UDP** (porta 21116) para heartbeat/ID registration. Cloudflare Tunnel gratuito **não** proxy UDP — apenas WARP (overlay WireGuard) suporta UDP.
- Consumo real: servidor público RustDesk atende 1M+ endpoints com 2 vCPU / 4 GB RAM.
- Ubuntu 24.04 LTS cloud image requer mínimo de 1 GB RAM e ~5 GB de disco.
- Lightsail: datacenter São Paulo; planos com IPv4 desde US$ 5/mês (512 MB RAM — insuficiente), mínimo viável é US$ 7/mês (1 GB RAM).
- Hostinger Global: KVM 1 (4 GB RAM, NVMe) por US$ 6,49/mês (promo 2 anos) — competitivo com Hetzner.
- HostGator US: Snappy 2000 (2 vCPU, 4 GB DDR5, NVMe) a US$ 34,99/mês — **não recomendado** pelo custo elevado.
- Hostinger Brasil: KVM 1 (4 GB RAM, NVMe) por R$ 29,99/mês (promo 2 anos) — melhor custo-benefício nacional.
- Tabela 6.2 corrigida: Hostinger KVM 1 agora reflete 4 GB RAM (não 1 GB como anteriormente).
- RustDesk Server Pro: Individual US$ 9,90/mês (anual US$ 119), Basic US$ 19,90/mês (US$ 239/ano), Customized US$ 19,90 + US$ 1/user extra + US$ 0,10/device.
- SoftAcesso: R$ 29/mês, suporte PT-BR, PIX, sem necessidade de servidor. 87% mais barato que self-hosted para não-técnicos.
- Scripts deploy-cliente agora usam API GitHub para detectar a versão mais recente dinamicamente.
- iOS só pode **controlar** outros dispositivos, não pode ser controlado.

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
- `/home/hsantos/projetos/rustdesk/docs/10-estudo-custo-beneficio.md`: estudo custo-benefício com 6 métodos de exposição, 3 licenças, fluxo de decisão.
- `/home/hsantos/projetos/rustdesk/docs/11-manual-operacional-cliente.md`: manual operacional do cliente para 7 plataformas (leigos).
- `/home/hsantos/projetos/rustdesk/docs/12-fluxo-implantacao.md`: visão geral dos 3 fluxos para coordenadores.
- `/home/hsantos/projetos/rustdesk/docs/13-implantacao-vps.md`: guia VPS detalhado para leigos.
- `/home/hsantos/projetos/rustdesk/docs/14-implantacao-cloudflare.md`: guia Cloudflare detalhado para leigos.
- `/home/hsantos/projetos/rustdesk/.github/workflows/syntax-checks.yml`: CI com ShellCheck, PSScriptAnalyzer, yamllint.

---

