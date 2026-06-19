$ErrorActionPreference= 'silentlycontinue'

# ============================================================
# RustDesk Client Deployment — Windows PowerShell
# Use como Administrador
# ============================================================

# --- CONFIGURE AQUI ---
$rustdesk_cfg="configstring"
# ----------------------

# Gera senha aleatória de 12 caracteres
$rustdesk_pw=(-join ((65..90) + (97..122) | Get-Random -Count 12 | % {[char]$_}))

################################## Não edite abaixo #########################################

# Verifica/eleva para Administrador
if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000)
    {
        Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
        Exit;
    }
}

function getLatest()
{
    $Page = Invoke-WebRequest -Uri 'https://github.com/rustdesk/rustdesk/releases/latest' -UseBasicParsing
    $HTML = New-Object -Com "HTMLFile"
    try
    {
        $HTML.IHTMLDocument2_write($Page.Content)
    }
    catch
    {
        $src = [System.Text.Encoding]::Unicode.GetBytes($Page.Content)
        $HTML.write($src)
    }

    $Downloadlink = ($HTML.Links | Where {$_.href -match '(.)+\/rustdesk\/rustdesk\/releases\/download\/\d{1}.\d{1,2}.\d{1,2}(.{0,3})\/rustdesk(.)+x86_64.exe'} | select -first 1).href
    $Downloadlink = $Downloadlink.Replace('about:', 'https://github.com')

    $Version = "unknown"
    if ($Downloadlink -match './rustdesk/rustdesk/releases/download/(?<content>.*)/rustdesk-(.)+x86_64.exe')
    {
        $Version = $matches['content']
    }

    if ($Version -eq "unknown" -or $Downloadlink -eq "")
    {
        Write-Output "ERROR: Version or download link not found."
        Exit
    }

    $params += @{Version = $Version}
    $params += @{Downloadlink = $Downloadlink}
    $Result = New-Object PSObject -Property $params

    return($Result)
}

$RustDeskOnGitHub = getLatest

$rdver = ((Get-ItemProperty  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\RustDesk\").Version)

if ($rdver -eq $RustDeskOnGitHub.Version)
{
    Write-Output "RustDesk $rdver ja esta na versao mais recente."
    Exit
}

if (!(Test-Path C:\Temp))
{
    New-Item -ItemType Directory -Force -Path C:\Temp | Out-Null
}

cd C:\Temp

Invoke-WebRequest $RustDeskOnGitHub.Downloadlink -Outfile "rustdesk.exe"
Start-Process .\rustdesk.exe --silent-install
Start-Sleep -seconds 20

$ServiceName = 'Rustdesk'
$arrService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($arrService -eq $null)
{
    Write-Output "Instalando servico"
    cd $env:ProgramFiles\RustDesk
    Start-Process .\rustdesk.exe --install-service
    Start-Sleep -seconds 20
    $arrService = Get-Service -Name $ServiceName
}

while ($arrService.Status -ne 'Running')
{
    Start-Service $ServiceName
    Start-Sleep -seconds 5
    $arrService.Refresh()
}

cd $env:ProgramFiles\RustDesk\
.\rustdesk.exe --get-id | Write-Output -OutVariable rustdesk_id

.\rustdesk.exe --config $rustdesk_cfg

.\rustdesk.exe --password $rustdesk_pw

Write-Output "..............................................."
Write-Output "RustDesk ID: $rustdesk_id"
Write-Output "Password: $rustdesk_pw"
Write-Output "..............................................."
