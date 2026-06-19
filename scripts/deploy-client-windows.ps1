$ErrorActionPreference = 'silentlycontinue'

<#
.SYNOPSIS
  RustDesk Client Deployment — Windows PowerShell
  Execute como Administrador
.DESCRIPTION
  Baixa a versão mais recente do RustDesk, instala silenciosamente,
  aplica a configuração do servidor e define senha permanente.
#>

# --- CONFIGURE AQUI ---
$rustdesk_cfg = "configstring"
# ----------------------

$rustdesk_pw = -join ((65..90) + (97..122) | Get-Random -Count 12 | % { [char]$_ })

################################## Não edite abaixo #########################################

if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000)
    {
        Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`""
        Exit
    }
}

$arch = if ([Environment]::Is64BitOperatingSystem) { "x86_64" } else { "x86_32" }

$api = Invoke-RestMethod -Uri "https://api.github.com/repos/rustdesk/rustdesk/releases/latest"
$tag = $api.tag_name -replace '^v'
$exe = "RustDesk-${tag}-${arch}.exe"

$dl = "https://github.com/rustdesk/rustdesk/releases/download/v${tag}/${exe}"

$installed = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\RustDesk\" -ErrorAction SilentlyContinue).Version

if ($installed -eq $tag)
{
    Write-Output "RustDesk ${tag} ja esta na versao mais recente."
}
else
{
    if (!(Test-Path C:\Temp)) { New-Item -ItemType Directory -Force -Path C:\Temp | Out-Null }
    cd C:\Temp

    Write-Output "Baixando RustDesk ${tag}..."
    Invoke-WebRequest $dl -Outfile $exe
    Start-Process .\$exe --silent-install -Wait
    Start-Sleep -Seconds 10
}

cd $env:ProgramFiles\RustDesk

if (!(Get-Service -Name Rustdesk -ErrorAction SilentlyContinue))
{
    Write-Output "Instalando servico RustDesk..."
    .\rustdesk.exe --install-service
    Start-Sleep -Seconds 5
}

$svc = Get-Service -Name Rustdesk -ErrorAction SilentlyContinue
if ($svc.Status -ne 'Running') { Start-Service Rustdesk; Start-Sleep -Seconds 5 }

$rustdesk_id = .\rustdesk.exe --get-id
.\rustdesk.exe --config $rustdesk_cfg
.\rustdesk.exe --password $rustdesk_pw

Write-Output "..............................................."
Write-Output "RustDesk ID: $rustdesk_id"
Write-Output "Senha permanente: $rustdesk_pw"
Write-Output "Servidor configurado com sucesso."
Write-Output "..............................................."
