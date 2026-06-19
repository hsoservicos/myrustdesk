# Deploy em Massa de Clientes RustDesk

Scripts para instalação e configuração automatizada em múltiplos dispositivos.

## Pré-requisitos

Antes de usar os scripts, obtenha:

1. **Config String**: Exporte de um cliente já configurado (Settings → Network → Export Server Config)
2. Substitua `"configstring"` nos scripts pelo valor obtido
3. Opcionalmente, altere a senha permanente modificando a variável `rustdesk_pw`

## Windows — PowerShell

**Arquivo**: `scripts/deploy-client-windows.ps1`

```powershell
# Uso (como Administrador):
# .\deploy-client-windows.ps1

$ErrorActionPreference= 'silentlycontinue'
$rustdesk_pw=(-join ((65..90) + (97..122) | Get-Random -Count 12 | % {[char]$_}))
$rustdesk_cfg="configstring"

# ... (script completo no arquivo scripts/deploy-client-windows.ps1)
```

O script:
- Baixa a versão mais recente do RustDesk
- Instala como serviço Windows
- Aplica a configuração do servidor
- Define senha aleatória
- Exibe o ID e a senha ao final

## Windows — Batch

Para ambientes sem PowerShell:

```bat
@echo off
set rustdesk_cfg="configstring"

curl -L "https://github.com/rustdesk/rustdesk/releases/download/1.2.6/rustdesk-1.2.6-x86_64.exe" -o rustdesk.exe
rustdesk.exe --silent-install
timeout /t 20

cd "C:\Program Files\RustDesk\"
rustdesk.exe --install-service
timeout /t 20
```

## Windows — MSI

Para ambientes gerenciados (Intune, GPO, SCCM):

```bash
msiexec /i rustdesk-<versao>-x86_64.msi /quiet /norestart
```

Consulte a [documentação MSI](https://rustdesk.com/docs/en/client/windows/msi/) para parâmetros adicionais.

## Linux — Bash

**Arquivo**: `scripts/deploy-client-linux.sh`

```bash
# Uso (como root):
# sudo bash deploy-client-linux.sh

rustdesk_pw=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
rustdesk_cfg="configstring"
```

O script detecta automaticamente a distribuição (Debian/Ubuntu, CentOS/RHEL/Fedora), instala o pacote adequado e aplica a configuração.

## macOS — Bash

**Arquivo**: `scripts/deploy-client-macos.sh`

```bash
# Uso (solicitará sudo):
# bash deploy-client-macos.sh

rustdesk_pw=$(openssl rand -hex 4)
rustdesk_cfg="configstring"
```

O script:
- Detecta arquitetura (ARM64 ou x86_64)
- Baixa e monta o DMG
- Instala o aplicativo
- Aplica configuração e senha

## Deploy Explicíto (Pro)

Se o servidor exigir deploy explícito (Settings → Others → Require deployment for new devices):

```bash
# Obter API token no console web (Admin → API Tokens)
rustdesk --deploy --token <api_token>

# Com ID personalizado
rustdesk --deploy --token <api_token> --id <custom_id>
```

## Saída Esperada

Todos os scripts exibem ao final:

```
RustDesk ID: <id_do_dispositivo>
Password: <senha_aleatoria>
...............................................
```

---

