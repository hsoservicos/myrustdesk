# Manual Operacional do Cliente — RustDesk

**Para:** Operadores e colaboradores sem conhecimento em informática
**Versão do cliente:** 1.4.x (atualizado em Junho/2026)
**Idioma:** Português brasileiro

---

## Sumário

1. [O que é o RustDesk?](#1-o-que-é-o-rustdesk)
2. [Instalação no Windows](#2-instalação-no-windows)
3. [Instalação no macOS (Apple)](#3-instalação-no-macos-apple)
4. [Instalação no Linux](#4-instalação-no-linux)
5. [Instalação no Android (celular/tablet)](#5-instalação-no-android-celulartablet)
6. [Instalação no iPhone/iPad (iOS)](#6-instalação-no-iphoneipad-ios)
7. [Acesso via Navegador (Web)](#7-acesso-via-navegador-web)
8. [Configurando para usar o servidor da empresa](#8-configurando-para-usar-o-servidor-da-empresa)
9. [Como usar o RustDesk](#9-como-usar-o-rustdesk)
10. [Acesso Remoto sem Supervisão](#10-acesso-remoto-sem-supervisão)
11. [Solução de Problemas](#11-solução-de-problemas)
12. [Glossário](#12-glossário)

---

## 1. O que é o RustDesk?

O **RustDesk** é um programa de **acesso remoto**, igual ao TeamViewer ou AnyDesk.
Com ele você pode:

- **Ajudar** um colega vendo a tela do computador dele
- **Acessar** seu computador do trabalho de casa
- **Transferir** arquivos entre computadores
- Funciona em **Windows, Mac, Linux, celular Android e iPhone**

### Por que usar o RustDesk da empresa?

A empresa tem um **servidor próprio** de RustDesk. Isso significa que:

- Sua conexão **não passa** por servidores de terceiros
- **Não precisa** criar conta nenhuma
- **Não expira** nem limita o tempo de uso
- É **mais rápido** que os servidores públicos

---

## 2. Instalação no Windows

### Requisitos

- Windows 10 ou 11 (64 bits)
- Acesso de **Administrador** do computador

### Passo a Passo

#### Método 1 — Instalação manual (usuário comum)

1. **Baixe o instalador**
   - Acesse: https://github.com/rustdesk/rustdesk/releases/latest
   - Clique no arquivo `RustDesk-1.4.0-x86_64.exe` (ou o número mais recente)

2. **Execute o instalador**
   - Dê um duplo clique no arquivo baixado
   - Se aparecer "Este aplicativo não é seguro", clique em **Executar assim mesmo**
   - Clique em **Sim** quando o Windows pedir permissão

3. **Siga a instalação**
   - Clique em **Next** (Avançar)
   - Clique em **Next** novamente
   - Clique em **Install** (Instalar)
   - Clique em **Finish** (Concluir)

4. **Pronto!** O RustDesk vai abrir automaticamente. Você verá uma tela com:
   - Seu **ID** (número do computador)
   - Uma **senha** temporária

#### Método 2 — Instalação automática (para equipe de TI)

Se você recebeu um arquivo `.bat` ou `.ps1` da TI, siga:

1. Salve o arquivo na Área de Trabalho
2. Clique com o botão **direito** no arquivo
3. Escolha **Executar como Administrador**
4. A instalação acontece sozinha em segundos

### Após a Instalação

O RustDesk aparece como um ícone na **bandeja do sistema** (cantinho inferior direito da tela, perto do relógio). O ícone é uma cabeça de tigre laranja 🐯.

---

## 3. Instalação no macOS (Apple)

### Requisitos

- macOS 10.15 (Catalina) ou superior
- Mac com chip **Intel** ou **Apple Silicon** (M1/M2/M3/M4)

### Passo a Passo

1. **Baixe o instalador**
   - Acesse: https://github.com/rustdesk/rustdesk/releases/latest
   - **Mac com chip Intel:** baixe o arquivo `RustDesk-1.4.0-x86_64.dmg`
   - **Mac com chip M1/M2/M3/M4:** baixe o arquivo `RustDesk-1.4.0-aarch64.dmg`

2. **Instale**
   - Dê um duplo clique no arquivo `.dmg` baixado
   - Arraste o ícone do **RustDesk** para a pasta **Applications** (aplicativos)

3. **Permissões necessárias**
   Na primeira vez que abrir o RustDesk, o Mac vai pedir algumas permissões:

   **a) Acessibilidade**
   - Vá em **Preferências do Sistema** → **Privacidade e Segurança** → **Acessibilidade**
   - Clique no cadeado para desbloquear
   - Marque a caixa do **RustDesk**

   **b) Gravação de Tela**
   - Vá em **Preferências do Sistema** → **Privacidade e Segurança** → **Gravação de Tela**
   - Clique no cadeado para desbloquear
   - Marque a caixa do **RustDesk**

   **c) Se aparecer "RustDesk não pode ser aberto"**
   - Vá em **Preferências do Sistema** → **Privacidade e Segurança**
   - Lá embaixo vai aparecer "RustDesk foi bloqueado"
   - Clique em **Abrir mesmo assim**

4. **Pronto!** Você verá seu **ID** e **senha** na tela.

---

## 4. Instalação no Linux

### Requisitos

- Ubuntu 18.04+, Debian 11+, Fedora 35+, ou similar
- Acesso **root** (sudo)

### Ubuntu / Debian / Linux Mint

Abra o **Terminal** e digite:

```bash
# Baixar o programa
wget https://github.com/rustdesk/rustdesk/releases/download/1.4.0/rustdesk-1.4.0-x86_64.deb

# Instalar
sudo apt install -fy ./rustdesk-1.4.0-x86_64.deb

# Iniciar
rustdesk
```

### Fedora / CentOS / Red Hat

```bash
# Baixar o programa
wget https://github.com/rustdesk/rustdesk/releases/download/1.4.0/rustdesk-1.4.0-0.x86_64.rpm

# Instalar
sudo yum localinstall ./rustdesk-1.4.0-0.x86_64.rpm -y

# Iniciar
rustdesk
```

### Arch Linux / Manjaro

```bash
# Pelo repositório oficial da comunidade
sudo pacman -S rustdesk
```

### AppImage (qualquer distribuição)

- Baixe o arquivo `.AppImage` do GitHub
- Dê permissão de execução:
  ```bash
  chmod +x RustDesk*.AppImage
  ```
- Execute com duplo clique ou pelo terminal

---

## 5. Instalação no Android (celular/tablet)

### Requisitos

- Android 8.0 ou superior

### Passo a Passo

1. **Baixe o aplicativo**
   - Opção 1: Pela **Google Play Store** — procure por "RustDesk Remote Desktop"
   - Opção 2: Baixe o arquivo `.apk` do GitHub:
     https://github.com/rustdesk/rustdesk/releases/latest
     (escolha o arquivo `RustDesk-1.4.0.apk`)

2. **Instale**
   - Se baixou da Play Store: instala automaticamente
   - Se baixou o `.apk`: pode ser necessário permitir "Instalar de fontes desconhecidas"

3. **Permissões necessárias**
   - **Acessibilidade**: necessário para controlar outro computador pelo celular
   - **Sobreposição de tela**: permite desenhar na tela durante o suporte remoto

### O que o Android pode fazer

| Funcionalidade | Funciona? |
|---|---|
| **Controlar** outro computador | ✅ Sim |
| **Receber** controle (servir) | ✅ Sim |
| Transferir arquivos | ✅ Sim |
| Acesso remoto (sem ninguém no PC) | ✅ Sim |

---

## 6. Instalação no iPhone/iPad (iOS)

### Requisitos

- iOS 14.0 ou superior
- Conta na Apple (App Store)

### Passo a Passo

1. Abra a **App Store**
2. Pesquise por **"RustDesk Remote Desktop"**
3. Toque em **Obter** (ou o ícone de nuvem)
4. Confirme com Face ID / Touch ID / senha

### Importante sobre o iOS

⚠️ O iPhone/iPad **só pode controlar** outros computadores — não pode ser controlado. Ou seja, você pode acessar seu PC do trabalho pelo iPhone, mas ninguém pode acessar seu iPhone pelo RustDesk.

| Funcionalidade | Funciona? |
|---|---|
| **Controlar** outro computador | ✅ Sim |
| **Receber** controle (servir) | ❌ Não (limitação do iOS) |
| Transferir arquivos | ✅ Sim |

---

## 7. Acesso via Navegador (Web)

Sem instalar nada, é possível acessar o RustDesk pelo navegador.

### Requisitos

- Servidor **RustDesk Server Pro** (funcionalidade Pro)
- Acesso via navegador **Chrome**, **Edge** ou **Firefox**

### Como usar

1. Abra o navegador
2. Acesse: `https://[endereço-do-servidor]:21118`
3. Faça login com seu usuário Pro
4. Selecione o computador remoto que deseja acessar

---

## 8. Configurando para usar o servidor da empresa

Para usar o servidor **da empresa** (em vez dos servidores públicos), é necessário
configurar o cliente. Você pode fazer de duas formas:

### Método Rápido (recomendado)

A TI vai fornecer uma **chave de configuração** (um texto longo). Você só precisa:

1. Abra o RustDesk
2. Clique no menu **⋮** (três pontinhos) ao lado do seu ID
3. Clique em **Rede** (Network)
4. Clique em **Desbloquear configurações** (pode pedir senha de administrador)
5. Clique em **Importar configuração do servidor**
6. Cole o texto que a TI forneceu
7. Clique em **Aplicar** (Apply)

O RustDesk vai reiniciar e você verá seu novo ID conectado ao servidor da empresa.

### Método Manual

Se você tiver as informações do servidor:

| Campo | O que colocar |
|---|---|
| **Servidor ID** | Endereço do servidor (ex: `192.168.1.100` ou `meuservidor.com`) |
| **Servidor Relay** | Pode deixar em branco (o sistema descobre sozinho) |
| **Servidor API** | Só para Pro — pergunte à TI |
| **Chave** | A chave pública do servidor (fornecido pela TI) |

### Pelo celular (Android/iOS)

1. Abra o RustDesk
2. Toque no ícone de **engrenagem** (⚙️) no canto superior
3. Toque em **Rede**
4. Preencha os campos iguais ao método manual acima

---

## 9. Como usar o RustDesk

### Conectar a outro computador

**Para ajudar alguém (você vê a tela da outra pessoa):**

1. Peça para a pessoa abrir o RustDesk
2. Peça o **ID** e a **senha** que aparecem na tela dela
3. No seu RustDesk, digite o **ID** no campo "Remote ID"
4. Clique em **Conectar** (Connect)
5. Digite a **senha** que a pessoa forneceu

**Para acessar seu próprio computador (de casa):**

1. No computador que vai ficar em casa, deixe o RustDesk aberto
2. Anote o **ID** e a **senha**
3. Do trabalho, abra o RustDesk e digite o **ID**
4. Digite a **senha**

### Transferir arquivos

1. Durante a conexão remota, clique no ícone de **pastinha** 📁
2. Escolha se quer enviar (seu computador → remoto) ou receber (remoto → seu)
3. Selecione os arquivos e confirme

### Encerrar uma conexão

- Clique no **X** na barra superior da janela de conexão, ou
- Pressione **Ctrl+Alt+Delete** e escolha "Desconectar"

---

## 10. Acesso Remoto sem Supervisão

Para acessar um computador **sem ninguém do outro lado**, você precisa configurar
uma **senha permanente**.

### No Windows / Linux

1. Abra o RustDesk
2. Clique no menu **⋮** (três pontinhos)
3. Clique em **Configurações** → **Segurança**
4. No campo "Senha permanente", digite uma senha forte (use letras + números)
5. Clique em **OK** ou **Aplicar**

### No macOS

1. Abra o RustDesk
2. Clique no menu **RustDesk** na barra superior do Mac
3. Clique em **Preferências** → **Segurança**
4. Marque "Usar senha permanente" e digite sua senha

### Recomendações de senha

- Mínimo **8 caracteres**
- Misture **letras maiúsculas, minúsculas e números**
- **Não** use senhas óbvias como "123456" ou "senha"
- Exemplo bom: `Suport3R3moto!`

### Serviço em Segundo Plano

⚠️ Para o acesso remoto funcionar **mesmo quando você não está logado** no Windows:

1. No RustDesk, vá em **Configurações**
2. Marque a opção **"Executar RustDesk na inicialização do Windows"**
3. Marque a opção **"Instalar serviço do RustDesk"** (precisa de Administrador)

Assim, mesmo se o computador reiniciar, o RustDesk vai iniciar automático.

---

## 11. Solução de Problemas

### "Conexão recusada" ou "Não foi possível conectar"

1. Verifique se o **outro computador** está ligado e com RustDesk aberto
2. Confira se o **ID** foi digitado corretamente
3. Verifique se a **senha** está correta (a senha muda a cada conexão, a menos que tenha senha permanente)
4. Teste com o servidor público (remova a configuração personalizada)

### "Falha ao conectar ao servidor de relay"

1. Verifique se o servidor da empresa está funcionando
2. Confira se as configurações de rede estão corretas (seção 8)
3. Tente desabilitar o antivírus temporariamente (Firewall pode bloquear)

### Tela preta na conexão

1. No computador que está sendo acessado, verifique se o RustDesk tem permissão de "Gravação de Tela"
2. No Windows: vá em Configurações → Privacidade → Gravação de Tela → permita o RustDesk
3. No macOS: veja a seção 3 sobre permissões

### RustDesk não abre

- **Windows:** execute como **Administrador** (clique direito → Executar como Administrador)
- **Mac:** verifique as permissões em Preferências do Sistema → Privacidade
- **Linux:** execute pelo terminal com `rustdesk` e veja a mensagem de erro

### Som não funciona na conexão remota

- No lado que está conectando, clique no ícone de **alto-falante** durante a conexão
- Verifique se o volume do computador remoto não está mudo

### "Senha inválida" ao configurar senha permanente

- A senha permanente deve ter no mínimo **6 caracteres**
- Evite caracteres especiais como `@#$%` — só letras e números

---

## 12. Glossário

| Termo | Significado |
|---|---|
| **ID** | Número único que identifica seu computador no RustDesk. É como um "telefone" — para chamar alguém, você precisa do número dela. |
| **Senha** | Código temporário que aparece no RustDesk. Muda cada vez que você abre o programa. Serve para autorizar a conexão. |
| **Senha permanente** | Senha fixa que você define. Permite acessar o computador mesmo sem ninguém do outro lado. |
| **Servidor ID** | O "telefone central" do RustDesk. É o servidor que gerencia as conexões. |
| **Servidor Relay** | Faz a "ponte" quando dois computadores não conseguem se conectar diretamente. |
| **Acesso remoto** | Controlar um computador à distância, como se estivesse na frente dele. |
| **Firewall** | Barreira de segurança do sistema que pode bloquear o RustDesk. |
| **P2P** | Conexão direta entre dois computadores, sem passar por servidor. Mais rápida. |
| **Cliente** | O programa RustDesk instalado no seu computador. |
| **Servidor** | O sistema central da empresa que gerencia as conexões. |
| **hbbs** | Componente do servidor que gerencia os IDs dos computadores. |
| **hbbr** | Componente do servidor que faz o relay (ponte) das conexões. |

---

## Anexos

### A1 — Atalhos de Teclado

| Atalho | Função |
|---|---|
| **Ctrl+Alt+Delete** | Enviar Ctrl+Alt+Delete para o computador remoto |
| **Ctrl+Alt+Enter** | Alternar tela cheia |
| **Ctrl+Alt+F** | Ajustar tela à janela |
| **Esc** | Desconectar / sair da tela cheia |

### A2 — Portas usadas pelo RustDesk

| Porta | Protocolo | Função |
|---|---|---|
| 21115 | TCP | Teste de tipo de NAT |
| 21116 | TCP | Registro de ID |
| 21116 | UDP | Heartbeat (batimento cardíaco do ID) |
| 21117 | TCP | Tráfego do relay |
| 21118 | TCP | Cliente Web (navegador) |
| 21119 | TCP | Relay do cliente Web |

### A3 — Onde baixar

| Sistema | Link |
|---|---|
| **Windows** | [GitHub Releases](https://github.com/rustdesk/rustdesk/releases/latest) — arquivo `.exe` |
| **macOS (Intel)** | [GitHub Releases](https://github.com/rustdesk/rustdesk/releases/latest) — arquivo `x86_64.dmg` |
| **macOS (Apple Silicon)** | [GitHub Releases](https://github.com/rustdesk/rustdesk/releases/latest) — arquivo `aarch64.dmg` |
| **Linux (Debian/Ubuntu)** | [GitHub Releases](https://github.com/rustdesk/rustdesk/releases/latest) — arquivo `.deb` |
| **Linux (Fedora/CentOS)** | [GitHub Releases](https://github.com/rustdesk/rustdesk/releases/latest) — arquivo `.rpm` |
| **Android** | Google Play Store ou GitHub APK |
| **iPhone/iPad** | Apple App Store |
| **Página oficial** | [https://rustdesk.com](https://rustdesk.com) |

---

