# Especificação de Hardware — Servidor RustDesk OSS

## Sumário Executivo

O RustDesk Server OSS é extremamente leve. A própria equipe RustDesk opera o
servidor público de ID que atende **mais de 1 milhão de endpoints** em uma
máquina de apenas **2 CPUs / 4 GB RAM** na Vultr. Para uso corporativo típico
(até 200 dispositivos), qualquer servidor básico é mais que suficiente.

Este documento detalha as especificações mínimas e recomendadas para diferentes
cenários de uso, desde o servidor pessoal até a implantação corporativa.

---

## 1. Entendendo a Carga de Trabalho

O servidor RustDesk executa dois processos:

| Processo | Função | Consumo típico |
|---|---|---|
| **hbbs** | Servidor de ID / Sinalização | ~4 MB RAM, CPU mínimo |
| **hbbr** | Servidor de Retransmissão | ~4 MB RAM + largura de banda |

A carga real está na **rede**, não no processador ou memória.

### Consumo de Memória (comprovado)

```
Análise real de um servidor com 150-200 clientes (AWS t3-micro, 2 vCPU / 1 GB RAM):

hbbs:  ~3-5 MB  (residente)
hbbr:  ~3-5 MB  (residente)
Total: ~7-11 MB para os dois processos RustDesk

O restante da RAM é usado pelo sistema operacional, Docker e outros serviços.
```

