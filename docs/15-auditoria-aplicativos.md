# Auditoria de Aplicativos Cliente — RustDesk

> **Data:** Junho 2026
> **Versão mais recente:** 1.4.7 (lançada 02 Jun 2026)
> **Repositório oficial:** https://github.com/rustdesk/rustdesk/releases

---

## Sumário

1. [Aplicativos já baixados no projeto](#1-aplicativos-já-baixados-no-projeto)
2. [Links oficiais para download (v1.4.7)](#2-links-oficiais-para-download-v147)
3. [Tabela completa de downloads](#3-tabela-completa-de-downloads)
4. [Onde os scripts baixam os aplicativos](#4-onde-os-scripts-baixam-os-aplicativos)
5. [Versões desatualizadas na documentação](#5-versões-desatualizadas-na-documentação)
6. [Anexo: SHA-256 checksums dos arquivos baixados](#6-anexo-sha-256-checksums-dos-arquivos-baixados)

---

## 1. Aplicativos já baixados no projeto

A pasta `apps/` contém **4 arquivos** da versão **1.4.7** (atual):
atual, mesma versão do release oficial mais recente):

| Arquivo | Tamanho | Para qual sistema |
|---|---|---|
| `apps/rustdesk-1.4.7-x86_64.exe` | 24 MB | Windows (instalador executável) |
| `apps/rustdesk-1.4.7-x86_64.msi` | 24 MB | Windows (instalador MSI — deploy em massa) |
| `apps/rustdesk-1.4.7-x86_64.deb` | 23 MB | Linux Ubuntu/Debian (pacote .deb) |
| `apps/rustdesk-1.4.7-universal-signed.apk` | 69 MB | Android (APK universal) |

### O que está faltando

| Plataforma | Arquivo ausente | Link para download |
|---|---|---|
| **macOS Intel** | `rustdesk-1.4.7-x86_64.dmg` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.dmg) |
| **macOS Apple Silicon** | `rustdesk-1.4.7-aarch64.dmg` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-aarch64.dmg) |
| **Linux (RPM — Fedora)** | `rustdesk-1.4.7-0.x86_64.rpm` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.x86_64.rpm) |
| **Linux (AppImage)** | `rustdesk-1.4.7-x86_64.AppImage` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.AppImage) |
| **Linux ARM64** | `rustdesk-1.4.7-aarch64.deb` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-aarch64.deb) |
| **Linux ARMv7** | `rustdesk-1.4.7-armv7-sciter.deb` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-armv7-sciter.deb) |
| **Windows 32-bit** | `rustdesk-1.4.7-x86-sciter.exe` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86-sciter.exe) |

> 💡 **Nota:** Os instaladores do iOS, Flatpak e Web não são arquivos
> baixáveis — são distribuídos via App Store, Flathub e site oficial.

---

## 2. Links oficiais para download (v1.4.7)

> Fonte oficial: https://github.com/rustdesk/rustdesk/releases/tag/1.4.7

### Windows

| Arquitetura | Instalador | Link |
|---|---|---|
| x86-64 (64-bit) | **EXE** | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.exe |
| x86-64 (64-bit) | **MSI** | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.msi |
| x86-32 (32-bit) | EXE (legado) | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86-sciter.exe |

### macOS

| Arquitetura | Link |
|---|---|
| Intel (x86_64) | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.dmg |
| Apple Silicon (ARM64) | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-aarch64.dmg |

### Linux

| Distribuição | Arquitetura | Link |
|---|---|---|
| Ubuntu/Debian | x86_64 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.deb |
| Ubuntu/Debian | ARM64 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-aarch64.deb |
| Ubuntu/Debian | ARMv7 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-armv7-sciter.deb |
| Fedora/RHEL | x86_64 (RPM) | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.x86_64.rpm |
| Fedora/RHEL | ARM64 (RPM) | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.aarch64.rpm |
| Suse | x86_64 (RPM) | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.x86_64-suse.rpm |
| Suse | ARM64 (RPM) | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.aarch64-suse.rpm |
| Arch Linux | x86_64 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0-x86_64.pkg.tar.zst |
| Universal (Flatpak) | x86_64 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.flatpak |
| Universal (Flatpak) | ARM64 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-aarch64.flatpak |
| Universal (AppImage) | x86_64 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.AppImage |

### Android

| Tipo | Link |
|---|---|
| APK Universal (x86_64 + ARM64 + ARMv7) | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-universal-signed.apk |
| APK ARM64 (apenas) | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-aarch64-signed.apk |
| APK ARMv7 (apenas) | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-armv7-signed.apk |

### iOS / Web

| Plataforma | Onde obter |
|---|---|
| **iPhone/iPad (iOS)** | Apple App Store: https://apps.apple.com/us/app/rustdesk-remote-desktop/id1581225015 |
| **Cliente Web** | https://rustdesk.com/web/ |

