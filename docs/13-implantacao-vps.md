# Implantação do Servidor RustDesk em VPS

> **Para:** Colaborador responsável pela instalação
> **Nível:** Iniciante absoluto (não precisa saber Linux)
> **Tempo estimado:** 30 a 60 minutos no total
> **Custo:** A partir de US$ 0 (Oracle grátis) ou ~R$ 23/mês (KingHost)

---

## Sumário

1. [O que é este guia?](#1-o-que-é-este-guia)
2. [O que é uma VPS?](#2-o-que-é-uma-vps)
3. [O que você precisa antes de começar](#3-o-que-você-precisa-antes-de-começar)
4. [Escolhendo onde contratar a VPS](#4-escolhendo-onde-contratar-a-vps)
5. [Contratando a VPS](#5-contratando-a-vps)
6. [Acessando a VPS pela primeira vez](#6-acessando-a-vps-pela-primeira-vez)
7. [Executando o script de instalação](#7-executando-o-script-de-instalação)
8. [O que o script faz (explicado em português)](#8-o-que-o-script-faz-explicado-em-português)
9. [Verificando se está tudo funcionando](#9-verificando-se-está-tudo-funcionando)
10. [Obtendo a chave do servidor](#10-obtendo-a-chave-do-servidor)
11. [Manutenção básica](#11-manutenção-básica)
12. [Problemas comuns e soluções](#12-problemas-comuns-e-soluções)
13. [Glossário](#13-glossário)
14. [Anexo: Informações do Servidor](#14-anexo-informações-do-servidor)

---

## 1. O que é este guia?

Este guia ensina **passo a passo** como colocar o servidor RustDesk no ar em uma
**VPS** (um computador na nuvem). Depois de seguir este guia, você terá um
servidor próprio de acesso remoto, pronto para receber conexões dos seus
computadores.

> ⚠️ **Importante:** Este guia é a **Etapa 1** da implantação. Depois que o
> servidor estiver rodando, você deve ir para o guia de **Implantação do
> Cloudflare** (se quiser acesso pela internet) ou configurar os clientes
> diretamente (se for usar apenas na rede local).

---

## 2. O que é uma VPS?

**VPS** quer dizer "Virtual Private Server" (Servidor Virtual Privado).

### Explicação simples

Imagine que você tem um **computador invisível** que fica ligado 24 horas por dia
em um data center (uma sala cheia de computadores). Você pode instalar programas
nele, acessá-lo de qualquer lugar, e ele nunca desliga — diferente do seu
computador pessoal que você desliga todo dia.

Uma VPS é como **alugar um computador na internet**.

### Por que precisamos de uma VPS para o RustDesk?

O RustDesk precisa de um servidor que:
- Fique **ligado 24 horas por dia** (seu PC em casa talvez desligue)
- Tenha um **endereço fixo na internet** (seu IP residencial muda)
- Esteja sempre **acessível** (se cair a luz em casa, o servidor para)

### Opção gratuita

O **Oracle Cloud** oferece uma VPS **completamente gratuita** (24 GB de RAM,
4 cores de processador). Perfeita para testar ou para uso pessoal.

### Opções pagas (a partir de ~R$ 23/mês)

Se você quiser algo mais simples de configurar, provedores como **KingHost**,
**Hostinger** e **Hetzner** oferecem VPS por preços que cabem no bolso.

---

## 3. O que você precisa antes de começar

### Obrigatório

| Item | Exemplo |
|---|---|
| Um **cartão de crédito** ou **PIX** para pagar a VPS | Mastercard, Visa ou PIX |
| Um **email** para criar a conta no provedor | seu@email.com |
| Um **caderno e caneta** (ou bloco de notas) | Para anotar IP, senha e chave |

### Recomendado (mas não obrigatório)

| Item | Por que |
|---|---|
| Um **celular** com WhatsApp | Para receber instruções e compartilhar dados |
| Acesso a um **computador Windows, Mac ou Linux** | Para fazer a instalação |

### O que NÃO precisa

- ❌ Não precisa saber programação
- ❌ Não precisa entender de Linux
- ❌ Não precisa ter servidor em casa
- ❌ Não precisa de conhecimentos em rede

---

## 4. Escolhendo onde contratar a VPS

### Resumo rápido (quem escolher)

| Seu caso | Escolha este | Custo |
|---|---|---|
| Quer **testar grátis** | Oracle Cloud Free Tier | **US$ 0** (grátis) |
| Quer o **mais barato** | Hetzner CAX11 | ~€ 3,79/mês (~R$ 23) |
| Quer **pagamento no Brasil** | KingHost 1 GB | R$ 22,90/mês |
| Quer **suporte em português** | Hostinger Brasil KVM 1 | R$ 29,99/mês (promoção) |
| Precisa de **servidor em São Paulo** | Lightsail (AWS) | US$ 7/mês (~R$ 38) |

### O plano mínimo necessário

Qualquer VPS que você contratar precisa ter no **mínimo** estas configurações:

| Item | Mínimo | Recomendado |
|---|---|---|
| Memória (RAM) | 1 GB | 2 GB |
| Processador (CPU) | 1 núcleo | 2 núcleos |
| Disco | 10 GB | 20 GB |
| Sistema Operacional | Ubuntu 22.04 ou 24.04 | Ubuntu 24.04 |

> 💡 **Dica:** Todos os provedores listados acima já oferecem planos com
> essas configurações mínimas.

---

## 5. Contratando a VPS

### 5.1 Se escolheu Oracle Cloud (grátis)

A Oracle Cloud Free Tier é um pouco mais complicada de configurar, mas é
**totalmente gratuita** para sempre. Como é mais complexa, recomendamos que
você veja o tutorial específico em: **docs/09-vps.md** (seção Oracle Cloud).

### 5.2 Se escolheu KingHost (Brasil, R$ 22,90/mês)

**Passo a passo:**

1. Acesse o site: https://www.kinghost.com.br/vps
2. Clique em "**VPS Linux**"
3. Escolha o plano **VPS 1 GB** (R$ 22,90/mês)
4. Clique em "**Contratar**"
5. Faça seu cadastro (nome, email, CPF/CNPJ)
6. Na tela de configuração:
   - **Sistema:** escolha **Ubuntu 24.04 LTS**
   - **Acesso:** anote a senha que aparecer
7. Escolha a forma de pagamento (cartão ou PIX)
8. Confirme a contratação
9. Você receberá um email com:
   - **IP da VPS** (ex: `177.54.32.10`)
   - **Senha de root**

### 5.3 Se escolheu Hostinger Brasil (R$ 29,99/mês promoção)

**Passo a passo:**

1. Acesse: https://www.hostinger.com.br/vps
2. Escolha o plano **KVM 1** (4 GB RAM, 50 GB NVMe)
3. Clique em "**Contratar**"
4. Crie sua conta (email e senha)
5. Na configuração:
   - **Sistema:** Ubuntu 24.04
   - **Localização:** escolha o datacenter mais próximo
6. Faça o pagamento (cartão ou PIX)
7. Após o pagamento, você verá no painel:
   - **IP da VPS**
   - **Usuário e senha** para acessar

### 5.4 Se escolheu Hetzner (global, ~€ 3,79/mês)

**Passo a passo:**

1. Acesse: https://www.hetzner.com/cloud
2. Crie uma conta (precisa de documento e cartão de crédito)
3. No painel, clique em "**Create a Project**"
4. Clique em "**Add Server**"
5. Escolha:
   - **Location:** Nuremberg ou Helsinki
   - **Image:** Ubuntu 24.04
   - **Type:** CX22 (2 vCPU, 4 GB RAM) — ~€ 3,79/mês
6. Adicione sua **chave SSH** (veja seção abaixo)
7. Clique em "**Create**"
8. Anote o **IP** que aparecer

> 💡 **Hetzner usa chave SSH em vez de senha.** Se isso for complicado,
> prefira KingHost ou Hostinger que são mais simples.

---

## 6. Acessando a VPS pela primeira vez

### 6.1 O que é SSH?

**SSH** é um programa que permite você "entrar" no computador da VPS pela
internet, como se estivesse sentado na frente dele. Você vai digitar comandos
e o computador vai responder.

### 6.2 Como acessar

#### No Windows

1. Abra o **Prompt de Comando** (tecla Windows + R, digite `cmd`, Enter)
2. Digite o comando abaixo, trocando `IP-DA-VPS` pelo IP que você anotou:

```
ssh root@IP-DA-VPS
```

**Exemplo:** Se o IP for `177.54.32.10`, digite:

```
ssh root@177.54.32.10
```

3. Aparecerá uma mensagem: `The authenticity of host... Are you sure?`
   - Digite: **yes** e Enter
4. Agora vai pedir a **senha**:
   - Digite a senha que você recebeu (nada aparece na tela enquanto digita)
   - Enter

**Se deu certo:** você verá algo como:

```
Welcome to Ubuntu 24.04 LTS (GNU/Linux...)
root@vps:~#
```

Isso significa que você está **dentro** do servidor!

> 💡 **Para sair do servidor:** digite `exit` e Enter.

#### No Mac

1. Abra o **Terminal** (botão de pesquisa, procure "Terminal")
2. Digite o mesmo comando do Windows:

```
ssh root@IP-DA-VPS
```

#### No Linux

Abra o **Terminal** e digite:

```
ssh root@IP-DA-VPS
```

### 6.3 Problemas para acessar?

| Problema | Provável causa | Solução |
|---|---|---|
| "Connection refused" | O SSH não está instalado | Espere 5 minutos e tente novamente |
| "Permission denied" | Senha errada | Verifique no email do provedor |
| "Name or service not known" | IP digitado errado | Confira o IP no painel do provedor |
| "Connection timed out" | Firewall bloqueando | Verifique se o provedor liberou a porta 22 |

---

## 7. Executando o script de instalação

Depois de conseguir entrar na VPS (você está vendo `root@vps:~#` na tela),
vamos rodar o **script automático** que faz tudo.

### 7.1 Digite este comando (copie e cole)

**Atenção:** Você precisa estar conectado na VPS (aquele passo anterior).
Não feche a janela!

Digite ou copie este comando e Enter:

```bash
curl -sS https://raw.githubusercontent.com/hsoservicos/myrustdesk/main/scripts/provision-vps.sh | sudo bash
```

### 7.2 O que vai acontecer na tela

O script vai começar a rodar e você verá mensagens coloridas aparecendo:

```
[i] Atualizando pacotes do sistema...
[✓] Sistema atualizado.
[i] RAM detectada: 980 MB. Criando swap de 2048 MB...
[✓] Swap criado.
[i] Instalando Docker...
[✓] Docker instalado.
[✓] UFW configurado.
[i] Iniciando containers RustDesk...
[✓] Containers RustDesk iniciados.
[i] Aguardando geração da chave pública...
```

Cada `[✓]` significa que uma etapa foi concluída com sucesso.
Cada `[i]` é uma informação do que está sendo feito.

**O script leva de 3 a 10 minutos.** Não feche a janela!

### 7.3 Quando terminar

Você verá uma tela parecida com esta:

```
==============================================
  ✅  PROVISIONAMENTO CONCLUÍDO
==============================================

  IP do servidor:  177.54.32.10
  Usuário:         rustdesk
  Diretório dados: /opt/rustdesk-server

  ┌─ Chave Pública ──────────────────────────┐
  │  sjZgcuQSbU8IBfqMh6LhKmWpnjP8f6S8R...  │
  └───────────────────────────────────────────┘

  🔹 Próximos passos:
     1. Configure os clientes com o IP e a chave acima
     2. Para acesso externo, veja docs/07-cloudflare-tunnel.md
     3. Para escolher VPS, veja docs/09-vps.md
```

### 7.4 O que você precisa SALVAR AGORA

Pegue seu **caderno ou bloco de notas** e anote estas informações:

| Informação | Está aqui | Exemplo |
|---|---|---|
| **IP do servidor** | Linha "IP do servidor" | `177.54.32.10` |
| **Chave Pública** | Dentro do quadro | `sjZgcuQSbU8IBfqM...` (textão) |

> ⚠️ **Sem a chave pública, os computadores não conseguem se conectar ao
> servidor!** Guarde com cuidado.

---

## 8. O que o script faz (explicado em português)

Você não precisa entender isso para usar, mas é bom saber o que aconteceu:

| O que o script fez | Traduzindo |
|---|---|
| **Atualizou o sistema** | Baixou as correções mais recentes do Ubuntu |
| **Configurou o fuso horário** | Acertou o relógio para Brasília |
| **Criou swap** | Se o servidor tiver pouca memória, criou um "quebra-galho" no disco |
| **Criou usuário rustdesk** | Fez um "usuário comum" (mais seguro que usar root direto) |
| **Protegeu o SSH** | Só permite entrar com chave de segurança (mais forte que senha) |
| **Instalou Docker** | Programa que roda o RustDesk dentro de uma "caixinha" isolada |
| **Configurou firewall** | Bloqueou tudo, liberou só as portas do RustDesk |
| **Instalou fail2ban** | Segurança: bloqueia quem tentar entrar com senha errada várias vezes |
| **Ativou atualizações automáticas** | O servidor se atualiza sozinho (você não precisa fazer nada) |
| **Iniciou o RustDesk** | Ligou os dois programas do RustDesk (hbbs e hbbr) |
| **Criou manutenção semanal** | Toda semana ele baixa atualizações e reinicia |

---

## 9. Verificando se está tudo funcionando

Depois que o script terminar, você pode verificar se está tudo certo.

### 9.1 Verificar se os programas estão rodando

Digite este comando:

```bash
docker ps
```

Você deve ver uma tabela com **duas linhas** (hbbs e hbbr), assim:

```
CONTAINER ID   IMAGE                                  COMMAND   STATUS         NAMES
abc123def456   rustdesk/rustdesk-server-s6:latest     "hbbs"    Up 2 minutes   hbbs
def456abc123   rustdesk/rustdesk-server-s6:latest     "hbbr"    Up 2 minutes   hbbr
```

> Se aparecer algo como `STATUS: Up`, está funcionando.
> Se aparecer `Exited`, algo deu errado.

### 9.2 Verificar se as portas estão abertas

Digite:

```bash
ss -tulpn | grep -E '2111[5-9]'
```

Deverá mostrar as portas **21115**, **21116** (TCP e UDP) e **21117**.

### 9.3 Verificar se não há erros

```bash
docker logs hbbs --tail=5
```

Deverá mostrar as últimas linhas do log. Se não aparecer "ERROR", está ok.

---

## 10. Obtendo a chave do servidor

Se você perdeu a chave que apareceu na tela, pode recuperá-la com este comando:

```bash
cat /opt/rustdesk-server/id_ed25519.pub
```

Vai aparecer algo como:

```
sjZgcuQSbU8IBfqMh6LhKmWpnjP8f6S8R...
```

> ⚠️ **Esta chave nunca muda.** Guarde-a. Você vai precisar dela para
> configurar cada computador que for usar o RustDesk.

---

## 11. Manutenção básica

### 11.1 O que você NÃO precisa fazer

- **O servidor se atualiza sozinho** (sistema e RustDesk)
- **O firewall já está configurado** (não mexa)
- **O fail2ban já protege** (não precisa configurar)

### 11.2 O que você deve fazer de vez em quando

| Tarefa | Quando | Como |
|---|---|---|
| Verificar se está no ar | Toda semana | Acesse um computador cliente e veja se conecta |
| Verificar uso do disco | A cada 3 meses | `df -h` (veja se não está cheio) |
| Renovar contrato da VPS | No vencimento | Pelo site do provedor |

### 11.3 Para ver os logs (se algo estiver estranho)

```bash
docker logs hbbs --tail=20
docker logs hbbr --tail=20
```

### 11.4 Para reiniciar o servidor manualmente

```bash
docker restart hbbs hbbr
```

---

## 12. Problemas comuns e soluções

### 12.1 "Não consigo entrar na VPS (SSH)"

**Causa mais comum:** você digitou o IP errado.

**Solução:** Verifique no email de confirmação do provedor qual é o IP correto.

### 12.2 "O script deu erro no meio"

**Causa:** Pode ser falta de internet na VPS ou problema temporário.

**Solução:** Execute o script novamente:
```bash
curl -sS https://raw.githubusercontent.com/hsoservicos/myrustdesk/main/scripts/provision-vps.sh | sudo bash
```

### 12.3 "docker ps não mostra nada"

**Causa:** Os containers podem ter parado.

**Solução:** Tente iniciar manualmente:
```bash
docker start hbbs hbbr
```

### 12.4 "Perdi a chave pública"

**Solução:** Use este comando para recuperá-la:
```bash
cat /opt/rustdesk-server/id_ed25519.pub
```

### 12.5 "A VPS está muito lenta"

**Causa:** Pode estar sem memória.

**Solução:** Digite `free -h`. Se mostrar "Mem: usado" próximo do total,
considere contratar um plano maior.

---

## 13. Glossário

| Termo | O que significa |
|---|---|
| **VPS** | Computador alugado que fica ligado 24h na internet |
| **SSH** | Programa para acessar o computador da VPS pela internet |
| **IP** | Endereço do servidor na internet (ex: 177.54.32.10) |
| **Root** | Usuário "dono" do servidor (pode fazer tudo) |
| **Docker** | Programa que roda outros programas de forma isolada |
| **Container** | "Caixinha" onde o RustDesk roda dentro do Docker |
| **hbbs** | Programa do RustDesk que gerencia os IDs dos computadores |
| **hbbr** | Programa do RustDesk que faz a retransmissão de tela |
| **Chave pública** | Código que identifica seu servidor (único) |
| **Firewall** | Porteiro que bloqueia acesso de estranhos |
| **fail2ban** | Vigilante que expulsa quem tenta invadir |
| **UFW** | Programa simples para configurar o firewall |
| **Swap** | "Memória falsa" no disco (quando a RAM é pouca) |
| **Porta** | "Janela" numerada por onde os programas se comunicam |

---

## 14. Anexo: Informações do Servidor

Preencha a tabela abaixo e guarde em local seguro:

| Informação | Valor |
|---|---|
| **Provedor contratado** | |
| **Plano da VPS** | |
| **Valor mensal** | |
| **IP do servidor** | |
| **Sistema Operacional** | Ubuntu 24.04 LTS |
| **Chave Pública** | |
| **Data da contratação** | |
| **Data de vencimento** | |
| **Link do painel** | |
| **Email da conta** | |
| **Telefone do suporte** | |

---

> **Próximo passo:** Agora que o servidor está rodando, vá para o guia
> **[Implantação do Cloudflare Tunnel](14-implantacao-cloudflare.md)** se
> você precisar acessar de fora da rede local.
>
> Ou, se for usar apenas na rede local (escritório/casa), configure os
> clientes seguindo o **[Manual Operacional do Cliente](11-manual-operacional-cliente.md)**.