Fonte: [GitHub Discussion #4857](https://github.com/rustdesk/rustdesk/discussions/4857)

### Tráfego de Rede por Conexão Relay

| Cenário | Tráfego | Resolução de tela |
|---|---|---|
| Conexão direta (P2P) | **Zero** no servidor | Qualquer |
| Uso administrativo/escritório | ~100 KB/s | Texto/planilhas |
| Suporte técnico moderado | ~500 KB/s - 1 MB/s | 1366x768 |
| Sessão full HD ativa | ~3 MB/s | 1920x1080 |
| Pico (mudanças rápidas de tela) | Até 3 MB/s | 1920x1080 |

**Média do servidor público RustDesk:** ~180 kb/s por conexão relay.

---

## 2. Cenários de Uso

### Cenário A: Uso Pessoal / Familiar (1-5 dispositivos)

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 1 core (qualquer) | 1 core @ 1 GHz |
| **RAM** | 512 MB | 1 GB |
| **Armazenamento** | 10 GB | 20 GB SSD |
| **Rede** | 10 Mbps | 50 Mbps |
| **Custo estimado** | ~US$ 3-5/mês | ~US$ 5-8/mês |

**Hardware sugerido:**
- Raspberry Pi 4/5 (4 GB RAM)
- VPS mais básico (Oracle Cloud Free Tier, AWS t2.nano, Hetzner CX22)
- Qualquer computador antigo com Linux

### Cenário B: Pequena Equipe (5-30 dispositivos)

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 1 core | 2 cores |
| **RAM** | 1 GB | 2 GB |
| **Armazenamento** | 20 GB SSD | 40 GB SSD |
| **Rede** | 50 Mbps | 100 Mbps |
| **Custo estimado** | ~US$ 5-8/mês | ~US$ 8-15/mês |

**Hardware sugerido:**
- VPS básico (DigitalOcean $6/mo, Hetzner CX22, Oracle Cloud free)
- Servidor local thin client com Linux
- Raspberry Pi 5 (8 GB RAM)

### Cenário C: Média Empresa (30-200 dispositivos)

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 2 cores | 2-4 cores |
| **RAM** | 2 GB | 4 GB |
| **Armazenamento** | 40 GB SSD | 80 GB SSD |
| **Rede** | 100 Mbps | 300 Mbps+ |
| **Custo estimado** | ~US$ 10-20/mês | ~US$ 20-40/mês |

**Hardware sugerido:**
- VPS dedicado (AWS t3.medium, Hetzner CX42, DigitalOcean $24/mo)
- Servidor local (Intel NUC, Dell OptiPlex small form factor)
- Servidor empresarial básico (PowerEdge, ProLiant entry-level)

### Cenário D: Grande Empresa / MSP (200-1000+ dispositivos)

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 2 cores | 4+ cores |
| **RAM** | 4 GB | 8 GB+ |
| **Armazenamento** | 80 GB SSD | 160 GB SSD+ |
| **Rede** | 300 Mbps | 1 Gbps |
| **Custo estimado** | ~US$ 30-50/mês | ~US$ 50-100+/mês |

**Hardware sugerido:**
- VPS de médio porte (AWS t3.large, Hetzner CX52)
- Servidor dedicado
- Múltiplos relays regionais (distribuição geográfica)

---

## 3. Especificações Detalhadas

### 3.1 Processador (CPU)

| Arquitetura | Suporte | Observação |
|---|---|---|
| **x86_64** (Intel/AMD 64-bit) | ✅ Completo | Recomendado para produção |
| **arm64** / **aarch64** (ARM 64-bit) | ✅ Completo | Raspberry Pi 4/5, Oracle ARM |
| **armv7l** (ARM 32-bit) | ✅ Suportado | Raspberry Pi 3 (menos performance) |

**Consumo real de CPU:**
- hbbs (ID/sinalização): < 1% de um core na maioria do tempo
- hbbr (relay): proporcional ao número de sessões relay ativas
- O servidor público RustDesk (1M+ endpoints) roda em **2 CPUs**

**Recomendação:** Um core moderno é suficiente para até 200 dispositivos.
O gargalo nunca será a CPU, e sim a largura de banda da rede.

### 3.2 Memória RAM

| Cenário | Consumo RustDesk | SO + Docker | Total necessário |
|---|---|---|---|
| 1-5 dispositivos | ~10-20 MB | ~800 MB | **1 GB** |
| 5-30 dispositivos | ~20-50 MB | ~1 GB | **2 GB** |
| 30-200 dispositivos | ~50-100 MB | ~1.5 GB | **4 GB** |
| 200-1000 dispositivos | ~100-200 MB | ~2 GB | **8 GB** |

> **Nota:** A RAM do RustDesk é insignificante. O consumo principal é do sistema
> operacional (Ubuntu Server ~500 MB em idle) e do Docker. O restante fica
> disponível para cache de disco, o que melhora a performance geral.

### 3.3 Armazenamento

| Item | Tamanho |
|---|---|
| Ubuntu Server 24.04 LTS (instalação mínima) | ~4-5 GB |
| Docker + imagens | ~200-300 MB |
| RustDesk binaries (via Docker) | incluso na imagem |
| Chaves criptográficas | < 1 MB |
| Logs (por mês, tráfego moderado) | ~50-500 MB |
| **Total estimado (primeiro ano)** | **~10-20 GB** |

**Recomendação de disco por cenário:**

| Cenário | Tamanho | Tipo |
|---|---|---|
| Pessoal / testes | 10-20 GB | Qualquer |
| Pequena equipe | 20-40 GB | SSD recomendado |
| Média empresa | 40-80 GB | SSD obrigatório |
| Grande empresa | 80-160 GB+ | SSD/NVMe |

> **Sobre o tipo de disco:** O RustDesk faz pouquíssimas operações de E/S de disco
> (praticamente só grava logs). Um SSD é recomendado pela confiabilidade, mas
> um HD tradicional também funciona sem degradação perceptível.

### 3.4 Rede

A rede é o **recurso mais importante** do servidor RustDesk.

#### Largura de Banda

| Cenário | Tráfego estimado | Largura recomendada |
|---|---|---|
| Apenas sinalização (hbbs) | ~1-5 KB/s por dispositivo | 10 Mbps |
| Relay ocasional (10% das sessões) | ~100 KB/s por sessão relay | 50 Mbps |
| Relay frequente (50% das sessões) | ~500 KB/s por sessão relay | 100 Mbps |
| Relay intensivo (muitas sessões HD) | ~3 MB/s por sessão relay | 300 Mbps+ |

#### Fórmula de Cálculo

```
Largura necessária (Mbps) = (Nº sessões relay simultâneas × Tráfego médio × 8) / 1.000.000

Exemplo prático:
  5 sessões relay × 500 KB/s × 8 / 1.000.000 = 20 Mbps
```

#### Limites de Largura de Banda do hbbr (configuráveis via variável de ambiente)

| Parâmetro | Padrão | Descrição |
|---|---|---|
| `TOTAL_BANDWIDTH` | 1024 Mb/s | Limite global do servidor |
| `SINGLE_BANDWIDTH` | 128 Mb/s | Limite por conexão |
| `LIMIT_SPEED` | 32 Mb/s | Limite para conexões degradadas/blacklist |

#### Latência

| Origem → Destino | Latência aceitável | Experiência |
|---|---|---|
| Mesma rede local | < 5 ms | Excelente (conexão direta P2P) |
| Mesma região/país | < 30 ms | Muito boa |
| Entre continentes | < 150 ms | Aceitável para relay |
| > 200 ms | Ruim | Perceptível, considerar relay regional |

### 3.5 Sistema Operacional

| SO | Versão | Arquitetura | Suporte |
|---|---|---|---|
| **Ubuntu Server** | 22.04 LTS ou **24.04 LTS** | amd64 / arm64 | ✅ Recomendado |
| **Debian** | 12 (Bookworm) | amd64 / arm64 | ✅ Recomendado |
| Outras distribuições Linux | - | amd64 / arm64 | ✅ Suportado |
| Windows Server | 2019+ | amd64 | ✅ Suportado |
| Raspberry Pi OS | 64-bit baseado em Debian 12 | arm64 | ✅ Suportado |

**Requisitos do Ubuntu Server 24.04 LTS:**

| Requisito | Mínimo | Sugerido |
|---|---|---|
| CPU | 1 GHz 64-bit | 2+ GHz 64-bit multi-core |
| RAM | 1.5 GB (ISO) / 1 GB (cloud) | 3+ GB |
| Disco | 5 GB (ISO) / 4 GB (cloud) | 25+ GB |
| Arquitetura | amd64, arm64, ppc64el, s390x | amd64 ou arm64 |

Fonte: [Ubuntu Server System Requirements](https://ubuntu.com/server/docs/reference/installation/system-requirements/)

---

## 4. Opções de Hardware

### 4.1 Servidor Dedicado (Bare Metal)

| Modelo | CPU | RAM | Disco | Rede | Indicado para |
|---|---|---|---|---|---|
| **Raspberry Pi 4** | ARM Cortex-A72 4-core @ 1.8 GHz | 2-8 GB | MicroSD/SSD USB | 1 Gbps | Cenário A |
| **Raspberry Pi 5** | ARM Cortex-A76 4-core @ 2.4 GHz | 4-8 GB | MicroSD/SSD USB/NVMe | 1 Gbps | Cenários A, B |
| **Intel NUC** / **Dell OptiPlex Micro** | Intel i3/i5 moderno | 8-16 GB | SSD NVMe | 1 Gbps | Cenários B, C |
| **Thin Client** (Dell Wyse, HP t640) | AMD/Intel 2+ cores | 4-8 GB | SSD | 1 Gbps | Cenários A, B |
| **Servidor rack** (Dell PowerEdge, HPE ProLiant) | Xeon/Epyc 4+ cores | 16+ GB | SSD RAID | 1 Gbps+ | Cenários C, D |

#### Custo Médio (Bare Metal)

| Opção | Custo aquisição | Consumo elétrico | Custo anual (energia) |
|---|---|---|---|
| Raspberry Pi 5 (8 GB) | ~R$ 800-1.200 | ~15W | ~R$ 100 |
| Intel NUC | ~R$ 2.500-4.000 | ~65W | ~R$ 450 |
| Thin Client usado | ~R$ 400-800 | ~30W | ~R$ 200 |
| Servidor rack usado | ~R$ 5.000-15.000 | ~200W+ | ~R$ 1.400+ |

### 4.2 Servidor Virtual (VPS)

| Provedor | Plano mínimo | CPU | RAM | Disco | Tráfego | Custo/mês |
|---|---|---|---|---|---|---|
| **Hetzner** | CX22 | 2 vCPU | 4 GB | 40 GB NVMe | Ilimitado | ~€5,99 |
| **DigitalOcean** | Basic | 1 vCPU | 1 GB | 25 GB SSD | 1 TB | US$ 6 |
| **Oracle Cloud** | Free Tier | 1/4 OCPU (Ampere ARM) | 1-24 GB | 200 GB | 10 TB | **US$ 0** |
| **AWS** | t2.micro | 1 vCPU (burst) | 1 GB | 30 GB EBS | 100 GB/mês | ~US$ 8 (free tier 1 ano) |
| **Google Cloud** | e2-micro | 0.25 vCPU (burst) | 1 GB | 30 GB | 1 GB/mês | ~US$ 6 (free tier) |
| **Contabo** | Cloud VPS S | 4 vCPU | 8 GB | 200 GB SSD | Ilimitado | ~€6,99 |

> **Recomendação de custo-benefício:** **Hetzner CX22** (2 vCPU / 4 GB RAM /
> 40 GB NVMe por ~€5,99/mês) — sobra para qualquer cenário até 200 dispositivos.
>
> **Para testes/pessoal (custo zero):** **Oracle Cloud Free Tier** — instância
> ARM com até 4 vCPU e 24 GB RAM. Perfeito para RustDesk.

### 4.3 Hardware Mínimo Comprovado

Configurações reais de servidores RustDesk em produção (relatos da comunidade):

| Configuração | Dispositivos | Uptime | Fonte |
|---|---|---|---|
| 1 vCPU / 1 GB RAM (VPS básica) | 50+ | Estável | GitHub Discussions |
| 2 vCPU / 1 GB RAM (AWS t3-micro) | 150-200 | Estável | GitHub Discussions |
| 2 vCPU / 4 GB RAM (Vultr) | **1.000.000+** | Estável | RustDesk oficial |
| Raspberry Pi 4 (4 GB) | 10-20 | Estável | Documentação oficial |

---

## 5. Dimensionamento Prático

### 5.1 Calculadora Rápida

```
Número de dispositivos:        _____

Destes, quantos simultâneos:   _____  (fração que usa relay)

Tráfego médio por relay:       ~500 KB/s  (valor conservador)

Largura necessária:
  simultâneos × 500 KB/s = _____ KB/s = _____ Mbps

RAM necessária:
  até 50 dispositivos:  1 GB
  até 200 dispositivos: 2 GB
  até 1000+:             4 GB+

Disco necessário:
  20 GB base + 500 MB por ano de logs
```

### 5.2 Exemplos Práticos

| Situação | Dispositivos | Simultâneos (relay) | RAM | CPU | Disco | Rede |
|---|---|---|---|---|---|---|
| Rafael usa para acessar o PC de casa do trabalho | 2 | 1 (raro) | 1 GB | 1 core | 10 GB | 10 Mbps |
| Suporte técnico com 5 técnicos atendendo 20 clientes | 25 | 5 | 2 GB | 2 cores | 20 GB SSD | 100 Mbps |
| Escola com 30 computadores e 3 administradores | 33 | 10 | 2 GB | 2 cores | 40 GB SSD | 100 Mbps |
| Empresa com 150 funcionários e TI interna | 150 | 30 | 4 GB | 2 cores | 40 GB SSD | 300 Mbps |
| MSP com 500 endpoints gerenciados | 500+ | 75 | 8 GB | 4 cores | 80 GB SSD | 500 Mbps |

---

## 6. Requisitos de Energia e Refrigeração

Para servidores locais (não VPS):

### Consumo Elétrico

| Hardware | Típico (idle) | Pico | Fonte sugerida |
|---|---|---|---|
| Raspberry Pi 5 | 5W | 15W | USB-C 5V/5A (25W) |
| Intel NUC | 15W | 65W | Fonte original 65W |
| Thin Client | 10W | 30W | Fonte original |
| Servidor rack empresarial | 100W | 300W+ | Nobreak 1000VA+ |

### Nobreak (UPS) — Recomendações

| Cenário | UPS mínimo | Autonomia estimada |
|---|---|---|
| Raspberry Pi + modem | 300VA | 30-60 min |
| NUC + switch | 600VA | 20-40 min |
| Servidor rack | 1000VA+ | 15-30 min |

### Refrigeração

| Hardware | Refrigeração necessária |
|---|---|
| Raspberry Pi | Passiva (dissipador incluso) |
| NUC/Thin Client | Ativa (ventoinha interna) |
| Servidor rack | Sala climatizada (18-25°C) |

> O RustDesk não gera calor significativo. A refrigeração é a mesma necessária
> para manter o hardware funcionando dentro das especificações do fabricante.

---

## 7. Checklist de Verificação de Hardware

Antes de adquirir o hardware, use esta lista:

### Processador
- [ ] Arquitetura compatível: x86_64 ou arm64
- [ ] Mínimo 1 core (2+ recomendado)
- [ ] Clock mínimo 1 GHz

### Memória RAM
- [ ] Mínimo 1 GB (para Ubuntu + Docker + RustDesk)
- [ ] 2+ GB recomendado para folga

### Armazenamento
- [ ] Mínimo 20 GB livres
- [ ] SSD preferencialmente
- [ ] Backup externo possível

### Rede
- [ ] Conexão estável com a internet
- [ ] Largura de banda calculada conforme uso esperado
- [ ] Porta de rede cabeada (evitar Wi-Fi para servidor)

### Sistema Operacional
- [ ] Ubuntu 22.04/24.04 LTS ou Debian 12
- [ ] Acesso root ou sudo
- [ ] Firewall configurável

### Energia (se local)
- [ ] Conexão elétrica estável
- [ ] Nobreak (recomendado)
- [ ] Ventilação adequada

### Rede Local
- [ ] IP fixo configurado no servidor
- [ ] Portas do roteador liberadas (se for usar DNS Only)
- [ ] Acesso ao firewall da rede para liberar portas

---

## 8. Limites e Restrições Conhecidas

### Limites do hbbr (configuráveis)

| Parâmetro | Padrão | Máximo prático |
|---|---|---|
| `TOTAL_BANDWIDTH` | 1024 Mb/s | Dependente da rede |
| `SINGLE_BANDWIDTH` | 128 Mb/s | Dependente da rede |
| `LIMIT_SPEED` | 32 Mb/s | Dependente da rede |
| Conexões simultâneas | Ilimitado | Limitado por recursos do SO |

### Limites do Sistema Operacional

| Recurso | Limite | Como aumentar |
|---|---|---|
| Portas efêmeras | 28.000-60.999 | `sysctl net.ipv4.ip_local_port_range` |
| File descriptors | 1.024 por processo | `ulimit -n 65535` |
| Backlog de conexões | 128 | `sysctl net.core.somaxconn=4096` |

### Sincronização de Portas do Roteador

Se for usar o Método C (DNS Only), as seguintes portas precisam ser
redirecionadas no roteador para o IP do servidor:

| Porta | Protocolo | Serviço |
|---|---|---|
| 21115 | TCP | hbbs — teste de NAT |
| 21116 | TCP + UDP | hbbs — ID, heartbeat, hole punching |
| 21117 | TCP | hbbr — relay |
| 21118 | TCP | hbbs — web client (opcional) |
| 21119 | TCP | hbbr — web client (opcional) |

---

## 9. Resumo Final

### A Regra de Ouro

> **"O servidor RustDesk é tão leve que o hardware quase nunca é o gargalo.
> Invista na rede, não no processador."**

### Decisão Rápida

| Seu cenário | Escolha de hardware |
|---|---|
| "Só quero testar" | Oracle Cloud Free Tier (US$ 0/mês) |
| "Uso pessoal, 2-3 PCs" | Raspberry Pi 5 ou VPS de €3/mês |
| "Equipe pequena, até 30 dispositivos" | VPS de €5-10/mês (Hetzner CX22) |
| "Empresa, 30-200 dispositivos" | VPS de €10-30/mês (Hetzner CX32/CX42) |
| "Não quero gastar com VPS" | Computador velho em casa com Ubuntu Server |
| "Preciso de alta disponibilidade" | 2 VPS em regiões diferentes (active-active) |
| "Tenho budget, quero o melhor" | Servidor dedicado + Cloudflare Zero Trust + WARP |

---

## 10. Referências

- [RustDesk Installation — Server Requirements](https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/install/)
- [RustDesk Server Pro — Hardware Requirement](https://rustdesk.com/docs/en/self-host/rustdesk-server-pro/)
- [Ubuntu Server 24.04 LTS — System Requirements](https://ubuntu.com/server/docs/reference/installation/system-requirements/)
- [GitHub Discussion #4857 — 1GB/1vCPU server enough?](https://github.com/rustdesk/rustdesk/discussions/4857)
- [DeepWiki — RustDesk Server System Requirements](https://deepwiki.com/rustdesk/doc.rustdesk.com/2-server-installation)
- [GitHub rustdesk-server — Performance Tuning](https://deepwiki.com/rustdesk/rustdesk-server/7.4-performance-tuning)