---

## 3. Tabela completa de downloads

| # | Plataforma | Arquivo | Status no projeto | Tamanho |
|---|---|---|---|---|
| 1 | Windows 64-bit | `rustdesk-1.4.7-x86_64.exe` | ✅ `apps/` | 24 MB |
| 2 | Windows 64-bit | `rustdesk-1.4.7-x86_64.msi` | ✅ `apps/` | 24 MB |
| 3 | Windows 32-bit | `rustdesk-1.4.7-x86-sciter.exe` | ❌ Ausente | — |
| 4 | macOS Intel | `rustdesk-1.4.7-x86_64.dmg` | ❌ Ausente | — |
| 5 | macOS Apple Silicon | `rustdesk-1.4.7-aarch64.dmg` | ❌ Ausente | — |
| 6 | Linux .deb (x86_64) | `rustdesk-1.4.7-x86_64.deb` | ✅ `apps/` | 23 MB |
| 7 | Linux .deb (ARM64) | `rustdesk-1.4.7-aarch64.deb` | ❌ Ausente | — |
| 8 | Linux .deb (ARMv7) | `rustdesk-1.4.7-armv7-sciter.deb` | ❌ Ausente | — |
| 9 | Linux .rpm (x86_64) | `rustdesk-1.4.7-0.x86_64.rpm` | ❌ Ausente | — |
| 10 | Linux AppImage (x86_64) | `rustdesk-1.4.7-x86_64.AppImage` | ❌ Ausente | — |
| 11 | Android APK Universal | `rustdesk-1.4.7-universal-signed.apk` | ✅ `apps/` | 69 MB |
| 12 | iOS | App Store | N/A | — |
| 13 | Web | rustdesk.com/web | N/A | — |

---

## 4. Onde os scripts baixam os aplicativos

Todos os scripts de deploy **não usam** os arquivos da pasta `apps/`. Em vez
disso, eles baixam a versão mais recente **dinamicamente** via API do GitHub
a cada execução:

| Script | O que baixa | Como |
|---|---|---|
| `deploy-client-windows.ps1` | `.exe` ou `.msi` | API GitHub → detecta versão → baixa do releases |
| `deploy-client-linux.sh` | `.deb` ou `.rpm` | API GitHub → detecta arquitetura → baixa do releases |
| `deploy-client-macos.sh` | `.dmg` | API GitHub → detecta Intel/Apple Silicon → baixa |

> ✅ **Vantagem:** Os scripts sempre usam a versão mais recente, sem precisar
> atualizar manualmente a pasta `apps/`.

> ⚠️ **A pasta `apps/` serve como cache local** para instalação manual ou
> para quando não há internet. Se for usar os scripts automáticos, a pasta
> não é necessária.

---

## 5. Versões desatualizadas na documentação

A auditoria identificou **URLs hardcoded com versões antigas** em arquivos
de documentação. Elas devem ser atualizadas para apontar para a versão mais
recente ou para a página de releases.

### 5.1 URLs desatualizadas encontradas

| Arquivo | Linha | Versão antiga | Link |
|---|---|---|---|
| `MANUAL_IMPLANTACAO.md` | 433 | **1.2.6** | `.../download/1.2.6/rustdesk-1.2.6-x86_64.deb` |
| `docs/04-deployment-clientes.md` | 43 | **1.2.6** | `.../download/1.2.6/rustdesk-1.2.6-x86_64.exe` |
| `docs/11-manual-operacional-cliente.md` | 145 | **1.4.0** | `.../download/1.4.0/rustdesk-1.4.0-x86_64.deb` |
| `docs/11-manual-operacional-cliente.md` | 158 | **1.4.0** | `.../download/1.4.0/rustdesk-1.4.0-0.x86_64.rpm` |

### 5.2 Links corretos (v1.4.7)

| Uso | Link correto |
|---|---|
| Linux .deb (x86_64) | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.deb |
| Windows .exe (x86_64) | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.exe |
| Linux .rpm (x86_64) | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.x86_64.rpm |
| Página de releases | https://github.com/rustdesk/rustdesk/releases |

---

## 6. Anexo: SHA-256 checksums dos arquivos baixados

```
Arquivo: apps/rustdesk-1.4.7-x86_64.exe
SHA-256: <calcular com: sha256sum apps/rustdesk-1.4.7-x86_64.exe>

Arquivo: apps/rustdesk-1.4.7-x86_64.msi
SHA-256: <calcular com: sha256sum apps/rustdesk-1.4.7-x86_64.msi>

Arquivo: apps/rustdesk-1.4.7-x86_64.deb
SHA-256: <calcular com: sha256sum apps/rustdesk-1.4.7-x86_64.deb>

Arquivo: apps/rustdesk-1.4.7-universal-signed.apk
SHA-256: <calcular com: sha256sum apps/rustdesk-1.4.7-universal-signed.apk>
```
