# Implantação do RustDesk em VPS (Virtual Private Server)

## Sumário

1. [O que é uma VPS e por que usar?](#1-o-que-é-uma-vps-e-por-que-usar)
2. [Por que VPS para o RustDesk?](#2-por-que-vps-para-o-rustdesk)
3. [Requisitos de VPS para o RustDesk](#3-requisitos-de-vps-para-o-rustdesk)
4. [Provedores Internacionais](#4-provedores-internacionais)
5. [Provedores Nacionais (Brasil)](#5-provedores-nacionais-brasil)
6. [Comparativo Completo](#6-comparativo-completo)
7. [Como Escolher o Provedor Ideal](#7-como-escolher-o-provedor-ideal)
8. [Passo a Passo: Contratação e Provisionamento](#8-passo-a-passo-contratação-e-provisionamento)
9. [Configuração do Servidor](#9-configuração-do-servidor)
10. [Segurança em VPS](#10-segurança-em-vps)
11. [Manutenção e Monitoramento](#11-manutenção-e-monitoramento)
12. [Custos](#12-custos)
13. [Recomendações Finais](#13-recomendações-finais)

---

## 1. O que é uma VPS e por que usar?

Uma **VPS (Virtual Private Server)** é um servidor virtualizado dentro de um
servidor físico compartilhado. Você tem **acesso root**, recursos dedicados
(RAM, CPU, disco) e pode instalar qualquer software — como se fosse um
computador físico, mas rodando na nuvem.

### Vantagens da VPS para o RustDesk

| Característica | Benefício |
|---|---|
| **Ligada 24/7** | O servidor RustDesk fica sempre disponível |
| **IP público fixo** | Clientes conectam sem precisar de DNS dinâmico |
| **Recurso dedicado** | Performance previsível, sem oscilação |
| **Escalável** | Aumente RAM/CPU com poucos cliques se precisar |
| **Backup automático** | Snapshots para recuperação rápida |
| **Sem custo de energia** | Não impacta sua conta de luz |
| **Sem risco local** | Não depende da internet da sua casa/escritório |

### Quando usar VPS vs. Servidor Local

| Situação | Recomendação |
|---|---|
| Internet residencial instável | **VPS** — disponibilidade garantida |
| Sem IP público fixo | **VPS** — IP fixo incluso |
| Orçamento apertado | **VPS** — a partir de ~US$ 4/mês |
| Dados sensíveis (LGPD) | **VPS nacional** ou **servidor local** |
| Latência zero na LAN | **Servidor local** |
| Sem custo recorrente | **Servidor local** (hardware já adquirido) |

---

## 2. Por que VPS para o RustDesk?

O RustDesk Server é **extremamente leve** — consome ~10 MB de RAM para os
processos hbbs + hbbr. Uma VPS de entrada é mais que suficiente para a
maioria dos cenários.

### Tráfego de Rede na VPS

| Tipo de conexão | Impacto na VPS |
|---|---|
| Sinalização (hbbs) | Irrisório — ~1-5 KB/s por dispositivo |
| Hole punching (P2P) | **Zero** — dados trafegam direto entre clientes |
| Relay (hbbr) | 30 KB/s a 3 MB/s por sessão, depende da resolução |

> **Nota importante:** Em VPS, o tráfego de relay é o único que consome
> banda significativa. Se a maioria das conexões for P2P (hole punching
> bem-sucedido), o consumo de banda é praticamente zero.

---

## 3. Requisitos de VPS para o RustDesk

### Mínimos Absolutos

| Recurso | Mínimo | Por quê |
|---|---|---|
| **CPU** | 1 vCPU | RustDesk consome < 5% de um core |
| **RAM** | 1 GB | Ubuntu Server (~600 MB) + RustDesk (~10 MB) + Docker (~200 MB) |
| **Disco** | 10 GB SSD | SO (~5 GB) + Docker/images (~2 GB) + logs |
| **Rede** | 10 Mbps | Suficiente para sinalização e relay ocasional |
| **Tráfego** | 500 GB/mês | Folga para relay moderado |
| **Sistema** | Ubuntu 22.04/24.04 ou Debian 12 | Suporte e facilidade |

### Recomendados por Cenário

| Cenário | CPU | RAM | Disco | Tráfego/mês | Custo estimado |
|---|---|---|---|---|---|
| Pessoal (1-5 disp.) | 1 vCPU | 1-2 GB | 10-20 GB SSD | 500 GB - 1 TB | ~US$ 4-6/mês |
| Pequena equipe (5-30) | 2 vCPU | 2-4 GB | 20-40 GB SSD | 1-2 TB | ~US$ 5-10/mês |
| Média empresa (30-200) | 2-4 vCPU | 4-8 GB | 40-80 GB SSD | 2-5 TB | ~US$ 10-30/mês |

---

## 4. Provedores Internacionais

### 4.1 Hetzner Cloud (Recomendado)

| Plano | vCPU | RAM | Disco | Tráfego | Preço |
|---|---|---|---|---|---|
| **CX22** | 2 | 4 GB | 40 GB NVMe | 20 TB | ~€3,79/mês (~US$ 4) |
| **CX32** | 4 | 8 GB | 80 GB NVMe | 20 TB | ~€6,97/mês |
| **CAX11** (ARM) | 2 | 4 GB | 40 GB NVMe | 20 TB | ~€3,29/mês |

**Pontos fortes:** Melhor custo-benefício do mercado. AMD EPYC e NVMe.
Rede de 1 Gbps. Firewall incluso. Snapshots. Datacenters na Europa e EUA.

**Pontos fracos:** Suporte por ticket (sem chat 24h). Datacenter apenas em
Falkenstein, Nuremberg, Helsinki, Ashburn, Hillsboro e Singapura.

**Para o RustDesk:** CX22 é **perfeito** — 2 vCPU / 4 GB RAM / 40 GB NVMe
por ~€3,79/mês. Roda o RustDesk com folga para centenas de dispositivos.

### 4.2 Contabo

| Plano | vCPU | RAM | Disco | Tráfego | Preço |
|---|---|---|---|---|---|
| **Cloud VPS S** | 4 | 8 GB | 50 GB NVMe | 32 TB | ~€4,50/mês |
| **Cloud VPS M** | 6 | 12 GB | 100 GB NVMe | 32 TB | ~€7,00/mês |

**Pontos fortes:** Especificações muito altas pelo preço. 12 datacenters
globais. Tráfego ilimitado (limitado a 32 TB antes de throttling).

**Pontos fracos:** Performance de disco e CPU inferior à Hetzner.
Jitter de rede maior. Suporte pode ser lento.

**Para o RustDesk:** Especificações sobram, mas a performance de rede
inconsistente pode afetar sessões relay.

### 4.3 DigitalOcean

| Plano | vCPU | RAM | Disco | Tráfego | Preço |
|---|---|---|---|---|---|
| **Basic Droplet** | 1 | 1 GB | 25 GB SSD | 1 TB | US$ 6/mês |
| **Basic Droplet** | 2 | 4 GB | 80 GB SSD | 4 TB | US$ 24/mês |

**Pontos fortes:** Melhor experiência de desenvolvedor. Documentação
excelente. API robusta. Marketplace com one-click apps. Muitas regiões.

**Pontos fracos:** Custo ~2x maior que Hetzner para mesmas especificações.

**Para o RustDesk:** Plano de US$ 6/mês (1 GB RAM) é suficiente, mas
paga-se mais por menos recursos comparado à Hetzner.

### 4.4 Vultr

| Plano | vCPU | RAM | Disco | Tráfego | Preço |
|---|---|---|---|---|---|
| **Cloud Compute** | 1 | 1 GB | 25 GB SSD | 1 TB | US$ 6/mês |
| **Cloud Compute** | 2 | 4 GB | 80 GB SSD | 3 TB | US$ 20/mês |

**Pontos fortes:** 35 datacenters (maior cobertura global). Faturamento
horário. Firewall gratuito.

**Pontos fracos:** Performance mediana. Tráfego incluso baixo.

### 4.5 Oracle Cloud Free Tier

| Plano | vCPU | RAM | Disco | Tráfego | Preço |
|---|---|---|---|---|---|
| **VM.Standard.A1.Flex** | Até 4 | Até 24 GB | 200 GB | 10 TB | **US$ 0/mês** |

**Pontos fortes:** **Gratuito permanente** (Always Free). 4 vCPU ARM Ampere,
24 GB RAM, 200 GB disco. Performance excelente.

**Pontos fracos:** Criação de conta é burocrática e pode ser recusada.
Oracle pode reclaimar recursos sem aviso. Sem suporte para o tier gratuito.

**Para o RustDesk:** **Ideal para testar ou uso pessoal.** Especificações
mais que suficientes para qualquer cenário. O risco é a instabilidade do
tier gratuito — não recomendado para produção crítica.

### 4.6 Amazon Lightsail

**Amazon Lightsail** é o serviço de VPS da AWS com preço previsível
(bundle mensal fixo). Oferece planos Linux/Unix e Windows com IP estático,
firewall e snapshots inclusos.

#### Planos com IPv4 Público (Linux/Unix)

| Plano | vCPU\* | RAM | Disco | Tráfego | Preço |
|---|---|---|---|---|---|
| $5/mês | 2 | 512 MB | 20 GB SSD | 1 TB | **US$ 5/mês** |
| **$7/mês** | **2** | **1 GB** | **40 GB SSD** | **2 TB** | **US$ 7/mês** |
| **$12/mês** | **2** | **2 GB** | **60 GB SSD** | **3 TB** | **US$ 12/mês** |
| $24/mês | 2 | 4 GB | 80 GB SSD | 4 TB | US$ 24/mês |
| $44/mês | 2 | 8 GB | 160 GB SSD | 5 TB | US$ 44/mês |
| $84/mês | 4 | 16 GB | 320 GB SSD | 6 TB | US$ 84/mês |

*\*Planos criados antes de 29/jun/2023 entregam 1 vCPU; após essa data, 2 vCPU.*

#### Planos com IPv6 Apenas (Linux/Unix) — mais baratos, sem IPv4 público

| Plano | vCPU | RAM | Disco | Tráfego | Preço |
|---|---|---|---|---|---|
| $3.50/mês | 2 | 512 MB | 20 GB SSD | 1 TB | **US$ 3,50/mês** |
| $5/mês | 2 | 1 GB | 40 GB SSD | 2 TB | US$ 5/mês |
| $10/mês | 2 | 2 GB | 60 GB SSD | 3 TB | US$ 10/mês |

> ⚠️ **Planos apenas IPv6 não funcionam com RustDesk**, pois o RustDesk
> não suporta IPv6 em todos os cenários e muitos clientes corporativos
> ainda operam apenas com IPv4. Prefira sempre os planos com IPv4 público.

**Pontos fortes:** Ecossistema AWS completo — integração com outros
serviços AWS se necessário. **Datacenter em São Paulo (sa-east-1)**
com baixa latência para o Brasil inteiro. Preço previsível sem surpresas.
IP estático incluso. Firewall integrado no painel. Snapshots automáticos
e manuais. **3 meses grátis** nos planos $5, $7 e $12 (IPv4).

**Pontos fracos:** **Custo 2-3x maior** que Hetzner para o mesmo hardware.
Plano de $5/mês tem apenas 512 MB RAM — insuficiente para Ubuntu (mínimo
recomendado: 1 GB). CPU compartilhada com burst limitado. Overage de
tráfego é caro (US$ 0,09/GB excedente). Tráfego de transferência é
contado em ambas as direções (inbound + outbound). Sem opção ARM.
Limite de transferência reduzido à metade em algumas regiões da Ásia.

**Para o RustDesk:** Plano **$7/mês (1 GB RAM)** é o mínimo viável —
perfeito para uso pessoal. Plano **$12/mês (2 GB RAM)** é o recomendado
para pequenas equipes. A vantagem competitiva é o **datacenter em São
Paulo**: se você precisa de baixa latência no Brasil e não quer provedores
nacionais, o Lightsail é a melhor opção entre os internacionais. Custo
superior à Hetzner, mas com suporte AWS e presença local.

### 4.7 Hostinger (Global)

A Hostinger tem sede na Lituânia e opera globalmente com servidores
na Europa, América do Norte, Ásia e América do Sul. Seus planos VPS
utilizam virtualização KVM, processadores AMD EPYC e NVMe.

| Plano | vCPU | RAM | Disco | Tráfego | Preço promocional\* | Preço renovação |
|---|---|---|---|---|---|---|
| **KVM 1** | **1** | **4 GB** | **50 GB NVMe** | **4 TB** | **US$ 6,49/mês** | US$ 11,99/mês |
| **KVM 2** | **2** | **8 GB** | **100 GB NVMe** | **8 TB** | **US$ 8,99/mês** | US$ 14,99/mês |
| KVM 4 | 4 | 16 GB | 200 GB NVMe | 16 TB | US$ 12,99/mês | US$ 28,99/mês |
| KVM 8 | 8 | 32 GB | 400 GB NVMe | 32 TB | US$ 25,99/mês | US$ 49,99/mês |

*\*Preço promocional para contrato de 2 anos. Renovação no valor cheio.*

**Pontos fortes:** Custo muito competitivo — KVM 2 com 8 GB RAM
por ~US$ 9/mês. AMD EPYC. NVMe. Rede 1 Gbps. Backups semanais
automáticos. Terminal Web com IA (Kodee). API pública. Mais de
5 milhões de usuários. Avaliações positivas (Google 4.8/5).

**Pontos fracos:** Preço promocional exige 2 anos de contrato.
Renovação 50-100% mais cara. Suporte humano pode ser demorado.
Sem opção ARM. Painel próprio (hPanel), não cPanel.

**Para o RustDesk:** **KVM 1 (US$ 6,49/mês)** é mais que suficiente
(4 GB RAM, NVMe, 4 TB tráfego). **KVM 2 (US$ 8,99/mês)** é excelente
para produção. O custo é competitivo com a Hetzner para quem prefere
um ecossistema mais voltado a iniciantes (painel, IA, suporte).
⚠️ O contrato de 2 anos é a principal desvantagem.

### 4.8 HostGator (US/Global)

A HostGator (propriedade da Newfold Digital) oferece VPS nos
Estados Unidos com servidores AMD EPYC, DDR5 e NVMe. Os planos
são da linha **Snappy NVMe**.

| Plano | vCPU | RAM | Disco | Tráfego | Preço promocional\* | Preço renovação |
|---|---|---|---|---|---|---|
| **Snappy 2000** | **2** | **4 GB DDR5** | **100 GB NVMe** | **Ilimitado** | **US$ 34,99/mês** | US$ 53,99/mês |
| Snappy 4000 | 4 | 8 GB DDR5 | 200 GB NVMe | Ilimitado | US$ 53,99/mês | US$ 83,99/mês |
| Snappy 8000 | 8 | 16 GB DDR5 | 450 GB NVMe | Ilimitado | US$ 82,99/mês | US$ 128,99/mês |

*\*Preço promocional para contrato de 3 anos. Renovação no valor cheio.*
*cPanel/WHM: US$ 12/mês adicionais (opcional).*

**Pontos fortes:** Hardware moderno (AMD EPYC, DDR5, NVMe).
Tráfego ilimitado. 1 IP dedicado incluso. Datacenter Tier 3.
Suporte 24h em inglês. 30 dias de garantia. Marca consolidada
(desde 2002, 2M+ sites).

**Pontos fracos:** **Preço muito elevado** — Snappy 2000 custa
~US$ 35/mês (promo) contra ~US$ 4/mês da Hetzner para 4 GB RAM.
Renovação mais cara ainda (US$ 54/mês). cPanel é pago à parte
(US$ 12/mês). Performance não justifica o custo. Sem datacenter
fora dos EUA. Variação de preço entre regiões.

**Para o RustDesk:** **Não recomendado.** O plano de entrada
(Snappy 2000, US$ 35/mês) custa ~8x mais que a Hetzner CX22
(~US$ 4/mês) com a mesma RAM. A única vantagem seria a marca
consolidada, mas o custo-benefício é muito baixo comparado a
qualquer concorrente direto. Prefira Hetzner, Contabo ou Hostinger.

---

## 5. Provedores Nacionais (Brasil)

Para empresas brasileiras que precisam de **cobrança em reais**, **suporte
em português** e **datacenter no Brasil** (LGPD).

### 5.1 Locaweb

| Plano | vCPU | RAM | Disco | Tráfego | Preço promocional | Preço regular |
|---|---|---|---|---|---|---|
| VPS 512 MB | 1 | 512 MB | 20 GB SSD | 1 TB | R$ 15,90/mês | R$ 17,90/mês |
| VPS 1 GB | 1 | 1 GB | 30 GB SSD | 2 TB | R$ 29,90/mês | R$ 31,90/mês |
| **VPS 2 GB** | **1** | **2 GB** | **40 GB SSD** | **3 TB** | **R$ 39,90/mês** | **R$ 47,90/mês** |
| VPS 4 GB | 2 | 4 GB | 60 GB SSD | 4 TB | R$ 69,90/mês | R$ 115,90/mês |
| VPS 8 GB | 2 | 8 GB | 120 GB SSD | 5 TB | R$ 139,90/mês | R$ 209,90/mês |

**Pontos fortes:** Datacenter próprio no Brasil (São Paulo). Marca
consolidada (desde 1998). Suporte em português 24h. Painel próprio.
Cobrança em reais sem IOF.

**Pontos fracos:** Especificações modestas pelo preço. Apenas 1 vCPU até
o plano de 4 GB. SSD não NVMe em planos básicos.

**Para o RustDesk:** Plano **VPS 2 GB (R$ 39,90/mês)** é o mínimo viável.

### 5.2 KingHost

| Plano | vCPU | RAM | Disco | Tráfego | Preço |
|---|---|---|---|---|---|
| **VPS 1 GB** | **1** | **1 GB** | **50 GB SSD** | **Ilimitado** | **R$ 22,90/mês** |
| VPS 4 GB | 2 | 4 GB | 70 GB SSD | Ilimitado | R$ 47,90/mês |
| VPS 8 GB | 6 | 8 GB | 170 GB SSD | Ilimitado | R$ 189,90/mês |

**Pontos fortes:** Tráfego ilimitado. Suporte brasileiro elogiado.
Painel próprio. Datacenter no Brasil. Pagamento em reais.

**Pontos fracos:** Performance não é a melhor da categoria. Catálogo
limitado (sem DBaaS, Kubernetes).

**Para o RustDesk:** Plano **VPS 1 GB (R$ 22,90/mês)** com tráfego
ilimitado é excelente custo-benefício.

### 5.3 HostGator Brasil

| Plano | vCPU | RAM | Disco | Tráfego | Preço |
|---|---|---|---|---|---|
| VPS 2 GB | 2 | 2 GB | 40 GB SSD | Ilimitado | ~R$ 44,99/mês |
| VPS 4 GB | 4 | 4 GB | 160 GB SSD | Ilimitado | ~R$ 86,29/mês |

**Pontos fortes:** Marca consolidada (Endurance Group, desde 2002).
Tráfego ilimitado. 2 IPs dedicados grátis. WHM/cPanel opcional.
Suporte em português 24h. Datacenter no Brasil.

**Pontos fracos:** Performance mediana comparada a concorrentes.
Preço promocional apenas no primeiro ciclo — renovação significativamente
mais cara. Sem opção NVMe nos planos básicos.

**Para o RustDesk:** Plano **VPS 2 GB (R$ 44,99/mês)** é suficiente
para uso pessoal, mas o preço de renovação mais alto que concorrentes
nacionais (KingHost, Audaks) reduz a vantagem no longo prazo. Prefira
apenas se já usa o ecossistema HostGator ou precisa de cPanel.

### 5.4 Audaks Cloud

| Plano | vCPU | RAM | Disco | Tráfego | Preço |
|---|---|---|---|---|---|
| Cloud Server | 2 | 4 GB | 100 GB NVMe | Ilimitado | R$ 39,90/mês |

**Pontos fortes:** NVMe enterprise. Suporte via WhatsApp 24h.
Datacenter SP Tier III. Foco B2B. Pagamento em reais.

**Para o RustDesk:** Excelente relação custo-benefício para produção.

### 5.5 Umbler

| Plano | vCPU | RAM | Disco | Tráfego | Preço |
|---|---|---|---|---|---|
| Cloud Pro | 2 | 2 GB | 80 GB NVMe | 500 GB | R$ 49,90/mês |

**Pontos fortes:** Interface moderna. Git push to deploy. Suporte
técnico brasileiro. NVMe.

### 5.6 Hostinger Brasil

A Hostinger é uma empresa lituana com forte presença global e
operações localizadas no Brasil (hostinger.com.br), oferecendo
suporte em português, pagamento em reais e servidores mundiais.

| Plano | vCPU | RAM | Disco | Tráfego | Preço promocional\* | Preço renovação |
|---|---|---|---|---|---|---|
| **KVM 1** | **1** | **4 GB** | **50 GB NVMe** | **4 TB** | **R$ 29,99/mês** | R$ 59,99/mês |
| KVM 2 | 2 | 8 GB | 100 GB NVMe | 8 TB | R$ 43,99/mês | R$ 77,99/mês |
| KVM 4 | 4 | 16 GB | 200 GB NVMe | 16 TB | R$ 59,99/mês | R$ 149,99/mês |
| KVM 8 | 8 | 32 GB | 400 GB NVMe | 32 TB | R$ 119,99/mês | R$ 259,99/mês |

*\*Preço promocional para plano de 2 anos. Renovação no valor cheio.*

**Pontos fortes:** **Melhor custo-benefício entre provedores nacionais.**
Processadores AMD EPYC. Armazenamento NVMe em todos os planos.
Rede de 1 Gbps. Backups semanais grátis. Terminal Web com IA
embutida (Kodee) que gerencia o servidor por linguagem natural.
Suporte 24h em português. Domínio grátis por 1 ano. API pública.

**Pontos fracos:** Preço promocional exige contrato de 2 anos.
Renovação mais que dobra o valor. Suporte humano pode ser lento
em horários de pico. Sem datacenter próprio no Brasil (servidores
mundiais). Alguns recursos de IA ainda em maturação.

**Para o RustDesk:** Plano **KVM 1 (R$ 29,99/mês)** é o melhor
custo-benefício entre provedores nacionais — 4 GB RAM é muito
superior ao mínimo necessário. O **KVM 2 (R$ 43,99/mês)** é ideal
para quem espera crescimento. A combinação NVMe + 1 Gbps garante
performance excelente para relay. ⚠️ Atente ao prazo de 2 anos
para manter o preço promocional.

---

## 6. Comparativo Completo

### 6.1 Internacional — Melhor Custo-Benefício

| Provedor | Plano inicial | vCPU | RAM | Disco | Tráfego | Preço/mês | Custo/RAM |
|---|---|---|---|---|---|---|---|
| Oracle Cloud | Always Free | 4 | 24 GB | 200 GB | 10 TB | **US$ 0** | US$ 0 |
| **Hetzner** | CAX11 | **2** | **4 GB** | **40 GB NVMe** | **20 TB** | **~US$ 4** | **US$ 1,00** |
| Contabo | VPS S | 4 | 8 GB | 50 GB NVMe | 32 TB | ~US$ 5 | US$ 0,63 |
| Hostinger\* | KVM 1 | **1** | **4 GB** | **50 GB NVMe** | **4 TB** | **~US$ 6,50** | **US$ 1,62** |
| IONOS | VPS Linux M | 1 | 2 GB | 80 GB | Ilimitado | US$ 6 | US$ 3,00 |
| BuyVM | Slice 1024 | 1 | 1 GB | 20 GB SSD | Ilimitado | US$ 3,50 | US$ 3,50 |
| Lightsail† | $7/mês | **2** | **1 GB** | 40 GB SSD | **2 TB** | **US$ 7** | US$ 7,00 |
| Vultr | Cloud Compute | 1 | 1 GB | 25 GB | 1 TB | US$ 6 | US$ 6,00 |
| DigitalOcean | Basic | 1 | 1 GB | 25 GB | 1 TB | US$ 6 | US$ 6,00 |
| Linode | Nanode | 1 | 2 GB | 50 GB | 2 TB | US$ 7 | US$ 3,50 |
| OVHcloud | Starter | 1 | 2 GB | 40 GB | Ilimitado | ~US$ 5 | US$ 2,50 |
| HostGator | Snappy 2000 | 2 | 4 GB DDR5 | 100 GB NVMe | Ilimitado | US$ 35 | US$ 8,75 |

*\*Hostinger: preço promocional (2 anos). Renovação: ~US$ 12/mês.*
*†Lightsail: plano mínimo viável para RustDesk ($7/mês com 1 GB RAM).
Plano de entrada ($5/mês com 512 MB) é insuficiente para Ubuntu.*

### 6.2 Nacional (Brasil) — Convertido para US$

| Provedor | Plano | vCPU | RAM | Disco | Tráfego | Preço (R$) | Preço (US$*) |
|---|---|---|---|---|---|---|---|
| **KingHost** | VPS 1 GB | 1 | 1 GB | 50 GB SSD | Ilimitado | R$ 22,90 | ~US$ 4,50 |
| **Hostinger**\* | **KVM 1** | **1** | **4 GB** | **50 GB NVMe** | **4 TB** | **R$ 29,99** | **~US$ 6,00** |
| Audaks | Cloud Server | 2 | 4 GB | 100 GB NVMe | Ilimitado | R$ 39,90 | ~US$ 8,00 |
| Locaweb | VPS 2 GB | 1 | 2 GB | 40 GB SSD | 3 TB | R$ 39,90 | ~US$ 8,00 |
| HostGator | VPS 2 GB | 2 | 2 GB | 40 GB SSD | Ilimitado | R$ 44,99 | ~US$ 9,00 |
| KingHost | VPS 4 GB | 2 | 4 GB | 70 GB SSD | Ilimitado | R$ 47,90 | ~US$ 9,50 |
| Umbler | Cloud Pro | 2 | 2 GB | 80 GB NVMe | 500 GB | R$ 49,90 | ~US$ 10,00 |
| Locaweb | VPS 4 GB | 2 | 4 GB | 60 GB SSD | 4 TB | R$ 69,90 | ~US$ 14,00 |

*\*Hostinger: preço promocional para 2 anos. Renovação: R$ 59,99/mês.
Hostinger não possui datacenter no Brasil — servidores no exterior.*

*Conversão aproximada: US$ 1 = R$ 5,00 (junho/2026)

### 6.3 Performance (Benchmarks)

| Provedor | Geekbench 6 Single | 4K Read IOPS | 4K Write IOPS | Rede (Mbps) |
|---|---|---|---|---|
| Hetzner | 1.420 | **58.000** | 19.500 | 940 |
| Vultr | 1.380 | 55.000 | 18.000 | 950 |
| Linode | 1.350 | 52.000 | 17.500 | 940 |
| DigitalOcean | 1.340 | 50.000 | 17.000 | 940 |
| OVHcloud | 1.280 | 35.000 | 13.000 | 500 |
| **Hostinger** | **1.200** | **30.000** | **12.000** | **900** |
| BuyVM | 1.180 | 45.000 | 15.000 | 950 |
| HostGator | 1.150 | 28.000 | 11.500 | 940 |
| Contabo | 980 | 12.000 | 8.200 | 200 |

> Fonte: [VPSBenchmarks 2026](https://www.vpsbenchmarks.com/)

---

## 7. Como Escolher o Provedor Ideal

### Matriz de Decisão

Responda às perguntas abaixo para encontrar o provedor ideal:

**1. Qual seu orçamento mensal?**

| Orçamento | Provedor indicado |
|---|---|---|
| US$ 0 (gratuito) | Oracle Cloud Free Tier |
| US$ 3-5/mês | Hetzner CX22 / CAX11 |
| US$ 5-10/mês | Contabo VPS S, Lightsail $7, **Hostinger KVM 1** |
| US$ 10-20/mês | Hetzner CX32, Lightsail $12, **Hostinger KVM 2** |

**2. Precisa de datacenter no Brasil?**

| Resposta | Provedor indicado |
|---|---|
| Sim | KingHost, Locaweb, Audaks, HostGator BR, **Lightsail (SP)** |
| Não (pode ser exterior) | Hetzner, Contabo, **Hostinger**, Lightsail |

**3. Quantos dispositivos usarão o RustDesk?**

| Dispositivos | Plano mínimo |
|---|---|
| 1-10 | 1 vCPU / 1 GB RAM |
| 10-50 | 2 vCPU / 2 GB RAM |
| 50-200 | 2 vCPU / 4 GB RAM |
| 200+ | 4 vCPU / 8 GB RAM |

**4. Qual o nível de suporte necessário?**

| Necessidade | Provedor |
|---|---|
| Suporte 24h em português | Locaweb, KingHost, Audaks, **Hostinger** |
| Suporte por ticket (inglês) | Hetzner, **HostGator** |
| Autoatendimento (docs + comunidade) | DigitalOcean, Vultr, **Hostinger** |

### Árvore de Decisão

```
Precisa de datacenter no Brasil?
├── Sim
│   ├── Orçamento até R$ 25/mês?
│   │   └── KingHost VPS 1 GB (R$ 22,90)
│   ├── Orçamento até R$ 30/mês?
│   │   ├── Hostinger KVM 1 (R$ 29,99) — 4 GB RAM, NVMe ← melhor custo
│   │   └── KingHost VPS 1 GB (R$ 22,90) — DC Brasil
│   ├── Orçamento até R$ 40/mês?
│   │   ├── KingHost VPS 4 GB (R$ 47,90) — +RAM
│   │   ├── Locaweb VPS 2 GB (R$ 39,90) — marca consolidada
│   │   └── Hostinger KVM 2 (R$ 43,99) — 8 GB RAM, NVMe
│   ├── Orçamento até R$ 50/mês?
│   │   ├── Audaks Cloud (R$ 39,90) — NVMe + suporte WhatsApp
│   │   └── Lightsail $7 (US$ 7) — ecossistema AWS, SP
│   └── Orçamento até R$ 70/mês?
│       └── Lightsail $12 (US$ 12) — 2 GB RAM, AWS SP
│
└── Não (servidor no exterior)
    ├── Orçamento zero?
    │   └── Oracle Cloud Free Tier (US$ 0)
    ├── Melhor custo-benefício?
    │   ├── Hetzner CAX11 / CX22 (US$ 4-5)
    │   └── Hostinger KVM 1 (US$ 6,50) — 4 GB RAM, NVMe
    ├── Máxima RAM por dólar?
    │   └── Contabo VPS S (US$ 5)
    ├── Quer ecossistema AWS?
    │   └── Lightsail $7 (US$ 7)
    └── Precisa de suporte 24h em português?
        └── Hostinger (US$ 6,50) — chat em português, IA inclusa
```

---

## 8. Passo a Passo: Contratação e Provisionamento

### 8.1 Contratando na Hetzner (recomendado)

```text
1. Acesse https://cloud.hetzner.com
2. Crie uma conta (e-mail + senha + verificação)
3. Adicione forma de pagamento (cartão de crédito ou PayPal)
4. Clique em "Create Project" → dê um nome (ex: "RustDesk")
5. Clique em "Add Server"
6. Configure:
   - Location: Nuremberg (Alemanha) — menor latência para Brasil
   - Image: Ubuntu 24.04 LTS
   - Type: CX22 (2 vCPU / 4 GB / 40 GB NVMe)
   - Firewall: crie um novo com as portas 21115, 21116, 21117
   - SSH Keys: adicione sua chave pública (ou crie uma senha)
   - Name: rustdesk-server
7. Clique em "Create & Buy Now"
8. Anote o IP atribuído ao servidor
```

### 8.2 Contratando na KingHost (Brasil)

```text
1. Acesse https://king.host/servidor-vps
2. Escolha o plano (recomendado: VPS 1 GB ou VPS 4 GB)
3. Clique em "Contratar"
4. Configure:
   - Sistema: Ubuntu 24.04 LTS
   - Período: mensal (ou anual para desconto)
5. Preencha seus dados e forma de pagamento
6. Após a aprovação, acesse o painel de controle
7. Anote o IP do servidor e a senha root
```

### 8.3 Contratando na Locaweb (Brasil)

```text
1. Acesse https://www.locaweb.com.br/servidor-vps
2. Escolha o plano: VPS 2 GB (mínimo recomendado)
3. Configure:
   - Sistema Operacional: Ubuntu 24.04 LTS
   - Período: mensal
4. Finalize a compra com seus dados
5. Acesse o painel Locaweb para obter IP e senha
```

### 8.4 Oracle Cloud Free Tier

```text
1. Acesse https://signup.cloud.oracle.com
2. Preencha: país, nome, e-mail, empresa
3. Verifique o e-mail e celular
4. Adicione cartão de crédito (para verificação, não será cobrado)
5. Após aprovação (pode levar horas ou dias):
   - Acesse o console OCI
   - Crie uma instância VM.Standard.A1.Flex
   - Configure: 4 vCPU, 24 GB RAM, 200 GB disco
   - Sistema: Ubuntu 24.04 LTS (ou Canonical Ubuntu)
   - Adicione chave SSH
6. Anote o IP público da instância
```

> ⚠️ A criação de conta na Oracle Cloud pode ser rejeitada sem explicação.
> Não é um serviço confiável para produção, mas excelente para testes.

### 8.5 Amazon Lightsail

```text
1. Acesse https://lightsail.aws.amazon.com
2. Faça login na sua conta AWS (ou crie uma gratuitamente)
3. Clique em "Create instance"
4. Configure:
   - Region: "São Paulo" (sa-east-1) — menor latência para o Brasil
   - Platform: "Linux/Unix"
   - Blueprint: "OS Only" → "Ubuntu 24.04 LTS"
   - Plan: "$7 USD/mês" (1 GB RAM, 40 GB SSD) ou "$12" (2 GB)
   - Instance name: rustdesk-server
   - SSH Keys: faça download ou adicione chave pública existente
5. Clique em "Create instance"
6. Após a criação, anote o IP público (IPv4) em "Networking"
7. Configure o firewall:
   - Networking → IPv4 Firewall → "Add rule"
   - Adicione: TCP 21115, TCP+UDP 21116, TCP 21117
   - Mantenha SSH (22) liberado apenas para IPs confiáveis
```

> 💡 O Lightsail inclui **3 meses grátis** nos planos $5, $7 e $12
> (IPv4) para novas contas AWS. Após o período, a cobrança mensal
> inicia automaticamente.

> ⚠️ Diferente da Hetzner, o Lightsail não fornece acesso root por
> senha — você deve usar **chave SSH** obrigatoriamente. Se perder a
> chave, use o recurso "Connect" no console da AWS para acesso direto
> via browser e reconfigurar a chave.

---

## 9. Configuração do Servidor

### 9.1 Acesso Inicial (SSH)

Após contratar a VPS, acesse via SSH:

```bash
# Com chave SSH (recomendado)
ssh root@<IP_DA_VPS>

# Ou com senha (se o provedor forneceu)
ssh root@<IP_DA_VPS>
# Digite a senha quando solicitado
```

### 9.2 Configuração Inicial (Recomendada)

```bash
# 1. Atualizar o sistema
apt update && apt upgrade -y

# 2. Criar usuário não-root
adduser rustdesk
usermod -aG sudo rustdesk

# 3. Configurar SSH com chave (copie sua chave pública)
mkdir -p /home/rustdesk/.ssh
echo "sua-chave-ssh-publica-aqui" >> /home/rustdesk/.ssh/authorized_keys
chown -R rustdesk:rustdesk /home/rustdesk/.ssh
chmod 700 /home/rustdesk/.ssh
chmod 600 /home/rustdesk/.ssh/authorized_keys

# 4. Desabilitar login por senha SSH (opcional, mas recomendado)
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

# 5. Configurar firewall
ufw allow OpenSSH
ufw allow 21115:21117/tcp
ufw allow 21116/udp
ufw enable

# 6. Configurar swap (se tiver <= 2 GB RAM)
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# 7. Instalar Docker
bash <(wget -qO- https://get.docker.com)

# 8. Iniciar RustDesk
mkdir -p ~/rustdesk-data
docker run -d --name hbbs \
  -v ~/rustdesk-data:/root \
  -p 21115:21115/tcp \
  -p 21116:21116/tcp \
  -p 21116:21116/udp \
  --restart unless-stopped \
  rustdesk/rustdesk-server:latest hbbs

docker run -d --name hbbr \
  -v ~/rustdesk-data:/root \
  -p 21117:21117/tcp \
  --restart unless-stopped \
  rustdesk/rustdesk-server:latest hbbr

# 9. Obter chave pública
cat ~/rustdesk-data/id_ed25519.pub
```

### 9.3 Script Automático de Provisionamento

Use o script `scripts/provision-vps.sh` para automatizar toda a configuração
acima:

```bash
# Envie o script para a VPS e execute
scp scripts/provision-vps.sh root@<IP_DA_VPS>:~/
ssh root@<IP_DA_VPS>
chmod +x provision-vps.sh
./provision-vps.sh
```

---

## 10. Segurança em VPS

### 10.1 Boas Práticas Essenciais

| Prática | Como fazer |
|---|---|
| **SSH com chave** | Desabilite `PasswordAuthentication yes` |
| **Firewall** | UFW ou iptables — libere apenas as portas necessárias |
| **Portas mínimas** | 22 (SSH), 21115-21117 TCP, 21116 UDP |
| **Fail2ban** | Bloqueia tentativas de força bruta no SSH |
| **Atualizações** | Configure `unattended-upgrades` |
| **Usuário não-root** | Crie um usuário sudo, desabilite login root SSH |
| **Snapshots** | Faça snapshots periódicos no painel do provedor |

### 10.2 Configuração de Firewall na VPS

```bash
# Regras mínimas para RustDesk
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh                # Porta 22
ufw allow 21115:21117/tcp    # RustDesk
ufw allow 21116/udp          # RustDesk UDP
ufw enable
```

### 10.3 Fail2ban

```bash
apt install -y fail2ban
systemctl enable --now fail2ban
```

### 10.4 Atualizações Automáticas de Segurança

```bash
apt install -y unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades
```

### 10.5 Firewall do Provedor (Recomendado)

Além do firewall no sistema operacional, configure o **firewall do provedor**
( disponível no painel da VPS):

```
Regras:
  - SSH (22/TCP) — liberado apenas para IPs confiáveis
  - RustDesk TCP (21115-21117) — liberado para qualquer origem
  - RustDesk UDP (21116) — liberado para qualquer origem
  - Demais portas — bloqueadas
```

> **Vantagem:** O firewall do provedor atua antes mesmo do tráfego chegar
> ao servidor, filtrando ataques antes de consumirem recursos.

---

## 11. Manutenção e Monitoramento

### 11.1 Atualizações Mensais

```bash
# Conecte-se à VPS e execute:
apt update && apt upgrade -y
docker pull rustdesk/rustdesk-server:latest
docker restart hbbs hbbr
```

### 11.2 Monitoramento de Recursos

```bash
# Uso de disco
df -h

# Uso de RAM e CPU
htop

# Tráfego de rede
vnstat

# Logs do RustDesk
docker logs hbbs --tail=20
docker logs hbbr --tail=20
```

### 11.3 Backup (Snapshots)

No painel do provedor, configure snapshots automáticos:

| Provedor | Como fazer |
|---|---|
| Hetzner | Servers → Snapshots → agendar diário |
| KingHost | Painel → VPS → Snapshots |
| Locaweb | Painel → VPS → Backup |
| DigitalOcean | Droplets → Snapshots |

### 11.4 Alertas de Uso

Configure alertas no painel do provedor para:

- **CPU** > 80% por mais de 10 minutos
- **RAM** > 85%
- **Disco** > 85%
- **Tráfego** > 80% do limite mensal

---

## 12. Custos

### 12.1 Tabela de Custos Anuais

| Provedor | Plano | Mensal | Anual | 3 anos |
|---|---|---|---|---|
| Oracle Cloud | Free | US$ 0 | US$ 0 | US$ 0 |
| **Hetzner** | **CX22** | **~€3,79** | **~€45** | **~€136** |
| Contabo | VPS S | €4,50 | €54 | €162 |
| KingHost | VPS 1 GB | R$ 22,90 | R$ 275 | R$ 824 |
| Locaweb | VPS 2 GB | R$ 39,90 | R$ 479 | R$ 1.436 |
| DigitalOcean | Basic 1 GB | US$ 6 | US$ 72 | US$ 216 |
| Vultr | 1 GB | US$ 6 | US$ 72 | US$ 216 |

### 12.2 Custos Adicionais

| Item | Custo estimado |
|---|---|
| Domínio (.com.br) | ~R$ 40/ano |
| Cloudflare (plano grátis) | US$ 0 |
| Certificado SSL (Let's Encrypt) | US$ 0 |
| Backup externo (opcional) | ~US$ 2-5/mês |

### 12.3 Comparativo: VPS vs. Servidor Local (3 anos)

| Item | VPS (Hetzner CX22) | Servidor Local (Raspberry Pi 5) |
|---|---|---|
| Hardware | Incluso | ~R$ 1.200 |
| Energia | Incluso | ~R$ 300 (15W × 24h × 3a × R$ 0,80/kWh) |
| Manutenção | Provedor responsável | Você responsável |
| Internet | Incluso (redundante) | Sua conexão (pode cair) |
| **Total 3 anos** | **~R$ 900 (US$ 180)** | **~R$ 1.500** |

> **Conclusão:** Para a maioria dos casos, a VPS **sai mais barato** que um
> servidor local quando consideramos todos os custos (hardware + energia +
> internet + manutenção).

---

## 13. Recomendações Finais

### Cenários e Escolhas

| Seu perfil | Escolha |
|---|---|
| **Testar/experimentar (custo zero)** | Oracle Cloud Free Tier |
| **Uso pessoal, melhor custo-benefício** | **Hetzner CX22/CAX11** (~US$ 4/mês) |
| **Uso pessoal, prefere painel + suporte** | **Hostinger KVM 1** (US$ 6,50/mês, 4 GB RAM) |
| **Precisa de datacenter no Brasil** | **KingHost VPS 1 GB** (R$ 22,90/mês) |
| **Equipe pequena/média no Brasil** | **KingHost VPS 4 GB** (R$ 47,90/mês) ou **Audaks** (R$ 39,90/mês) |
| **Melhor custo-benefício no Brasil** | **Hostinger KVM 1 (R$ 29,99/mês)** — 4 GB, NVMe |
| **Datacenter SP + ecossistema AWS** | **Lightsail $7** (US$ 7/mês, 1 GB RAM, SP) |
| **Equipe pequena, AWS SP** | **Lightsail $12** (US$ 12/mês, 2 GB RAM) |
| **Produção crítica, sem restrição de preço** | Hetzner CX32 (8 GB) ou DigitalOcean 4 GB |
| **Orçamento apertado, máx RAM** | Contabo VPS S (~US$ 5/mês, 8 GB RAM) |
| **Prefere ecossistema (apps, docs)** | DigitalOcean (US$ 6/mês) |

### Regra de Ouro

> **"O RustDesk é tão leve que a VPS mais barata do mercado é suficiente.
> Invista o dinheiro economizado em banda larga e backups."**

### Próximos Passos

1. Escolha o provedor com base na matriz de decisão acima
2. Contrate o plano (siga o passo a passo da seção 8)
3. Execute o script de provisionamento (`scripts/provision-vps.sh`)
4. Configure os clientes com o IP da VPS e a chave pública
5. (Opcional) Configure Cloudflare Tunnel + WARP para segurança adicional

---

## Apêndice: Comandos Úteis para VPS

```bash
# Verificar IP público
curl -s ifconfig.me

# Verificar uso de disco
df -h

# Verificar uso de RAM
free -h

# Verificar processos por uso de RAM
ps aux --sort=-%mem | head -10

# Verificar tráfego de rede
apt install -y nload && nload

# Verificar portas abertas
ss -tulpn

# Testar velocidade da rede
apt install -y speedtest-cli && speedtest-cli

# Verificar logs de autenticação (tentativas de invasão)
tail -100 /var/log/auth.log | grep "Failed password"

# Verificar uptime
uptime
```

## Referências

- [Hetzner Cloud Documentation](https://docs.hetzner.com/cloud/)
- [KingHost VPS](https://king.host/servidor-vps)
- [Locaweb VPS](https://www.locaweb.com.br/servidor-vps)
- [Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/)
- [Amazon Lightsail Pricing](https://aws.amazon.com/lightsail/pricing/)
- [Amazon Lightsail Documentation](https://docs.aws.amazon.com/lightsail/)
- [Hostinger VPS Global](https://www.hostinger.com/vps-hosting)
- [Hostinger VPS Brasil](https://www.hostinger.com.br/servidor-vps)
- [HostGator VPS US](https://www.hostgator.com/vps-hosting)
- [DigitalOcean Documentation](https://docs.digitalocean.com)
- [Contabo VPS](https://contabo.com/en/vps/)
- [VPSBenchmarks 2026](https://www.vpsbenchmarks.com)

---

