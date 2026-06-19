# Manual de Implantação — RustDesk Server OSS

## Para quem é este manual?

Este manual foi escrito para **qualquer pessoa**, mesmo sem experiência em informática ou Linux.
Cada passo é explicado em detalhes: **o que fazer**, **como fazer**, **o que esperar** e **o que fazer se algo der errado**.

---

## Índice

1. [O que é este projeto?](#1-o-que-é-este-projeto)
2. [O que você precisa](#2-o-que-você-precisa)
3. [Visão geral do passo a passo](#3-visão-geral-do-passo-a-passo)
4. [Como acessar o servidor pela primeira vez](#4-como-acessar-o-servidor-pela-primeira-vez)
5. [Atualizar o sistema](#5-atualizar-o-sistema)
6. [Executar o script automático de instalação](#6-executar-o-script-automático-de-instalação)
7. [O que o script faz (explicação)](#7-o-que-o-script-faz-explicação)
8. [Verificar se tudo está funcionando](#8-verificar-se-tudo-está-funcionando)
9. [Como obter a chave do servidor](#9-como-obter-a-chave-do-servidor)
10. [Configurar os computadores que usarão o RustDesk](#10-configurar-os-computadores-que-usarão-o-rustdesk)
11. [Instalar o RustDesk nos computadores dos usuários](#11-instalar-o-rustdesk-nos-computadores-dos-usuários)
12. [Como usar o RustDesk para acessar remotamente](#12-como-usar-o-rustdesk-para-acessar-remotamente)
13. [Manutenção básica](#13-manutenção-básica)
14. [Problemas comuns e soluções](#14-problemas-comuns-e-soluções)
15. [Glossário](#15-glossário)

---

## 1. O que é este projeto?

O **RustDesk** é um programa de **acesso remoto** — igual ao TeamViewer ou AnyDesk,
mas **gratuito** e que roda no **seu próprio servidor**, sem depender de empresas externas.

Com ele instalado, você poderá:

- Acessar o computador do trabalho de casa (ou vice-versa)
- Ajudar colegas com problemas no computador sem precisar ir até a mesa deles
- Gerenciar vários computadores de um lugar só

### Como funciona?

```
 SEU COMPUTADOR ───────► SERVIDOR RUSTDESK ────────► COMPUTADOR ALVO
 (você controla)         (máquina na sala               (colega que
                          do servidor)                    precisa de ajuda)
```

O servidor funciona como uma **central de conexão**: ele apresenta os computadores
uns aos outros e, se necessário, ajuda a transmitir os dados.

---

## 2. O que você precisa

### ☑️ Itens obrigatórios

| Item | Descrição |
|---|---|
| **Servidor** | Um computador exclusivo rodando **Ubuntu 22.04 ou 24.04** (ou Debian 12) |
| **Acesso ao servidor** | Usuário e senha (ou chave SSH) fornecidos pelo administratorde rede |
| **Conexão de internet** | O servidor precisa estar conectado à internet para baixar os programas |
| **Acesso administrativo** | O servidor precisa permitir que você execute comandos como `sudo` |
| **Portas de rede liberadas** | As portas 21115, 21116 (TCP e UDP) e 21117 precisam estar abertas no firewall da rede |

> Se você não tem certeza sobre as portas de rede, fale com o administrador de rede
> e mostre a ele esta lista: **TCP 21115, 21116, 21117** e **UDP 21116**.

### ☑️ Itens recomendados

- Um **monitor e teclado** conectados ao servidor (para acesso direto em caso de emergência)
- Um **caderno** para anotar senhas e a chave do servidor
- Acesso ao **roteador/firewall** da empresa (ou alguém que tenha)

---

## 3. Visão geral do passo a passo

Aqui está o que você vai fazer, do começo ao fim:

```
┌──────────────────────────────────────────────────┐
│ 1. Acessar o servidor (via SSH ou tela local)    │
├──────────────────────────────────────────────────┤
│ 2. Atualizar o sistema                           │
├──────────────────────────────────────────────────┤
│ 3. Executar o script automático                  │
│    (ele instala Docker, configura firewall,      │
│     baixa e inicia o RustDesk)                   │
├──────────────────────────────────────────────────┤
│ 4. Verificar se está funcionando                 │
├──────────────────────────────────────────────────┤
│ 5. Anotar a chave do servidor                    │
├──────────────────────────────────────────────────┤
│ 6. Configurar os computadores dos usuários       │
└──────────────────────────────────────────────────┘
```

Cada etapa é explicada detalhadamente nas seções abaixo.

---

## 4. Como acessar o servidor pela primeira vez

O servidor provavelmente estará em uma sala de servidores ou em um rack.
Existem duas formas de acessá-lo:

### Opção A: Tela e teclado diretamente no servidor (recomendado para iniciantes)

1. Conecte um **monitor** na saída de vídeo do servidor
2. Conecte um **teclado** (e mouse, se quiser) nas entradas USB
3. Ligue o servidor (aperte o botão Power)
4. Aguarde aparecer a tela de login
5. Digite o **nome de usuário** e a **senha** que você recebeu
6. Pronto — você está na área de trabalho do servidor

Agora você precisa abrir o **terminal** (a "tela preta" onde se digita comandos):

- Clique em **Atividades** (no canto superior esquerdo)
- Digite **terminal** na busca
- Clique no ícone do Terminal

### Opção B: Acesso remoto via SSH (se você já tem outro computador)

> Se você não sabe o que é SSH, use a **Opção A** acima.

1. No seu computador, abra o programa **Terminal** (no Windows use **PowerShell**)
2. Digite o comando abaixo (substitua `usuario` e `192.168.1.100` pelos dados que você recebeu):

```bash
ssh usuario@192.168.1.100
```

3. Na primeira vez, aparecerá uma mensagem sobre "fingerprint". Digite `yes` e pressione Enter
4. Digite a senha quando solicitado
5. Pronto — você está conectado ao servidor

---

## 5. Atualizar o sistema

Antes de instalar qualquer coisa, vamos atualizar o sistema. Isso é importante para
garantir que todos os programas do servidor estejam na versão mais recente e segura.

No terminal (aberto no passo anterior), digite os comandos abaixo **um de cada vez**,
pressionando **Enter** após cada linha. Aguarde cada um terminar antes de digitar o próximo.

```bash
sudo apt update
```

> **O que este comando faz:** Ele baixa a lista de atualizações disponíveis.
> **O que esperar:** Várias linhas de texto vão passar na tela. No final, pode aparecer
> "All packages are up to date" ou uma lista de pacotes que podem ser atualizados.
> **Se pedir senha:** Digite a senha do seu usuário (a mesma que você usou para logar).

```bash
sudo apt upgrade -y
```

> **O que este comando faz:** Ele instala as atualizações disponíveis.
> **O que esperar:** Uma lista de pacotes sendo baixados e instalados. Pode demorar
> alguns minutos.
> **O -y no final:** Significa que o computador vai responder "sim" automaticamente
> para qualquer pergunta.

```bash
sudo apt autoremove -y
```

> **O que este comando faz:** Remove programas antigos que não são mais necessários.
> **O que esperar:** Algumas linhas de texto, normalmente termina rápido.

---

## 6. Executar o script automático de instalação

Agora vamos executar o script que faz tudo automaticamente.

### Passo 6.1: Baixar o script

No terminal (ainda dentro do servidor), digite:

```bash
wget https://raw.githubusercontent.com/rustdesk/rustdesk-server/main/scripts/setup-server.sh
```

> **O que este comando faz:** Baixa o script de instalação da internet.
> **O que esperar:** Uma barra de progresso aparecerá. Quando terminar, o prompt
> (o lugar onde você digita) volta a aparecer.

### Se o comando acima não funcionar (não estiver em um repositório público), use este:

```bash
wget https://raw.githubusercontent.com/seu-usuario/rustdesk/main/scripts/setup-server.sh
```

> **IMPORTANTE:** Substitua o link pelo caminho correto do script no seu projeto.

### Passo 6.2: Tornar o script executável

```bash
chmod +x setup-server.sh
```

> **O que este comando faz:** Dá permissão para o script ser executado.
> **O que esperar:** Nada — apenas o prompt volta a aparecer.

### Passo 6.3: Executar o script

```bash
sudo ./setup-server.sh
```

> **O que este comando faz:** Inicia o script de instalação.
> **O que esperar:** O script vai mostrar mensagens explicando cada etapa.
> Ele vai:
> 1. Verificar se o sistema é Ubuntu/Debian
> 2. Instalar o Docker (se não estiver instalado)
> 3. Criar a pasta de dados
> 4. Baixar a imagem do RustDesk Server
> 5. Iniciar os containers hbbs e hbbr
> 6. Configurar o firewall
> 7. Exibir a chave pública do servidor
> 8. Salvar todas as informações em um arquivo de resumo

### Passo 6.4: O que fazer após o script terminar

Quando o script terminar, ele vai mostrar uma tela como esta:

```
=====================================
 RustDesk Server — Instalação Concluída
=====================================

Endereço do servidor: 192.168.1.100
Porta do servidor ID: 21116

Chave Pública:
MetR3h4jKqRfG7xPm8sL5vB2nW9cQ6yD1oX0zE3uA8=

Arquivo de resumo salvo em: ./rustdesk-server-info.txt
=====================================
```

**IMPORTANTE:** Anote estas informações em um papel ou caderno:
- O **endereço do servidor** (no exemplo: `192.168.1.100`)
- A **chave pública** (no exemplo: `MetR3h4jKqRfG7xPm8sL5vB2nW9cQ6yD1oX0zE3uA8=`)

Você vai precisar destas informações para configurar os computadores dos usuários.

---

## 7. O que o script faz (explicação)

O script `setup-server.sh` executa automaticamente todos os passos abaixo.
Você não precisa fazer nada, mas é bom entender o que está acontecendo:

### Etapa 1: Verificação do sistema
O script verifica se você está usando Ubuntu ou Debian. Se for outro sistema,
ele avisa e pára.

### Etapa 2: Instalação do Docker
Docker é o programa que vai "empacotar" o RustDesk para rodar de forma isolada.
O script instala o Docker usando o script oficial.

### Etapa 3: Criação da estrutura de pastas
Cria a pasta `rustdesk-data` que vai guardar:
- As **chaves de segurança** (pública e privada)
- Os logs do servidor
- As configurações

### Etapa 4: Inicialização dos servidores
O script baixa e inicia dois programas (chamados de "containers"):

- **hbbs** — O "servidor de ID": é quem apresenta os computadores entre si
- **hbbr** — O "servidor de relay": é quem ajuda na transmissão quando a conexão direta não funciona

### Etapa 5: Configuração do firewall
O script libera automaticamente as portas necessárias no firewall do Ubuntu (UFW).

### Etapa 6: Exibição das informações
Mostra na tela e salva em um arquivo:
- O IP do servidor
- A chave pública
- As portas que estão sendo usadas
- Status dos serviços

---

## 8. Verificar se tudo está funcionando

Após executar o script, vamos verificar se está tudo certo.

### Verificar os containers Docker

Digite no terminal:

```bash
sudo docker ps
```

> **O que esperar:** Você deve ver duas linhas parecidas com estas:

```
CONTAINER ID   IMAGE                           COMMAND   CREATED          STATUS          PORTS     NAMES
abc123def456   rustdesk/rustdesk-server:latest  "hbbs"   2 minutes ago    Up 2 minutes              hbbs
ghi789jkl012   rustdesk/rustdesk-server:latest  "hbbr"   2 minutes ago    Up 2 minutes              hbbr
```

> **Se você não vir as duas linhas:** Algo deu errado. Pule para a seção
> [Problemas comuns e soluções](#14-problemas-comuns-e-soluções).

### Verificar as portas

Digite:

```bash
sudo ss -tlnp | grep -E '2111'
```

> **O que esperar:** Você deve ver linhas mostrando as portas 21115, 21116, 21117
> como "LISTEN" (ouvindo). Algo como:
> ```
> LISTEN 0 1024 *:21115 *:*
> LISTEN 0 1024 *:21116 *:*
> LISTEN 0 1024 *:21117 *:*
> ```

### Verificar os logs (mensagens do sistema)

```bash
sudo docker compose logs --tail=20
```

> **O que esperar:** Mensagens informativas. Não deve aparecer "ERROR".

---

## 9. Como obter a chave do servidor

A chave do servidor é como uma **senha mestra** — ela garante que apenas
os computadores autorizados consigam se conectar ao seu servidor.

Se você perdeu a chave que o script mostrou no final, pode obtê-la novamente com:

```bash
sudo cat ./rustdesk-data/id_ed25519.pub
```

> **O que esperar:** Uma linha com letras e números, algo como:
> ```
> MetR3h4jKqRfG7xPm8sL5vB2nW9cQ6yD1oX0zE3uA8=
> ```

**Anote esta chave em um lugar seguro.** Você vai precisar dela para cada
computador que quiser conectar ao servidor.

> ⚠️ **NÃO compartilhe a chave privada** (`id_ed25519` — sem o `.pub` no final).
> Apenas a chave pública (com `.pub`) deve ser distribuída.

---

## 10. Configurar os computadores que usarão o RustDesk

Agora que o servidor está funcionando, você precisa configurar cada computador
que usará o RustDesk. Existem duas formas:

### Método 1: Configuração manual (mais simples, bom para poucos computadores)

Para cada computador que usará o RustDesk, faça:

1. **Abra o RustDesk** no computador
2. Clique no **ícone de menu** (três tracinhos ou três pontinhos) ao lado do ID
3. Clique em **Configurações** (ou **Settings**)
4. Clique em **Rede** (ou **Network**)
5. Clique em **Desbloquear** (se pedir senha, digite a senha de administrador do Windows)
6. Preencha os campos:

   | Campo | O que colocar |
   |---|---|
   | **Servidor ID** | O endereço IP do servidor + `:21116` (ex: `192.168.1.100:21116`) |
   | **Chave** | A chave pública que você anotou (ex: `MetR3h4jKqRfG7xPm8sL5vB2nW9cQ6yD1oX0zE3uA8=`) |
   | **Servidor Relay** | Deixe em **branco** (o RustDesk descobre sozinho) |

7. Clique em **OK** ou **Aplicar**

> **Pronto!** O computador agora está conectado ao seu servidor.

### Método 2: Importar configuração (mais rápido para muitos computadores)

Se você já configurou um computador, pode exportar a configuração e importar nos outros:

**No computador já configurado:**
1. Abra o RustDesk
2. Vá em **Configurações → Rede**
3. Clique em **Exportar Config do Servidor**
4. A configuração será copiada para a área de transferência
5. Cole em um bloco de notas e salve como arquivo

**Nos novos computadores:**
1. Abra o RustDesk
2. Vá em **Configurações → Rede**
3. Clique em **Importar Config do Servidor**
4. Cole o texto que você salvou
5. Clique em **Aplicar**

---

## 11. Instalar o RustDesk nos computadores dos usuários

### Windows
1. Acesse [https://rustdesk.com](https://rustdesk.com)
2. Clique em **Download** (botão verde)
3. Escolha a versão para **Windows**
4. Execute o arquivo baixado
5. Siga a instalação padrão (clicar em "Next", "Next", "Install")
6. Após instalado, configure conforme a [seção 10](#10-configurar-os-computadores-que-usarão-o-rustdesk)

### macOS
1. Acesse [https://rustdesk.com](https://rustdesk.com)
2. Clique em **Download** e escolha a versão para **macOS**
3. Abra o arquivo `.dmg` baixado
4. Arraste o ícone do RustDesk para a pasta **Applications**
5. Abra o RustDesk da pasta Applications
6. Pode ser necessário ir em **Preferências do Sistema → Segurança e Privacidade**
   e permitir a execução
7. Configure conforme a [seção 10](#10-configurar-os-computadores-que-usarão-o-rustdesk)

### Linux
```bash
# Ubuntu/Debian
wget https://github.com/rustdesk/rustdesk/releases/download/1.2.6/rustdesk-1.2.6-x86_64.deb
sudo apt-get install -fy ./rustdesk-1.2.6-x86_64.deb
```

### Android
1. Abra a **Google Play Store**
2. Pesquise por **RustDesk**
3. Instale o aplicativo
4. Abra e configure conforme a [seção 10](#10-configurar-os-computadores-que-usarão-o-rustdesk)

---

## 12. Como usar o RustDesk para acessar remotamente

### Acessar outro computador

1. No computador que vai **controlar**, abra o RustDesk
2. No campo **ID do parceiro** (no lado esquerdo), digite o **ID** do computador alvo
   (o ID fica na tela principal do RustDesk de cada computador)
3. Clique no botão **Conectar** (ou **Connect**)
4. Escolha o modo:
   - **Controle Remoto** (você vê a tela e pode usar o mouse/teclado)
   - **Transferência de Arquivos** (para copiar arquivos entre os computadores)
   - **VPN** (para usar como se estivesse na mesma rede)
5. Aguarde a conexão

### Aceitar uma conexão de ajuda

1. No computador que será **acessado**, abra o RustDesk
2. O **ID** deste computador aparece na tela principal
3. Informe este ID para quem vai acessar
4. Quando a pessoa tentar conectar, aparece uma janela perguntando se você permite
5. Clique em **Aceitar** (ou **Accept**)
6. Opcional: marque "Permitir controle remoto sem pedir permissão" (útil para manutenção)

---

## 13. Manutenção básica

### Atualizar o servidor (recomendado: uma vez por mês)

```bash
# Acesse o servidor (via SSH ou tela local)
# Abra o terminal
# Digite os comandos abaixo:

cd ~/rustdesk
sudo docker compose pull
sudo docker compose up -d
```

> **Explicação:** `pull` baixa a versão mais recente, `up -d` recria os containers
> com a nova versão.

### Verificar se o servidor está rodando

```bash
sudo docker ps
```

> Devem aparecer dois containers: `hbbs` e `hbbr`. Se um deles não aparecer, execute:
> ```bash
> cd ~/rustdesk && sudo docker compose up -d
> ```

### Backup da configuração (recomendado: uma vez por mês)

```bash
cd ~/rustdesk
tar -czf backup-$(date +%Y%m%d).tar.gz rustdesk-data/
```

> **O que faz:** Cria um arquivo compactado com todas as configurações e chaves.
> Guarde este arquivo em um lugar seguro (um pen drive ou outro computador).

### Reiniciar o servidor

Se o servidor precisar ser reiniciado (por queda de energia ou manutenção):

```bash
sudo reboot
```

Após reiniciar, os containers do RustDesk iniciam automaticamente.
Para verificar, execute `sudo docker ps` após o servidor ligar novamente.

---

## 14. Problemas comuns e soluções

### Problema: "docker: command not found" ao executar o script

**Causa:** O Docker não foi instalado corretamente.

**Solução:** Execute manualmente:
```bash
sudo apt install -y docker.io
sudo systemctl enable --now docker
```

### Problema: "Failed to connect to port 21116"

**Causa:** Firewall bloqueando a porta.

**Solução:** Libere as portas manualmente:
```bash
sudo ufw allow 21115:21117/tcp
sudo ufw allow 21116/udp
sudo ufw reload
```

### Problema: Cliente não consegue conectar — "Key not match"

**Causa:** A chave pública no cliente está errada.

**Solução:** Obtenha a chave correta do servidor:
```bash
sudo cat ./rustdesk-data/id_ed25519.pub
```
E digite exatamente igual (sem espaços extras) no cliente.

### Problema: Conexão muito lenta

**Causa:** A conexão direta (P2P) não está funcionando e está usando o relay.

**Solução:** Verifique se as portas UDP 21116 estão abertas no firewall.
Se a lentidão persistir, o problema pode ser a velocidade da internet do servidor.

### Problema: "Permission denied" ao executar comandos

**Causa:** Você não está usando `sudo` antes do comando.

**Solução:** Digite `sudo` antes do comando. Exemplo:
```
ERRO: docker ps
CORRETO: sudo docker ps
```

### Problema: O terminal não reconhece o comando

**Causa:** Erro de digitação.

**Solução:** Verifique se você digitou exatamente igual ao manual. Letras maiúsculas
e minúsculas fazem diferença. Espaços também.

### Problema: Esqueci a senha do servidor

**Solução:** Se você tem acesso físico ao servidor (teclado e tela):
1. Reinicie o servidor
2. Durante a inicialização, segure a tecla **Shift** (ou aperte **Esc**)
3. Escolha **Advanced options for Ubuntu**
4. Escolha o modo **recovery**
5. Selecione **root** (ou "Drop to root shell prompt")
6. Digite: `passwd seu_usuario`
7. Digite a nova senha duas vezes
8. Digite: `reboot`

### Problema: Perdi o arquivo de resumo com as informações do servidor

**Solução:** Execute novamente o script ou obtenha as informações manualmente:
```bash
# IP do servidor
ip addr show | grep "inet "

# Chave pública
sudo cat ./rustdesk-data/id_ed25519.pub

# Status dos containers
sudo docker ps
```

---

## 15. Glossário

| Termo | Significado |
|---|---|
| **Servidor** | O computador que fica ligado 24h e roda o RustDesk |
| **Cliente** | O programa RustDesk instalado nos computadores dos usuários |
| **Container** | Um "pacote" que contém o programa e tudo que ele precisa para rodar |
| **Docker** | O programa que gerencia os containers |
| **Terminal** | A "tela preta" onde se digita comandos |
| **Comando** | Uma instrução que você digita no terminal |
| **Firewall** | Programa que controla o tráfego de rede |
| **Porta** | Um "canal" de comunicação no servidor (como uma porta de uma sala) |
| **SSH** | Forma de acessar o servidor remotamente pelo terminal |
| **IP** | O "endereço" do servidor na rede (ex: 192.168.1.100) |
| **Chave pública** | Código de segurança que os clientes usam para se conectar |
| **hbbs** | Componente do RustDesk que gerencia os IDs dos computadores |
| **hbbr** | Componente do RustDesk que retransmite dados quando necessário |
| **Hole punching** | Técnica para conectar dois computadores diretamente |
| **Relay** | Modo alternativo quando a conexão direta não funciona |
| **sudo** | Comando que dá permissão de administrador para executar algo |
| **Log** | Arquivo de registro que mostra o que aconteceu no sistema |

---

## Anexo: Informações do Servidor

Preencha esta tabela e guarde em local seguro:

| Informação | Valor |
|---|---|
| IP do servidor | ________________________ |
| Chave pública | ________________________ |
| Usuário do servidor | ________________________ |
| Senha do servidor | ________________________ |
| Data da instalação | ____/____/________ |
| Versão do Ubuntu/Debian | ________________________ |

---

## Anexo: Comandos Rápidos

Para usar, copie e cole no terminal (um de cada vez):

```bash
# Ver containers rodando
sudo docker ps

# Ver chave pública
sudo cat ./rustdesk-data/id_ed25519.pub

# Ver logs do servidor
sudo docker compose logs --tail=20

# Ver portas abertas
sudo ss -tlnp | grep 2111

# Atualizar RustDesk
cd ~/rustdesk && sudo docker compose pull && sudo docker compose up -d

# Fazer backup
cd ~/rustdesk && tar -czf backup-$(date +%Y%m%d).tar.gz rustdesk-data/
```
