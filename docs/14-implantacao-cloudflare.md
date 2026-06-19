# Implantação do Cloudflare Tunnel — Acesso Externo para o RustDesk

> **Para:** Colaborador responsável pela instalação
> **Nível:** Iniciante absoluto (não precisa saber Linux)
> **Tempo estimado:** 30 a 60 minutos
> **Custo:** US$ 0 (gratuito) — até 50 usuários

---

## Sumário

1. [O que é este guia?](#1-o-que-é-este-guia)
2. [O que é Cloudflare?](#2-o-que-é-cloudflare)
3. [Por que precisamos do Cloudflare?](#3-por-que-precisamos-do-cloudflare)
4. [O que você precisa antes de começar](#4-o-que-você-precisa-antes-de-começar)
5. [Criando uma conta na Cloudflare](#5-criando-uma-conta-na-cloudflare)
6. [Configurando o domínio no Cloudflare](#6-configurando-o-domínio-no-cloudflare)
7. [Criando o túnel Zero Trust](#7-criando-o-túnel-zero-trust)
8. [Instalando o cloudflared no servidor](#8-instalando-o-cloudflared-no-servidor)
9. [Configurando a rede privada](#9-configurando-a-rede-privada)
10. [Instalando o WARP nos computadores](#10-instalando-o-warp-nos-computadores)
11. [Testando a conexão](#11-testando-a-conexão)
12. [Manutenção do Cloudflare](#12-manutenção-do-cloudflare)
13. [Problemas comuns e soluções](#13-problemas-comuns-e-soluções)
14. [Glossário](#14-glossário)
15. [Anexo: Informações do Túnel](#15-anexo-informações-do-túnel)

---

## 1. O que é este guia?

Este guia ensina **passo a passo** como configurar o **Cloudflare Tunnel**
para que você possa acessar o RustDesk de **qualquer lugar** (casa, rua,
celular 4G, outro país) com segurança e sem precisar abrir portas no seu
roteador.

> ⚠️ **Antes de começar:** Você precisa primeiro ter o **servidor RustDesk
> funcionando em uma VPS**. Se ainda não fez isso, siga o guia
> **[Implantação em VPS](13-implantacao-vps.md)** primeiro.

---

## 2. O que é Cloudflare?

### Explicação simples

A **Cloudflare** é uma empresa que ajuda sites e aplicativos a funcionarem
mais rápido e mais seguros. Pense nela como um **escudo** entre o seu
servidor e a internet.

Milhões de empresas usam Cloudflare, incluindo grandes nomes. O plano
**gratuito** já oferece muita coisa útil.

### O que vamos usar da Cloudflare

Vamos usar **dois** serviços gratuitos da Cloudflare:

| Serviço | Para que serve |
|---|---|
| **Zero Trust** | Cria um "túnel" secreto entre o servidor e a Cloudflare |
| **WARP** | Programa que os computadores instalam para entrar nesse túnel |

### Como vai funcionar na prática

```
Seu computador  ───►  Cloudflare WARP  ───►  Internet  ───►  Servidor RustDesk
   (em casa)            (programinha)         (túnel)         (na VPS)
```

O WARP cria uma **conexão criptografada** entre seu computador e o servidor,
sem que ninguém consiga ver o que está passando.

---

## 3. Por que precisamos do Cloudflare?

### O problema

O RustDesk precisa de **dois tipos** de conexão:

| Tipo | Para que serve |
|---|---|
| **TCP** | Transferir a imagem da tela, arquivos |
| **UDP** | Avisar o servidor que o computador está online (chamado "heartbeat") |

A maioria dos túneis gratuitos da internet só passa **TCP**, não passam **UDP**.

### A solução

O **Cloudflare Zero Trust + WARP** é a **única solução gratuita** que passa
**TCP e UDP**. Ele faz isso criando uma "rede privada virtual" entre todos
os computadores — como se todos estivessem na mesma sala, mesmo estando em
cidades diferentes.

### Vantagens de usar Cloudflare

- ✅ **Gratuito** para até 50 usuários
- ✅ **Funciona com UDP** (essencial para o RustDesk)
- ✅ **Não precisa abrir portas** no roteador ou VPS
- ✅ **Criptografia** em toda a conexão
- ✅ **Proteção contra ataques** (DDoS, hackers)
- ✅ **Você pode bloquear países inteiros** se quiser

---

## 4. O que você precisa antes de começar

### Obrigatório

| Item | Exemplo | Onde conseguir |
|---|---|---|
| **Servidor RustDesk funcionando** | VPS com hbbs + hbbr rodando | Guia [Implantação VPS](13-implantacao-vps.md) |
| **Conta na Cloudflare** | email e senha | Criar no site cloudflare.com |
| **Um domínio (site)** | meusite.com.br | Comprar no registro.br ou similar |
| **SSH na VPS** | Acesso remoto ao servidor | Seu provedor de VPS fornece |

### O que é um domínio?

**Domínio** é o endereço do seu site na internet. Exemplos:

- `google.com`
- `minhaempresa.com.br`
- `meuservidor.com`

**Você precisa ter um domínio** para usar o Cloudflare. Se não tiver, pode
comprar um bem barato (a partir de R$ 30 por ano no **registro.br**).

> 💡 **Sem domínio não dá para usar Cloudflare.** Se você não quer comprar
> um domínio, pode usar o RustDesk sem Cloudflare — veja o
> [Manual Operacional do Cliente](11-manual-operacional-cliente.md).

### Recomendado

| Item | Por que |
|---|---|
| Um **caderno e caneta** | Para anotar senhas, tokens, IPs |
| Um **celular com Cloudflare WARP** | Para testar a conexão remota |

---

## 5. Criando uma conta na Cloudflare

**Passo a passo:**

1. Abra o navegador (Chrome, Edge, Firefox)
2. Acesse: **https://dash.cloudflare.com/sign-up**
3. Preencha:
   - **Email:** seu email (ex: voce@email.com)
   - **Senha:** crie uma senha forte (anote!)
4. Clique em "**Create Account**"
5. Vai aparecer uma tela perguntando "Add a website or application"
   - **Ignore por enquanto** — clique no ícone do Cloudflare no canto superior
     esquerdo para voltar ao início

Pronto! Sua conta está criada.

---

## 6. Configurando o domínio no Cloudflare

Agora você precisa dizer para a Cloudflare que você é o dono do seu domínio.

### 6.1 Adicionar o domínio

1. No painel da Cloudflare (dash.cloudflare.com), clique em "**Add a domain**"
   (ou "**Adicionar um site**" se estiver em português)
2. Digite o nome do seu domínio:
   - Exemplo: `meusite.com.br`
3. Clique em "**Continue**"
4. Escolha o plano **Free** (grátis)
5. Clique em "**Continue**" novamente

### 6.2 Copiar os nameservers da Cloudflare

A Cloudflare vai mostrar **dois endereços** (nameservers), parecidos com:

```
dave.ns.cloudflare.com
sara.ns.cloudflare.com
```

**Copie esses dois endereços** — você vai precisar deles no próximo passo.

### 6.3 Apontar o domínio para a Cloudflare

Agora você precisa ir no site onde você **comprou o domínio** e trocar os
nameservers.

**Onde fazer:**

| Se comprou no | Como fazer |
|---|---|
| **registro.br** | Faça login → "Domínios" → clique no seu domínio → "DNS" → "Alterar Nameservers" → cole os dois endereços da Cloudflare → "Salvar" |
| **Hostinger** | Painel → "Domínios" → "Gerenciar" → "Nameservers" → "Usar nameservers personalizados" → cole os da Cloudflare |
| **GoDaddy** | Painel → "Meus Domínios" → "Gerenciar DNS" → "Nameservers" → "Personalizado" → cole os da Cloudflare |
| **KingHost** | Painel → "Domínios" → "Gerenciar DNS" → alterar nameservers |

### 6.4 Aguardar a propagação

Após trocar os nameservers, pode levar de **5 minutos a 48 horas** para
funcionar (normalmente leva menos de 1 hora). A Cloudflare vai te enviar
um email quando estiver pronto.

> 💡 Enquanto isso, você pode continuar a instalação — o próximo passo não
> depende do domínio estar ativo.

---

## 7. Criando o túnel Zero Trust

O **Zero Trust** é o serviço da Cloudflare que cria um "túnel" privado.

### 7.1 Ativar o Zero Trust

1. No painel da Cloudflare, clique em **Zero Trust** no menu lateral
2. Clique em "**Create account**" ou "**Free plan**"
3. Escolha um nome para sua **equipe**:
   - Exemplo: `minha-empresa` (o nome que você quiser)
4. Siga os passos iniciais (eles são bem guiados)

### 7.2 Criar o Túnel

1. No menu do Zero Trust, clique em **Access → Tunnels**
2. Clique em "**Create a tunnel**"
3. Escolha o nome do túnel:
   - Exemplo: `rustdesk-tunnel` (só para identificar)
4. Clique em "**Save tunnel**"

### 7.3 Copiar o Token do Túnel

Imediatamente após criar o túnel, a Cloudflare mostra uma tela com um
**token** (um textão enorme). Ele começa com `eyJ...` e é bem grande.

**Copie este token para um bloco de notas!** Você vai precisar dele.

> ⚠️ **Este token é a senha do seu túnel.** Se alguém tiver ele, pode
> acessar seu servidor. Guarde com segurança!

---

## 8. Instalando o cloudflared no servidor

O **cloudflared** é o programinha que roda no servidor e mantém o túnel
aberto com a Cloudflare.

### 8.1 Acessar o servidor (SSH)

Se você já fechou a conexão com o servidor, reconecte:

```bash
ssh root@IP-DA-VPS
```

### 8.2 Configurar o token como variável

Digite este comando, trocando `SEU-TOKEN-AQUI` pelo token que você copiou:

```bash
echo "TUNNEL_TOKEN=SEU-TOKEN-AQUI" > /opt/rustdesk-server/cloudflare.env
```

**Exemplo prático:**
```bash
echo "TUNNEL_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." > /opt/rustdesk-server/cloudflare.env
```

### 8.3 Iniciar o cloudflared

Agora vamos usar o Docker Compose para iniciar o cloudflared:

```bash
cd /opt/rustdesk-server
curl -sS https://raw.githubusercontent.com/hsoservicos/myrustdesk/main/compose-cloudflared.yml -o compose-cloudflared.yml
docker compose -f compose-cloudflared.yml up -d
```

### 8.4 Verificar se está funcionando

```bash
docker ps
```

Você deve ver **três** containers rodando: `hbbs`, `hbbr` e `cloudflared`.

Para ver os logs do cloudflared:

```bash
docker logs cloudflared --tail=10
```

Deverá mostrar algo como:

```
INF Connection registered
INF Registered tunnel connection
```

Se aparecer `INF`, está funcionando! Se aparecer `ERR`, tem algo errado.

### 8.5 O que fazer se der erro

| Mensagem de erro | Causa | Solução |
|---|---|---|
| `ERR Unauthorized` | Token inválido | Verifique se copiou o token inteiro |
| `ERR Tunnel not found` | Túnel não existe | Recrie o túnel no Zero Trust |
| `ERR Connection refused` | Porta já em uso | Verifique se o RustDesk já está rodando |

---

## 9. Configurando a rede privada

Agora vamos configurar a **rede privada** — é ela que vai permitir que os
computadores se enxerguem mesmo estando em lugares diferentes.

### 9.1 Criar uma rota privada

1. No painel Zero Trust, vá em **Access → Tunnels**
2. Clique no túnel que você criou (`rustdesk-tunnel`)
3. Vá na aba **Public Hostname** e depois em **Private Network**
4. Em "**Private network CIDR**" digite: `192.168.200.0/24`
5. Clique em "**Add network**"

> 💡 **192.168.200.0/24** é um endereço de rede que não vai conflitar com
> sua rede de casa ou do escritório.

### 9.2 Configurar o Split Tunnel (importante!)

O **Split Tunnel** faz com que o WARP só use o túnel para acessar o servidor
RustDesk, e continue usando a internet normal para tudo o resto (YouTube,
WhatsApp, etc.).

**Como configurar:**

1. No Zero Trust, vá em **Settings → Network**
2. Em **Split Tunnels**, clique em "**Manage**"
3. Selecione "**Exclude IP ranges in the split tunnel**" (os itens da lista
   usam internet normal)
4. Clique em "**Add a Split Tunnel**" e adicione **apenas** o IP da sua VPS
   - Exemplo: se sua VPS tem IP `177.54.32.10`, adicione `177.54.32.10/32`
5. Clique em "**Save**"

> ✅ **Pronto!** Agora o WARP só vai usar o túnel para acessar o servidor,
> sem atrapalhar o resto da internet.

### 9.3 Configurar o Gateway (acesso via IP)

1. No Zero Trust, vá em **Settings → WARP Client**
2. Ative a opção "**Allow device enrollment**"
3. Em **Device enrollment rules**, clique "**Add a rule**"
4. Configure:
   - **Rule name:** `Todos os usuários`
   - **Operator:** `is greater than`
   - **Value:** `0` (qualquer um pode conectar)
   - **Action:** Allow
5. Clique em "**Save**"

---

## 10. Instalando o WARP nos computadores

O **WARP** é o programinha que cada computador precisa instalar para se
conectar ao túnel.

### 10.1 No Windows

1. Acesse: **https://one.one.one.one/**
2. Clique no botão "**Download**" (download automático)
3. Abra o arquivo baixado
4. Clique em "**Install**" e depois "**Aceitar**"
5. O WARP vai abrir uma janela: clique em "**Menu**" (três tracinhos)
6. Vá em "**Preferences → Account**"
7. Em "**Enterprise**", digite o nome da sua equipe (ex: `minha-empresa`)
8. Clique em "**Authenticate**"
9. Vai abrir o navegador: faça login com seu email (da Cloudflare)
10. O WARP vai se conectar automaticamente

### 10.2 No macOS

1. Acesse: **https://one.one.one.one/**
2. Clique em "**Download**" e escolha a versão para Mac
3. Abra o arquivo baixado e arraste para a pasta "Applications"
4. Abra o WARP (pode pedir permissão no "Preferências do Sistema → Segurança")
5. Siga os mesmos passos do Windows (menu → Account → Enterprise)

### 10.3 No celular Android

1. Abra a **Google Play Store**
2. Pesquise: "**1.1.1.1 + WARP**"
3. Instale o aplicativo da Cloudflare
4. Abra o app, clique no menu (três tracinhos) → **Account**
5. Escolha **Enterprise** e digite o nome da equipe
6. Faça login com seu email

### 10.4 No iPhone/iPad

1. Abra a **App Store**
2. Pesquise: "**1.1.1.1 + WARP**"
3. Instale e siga os mesmos passos do Android

### 10.5 Verificando se o WARP está ativo

Em todos os dispositivos, o WARP mostra um **interruptor**:

- 🟢 **Verde / Ligado** = WARP ativo (protegido)
- 🔴 **Cinza / Desligado** = WARP desativado

> Para usar o RustDesk remotamente, o **WARP precisa estar ligado**.

---

## 11. Testando a conexão

### 11.1 Teste simples

1. Pegue um computador que esteja em uma **outra rede** (ex: seu celular no 4G)
2. Ative o **WARP** no dispositivo
3. Abra o **RustDesk**
4. Você deverá ver o **ID** do dispositivo aparecer na tela
5. Se aparecer, o túnel está funcionando!

### 11.2 Teste de conexão remota

1. Anote o **ID** de um computador da empresa que também tenha o WARP instalado
2. Em outro computador (ou celular), também com WARP ligado
3. Digite o ID no RustDesk e clique em "**Conectar**"
4. Se aparecer a tela do outro computador, **funcionou!**

### 11.3 Se não funcionar

| Sintoma | Causa provável | Solução |
|---|---|---|
| "ID not found" | WARP desligado no destino | Ligue o WARP no computador que você quer acessar |
| Conexão cai toda hora | Oscilação do túnel | Verifique se o cloudflared está rodando no servidor |
| Muito lento | Internet lenta em um dos lados | Teste com um computador na mesma rede |

---

## 12. Manutenção do Cloudflare

### 12.1 O que você NÃO precisa fazer

- **O cloudflared se atualiza sozinho** (a imagem Docker é atualizada)
- **O túnel é gerenciado pela Cloudflare** (não precisa mexer)

### 12.2 O que você pode precisar fazer

| Tarefa | Quando | Como |
|---|---|---|
| Verificar status do túnel | Se suspeitar de problema | Painel Zero Trust → Tunnels |
| Reiniciar cloudflared | Se o túnel caiu | `docker restart cloudflared` |
| Adicionar novo usuário | Quando um novo funcionário entrar | Criar conta Cloudflare para ele + ensinar WARP |

### 12.3 Para reiniciar o cloudflared

Se o túnel parar de funcionar:

```bash
ssh root@IP-DA-VPS
docker restart cloudflared
```

### 12.4 Para ver os logs

```bash
ssh root@IP-DA-VPS
docker logs cloudflared --tail=20
```

---

## 13. Problemas comuns e soluções

### 13.1 "O WARP não conecta"

**Causa:** Pode ser rede bloqueando WARP.

**Solução:**
- Tente desligar e ligar o WARP novamente
- Verifique se você digitou o nome da equipe corretamente
- Tente conectar em outra rede (ex: 4G do celular)

### 13.2 "O túnel caiu"

**Causa:** O cloudflared travou.

**Solução:**
```bash
ssh root@IP-DA-VPS
docker restart cloudflared
```

### 13.3 "Consigo acessar de casa, mas não do celular 4G"

**Causa:** WARP desligado no celular.

**Solução:** Ligue o WARP no celular antes de tentar conectar.

### 13.4 "O domínio não funciona mais"

**Causa:** Pode ter expirado ou os nameservers foram alterados.

**Solução:**
- Verifique se o domínio está pago (site onde comprou)
- Verifique se os nameservers ainda apontam para a Cloudflare

### 13.5 "Perdi o token do túnel"

**Solução:**
1. Acesse o Zero Trust → Access → Tunnels
2. Clique no nome do túnel
3. Vá em **Configuration → Edit tunnel**
4. O token estará visível. Copie e salve novamente.

---

## 14. Glossário

| Termo | O que significa |
|---|---|
| **Cloudflare** | Empresa que fornece segurança e túneis gratuitos |
| **Zero Trust** | Serviço da Cloudflare que cria túneis privados |
| **Túnel** | Conexão secreta e criptografada entre servidor e usuário |
| **WARP** | Programinha que cada computador instala para entrar no túnel |
| **Domínio** | Endereço do seu site na internet (ex: meusite.com.br) |
| **Nameserver** | Endereço que aponta seu domínio para a Cloudflare |
| **Token** | Senha única do seu túnel (não compartilhe!) |
| **Split Tunnel** | Configuração que faz o WARP funcionar só para o servidor |
| **Propagação** | Tempo que leva para a internet saber que seu domínio mudou |
| **DDoS** | Ataque que tenta derrubar um site com muitas visitas falsas |
| **Criptografia** | Código secreto que embaralha os dados para ninguém ler |
| **Overlay** | Rede criada por cima da internet normal |
| **CIDR** | Forma de escrever endereços de rede (ex: 192.168.200.0/24) |

---

## 15. Anexo: Informações do Túnel

Preencha a tabela abaixo e guarde em local seguro:

| Informação | Valor |
|---|---|
| **Nome da equipe Zero Trust** | |
| **Token do túnel (começa com eyJ...)** | |
| **IP da VPS** | |
| **Nome do domínio** | |
| **Nameservers Cloudflare** | 1. |
| | 2. |
| **Email da conta Cloudflare** | |
| **Data de criação do túnel** | |
| **Domínio comprado em** | |

---

> **Próximo passo:** Agora que o túnel está configurado, você pode configurar
> os **clientes** (Windows, Mac, Linux, celulares) seguindo o
> **[Manual Operacional do Cliente](11-manual-operacional-cliente.md)**.
>
> **Importante:** Nos clientes, ao invés de colocar o IP do servidor, você
> vai colocar o IP **privado** que definiu (ex: `192.168.200.1`) e a **chave
> pública** do servidor. O WARP cuida de fazer a conexão.
