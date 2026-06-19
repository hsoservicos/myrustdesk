# Auditoria de Aplicativos Cliente — RustDesk

> **Data:** 19 Jun 2026
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

A pasta `apps/` contém **7 arquivos** da versão **1.4.7** (268 MB total):

| Arquivo | Tamanho | Para qual sistema |
|---|---|---|
| `rustdesk-1.4.7-x86_64.exe` | 24 MB | Windows (instalador executável) |
| `rustdesk-1.4.7-x86_64.msi` | 24 MB | Windows (instalador MSI — deploy em massa) |
| `rustdesk-1.4.7-x86_64.dmg` | 31 MB | macOS Intel |
| `rustdesk-1.4.7-x86_64.deb` | 23 MB | Linux Ubuntu/Debian (x86_64) |
| `rustdesk-1.4.7-x86_64.flatpak` | 23 MB | Linux Flatpak (x86_64) |
| `rustdesk-1.4.7-aarch64.AppImage` | 74 MB | Linux ARM64 (AppImage) |
| `rustdesk-1.4.7-universal-signed.apk` | 69 MB | Android (APK universal) |

### O que ainda está faltando

| Plataforma | Arquivo ausente | Link para download |
|---|---|---|
| **macOS Apple Silicon** | `rustdesk-1.4.7-aarch64.dmg` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-aarch64.dmg) |
| **Linux .deb ARM64** | `rustdesk-1.4.7-aarch64.deb` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-aarch64.deb) |
| **Linux .deb ARMv7** | `rustdesk-1.4.7-armv7-sciter.deb` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-armv7-sciter.deb) |
| **Linux RPM (Fedora) x86_64** | `rustdesk-1.4.7-0.x86_64.rpm` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.x86_64.rpm) |
| **Linux RPM (Fedora) ARM64** | `rustdesk-1.4.7-0.aarch64.rpm` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.aarch64.rpm) |
| **Linux AppImage x86_64** | `rustdesk-1.4.7-x86_64.AppImage` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.AppImage) |
| **Linux Flatpak ARM64** | `rustdesk-1.4.7-aarch64.flatpak` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-aarch64.flatpak) |
| **Windows 32-bit** | `rustdesk-1.4.7-x86-sciter.exe` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86-sciter.exe) |

> Instaladores iOS, Arch Linux (.pkg.tar.zst) e Web não são baixáveis
> localmente — são distribuídos via App Store, AUR e site oficial.

---

## 2. Links oficiais para download (v1.4.7)

> Fonte oficial: https://github.com/rustdesk/rustdesk/releases/tag/1.4.7

### Windows

| Arquitetura | Instalador | Link |
|---|---|---|
| x86-64 (64-bit) | **EXE** | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.exe |
| x86-64 (64-bit) | **MSI** | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.msi |
| x86-32 (32-bit) | **EXE** (legado) | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86-sciter.exe |

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
| Fedora/RHEL | x86_64 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.x86_64.rpm |
| Fedora/RHEL | ARM64 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.aarch64.rpm |
| Suse | x86_64 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.x86_64-suse.rpm |
| Suse | ARM64 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.aarch64-suse.rpm |
| Arch Linux | x86_64 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0-x86_64.pkg.tar.zst |
| Flatpak | x86_64 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.flatpak |
| Flatpak | ARM64 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-aarch64.flatpak |
| AppImage | x86_64 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.AppImage |
| AppImage | ARM64 | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-aarch64.AppImage |

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

| # | Plataforma | Arquivo | Status em `apps/` | Tamanho |
|---|---|---|---|---|
| 1 | Windows 64-bit | `rustdesk-1.4.7-x86_64.exe` | ✅ | 24 MB |
| 2 | Windows 64-bit | `rustdesk-1.4.7-x86_64.msi` | ✅ | 24 MB |
| 3 | Windows 32-bit | `rustdesk-1.4.7-x86-sciter.exe` | ❌ | — |
| 4 | macOS Intel | `rustdesk-1.4.7-x86_64.dmg` | ✅ | 31 MB |
| 5 | macOS Apple Silicon | `rustdesk-1.4.7-aarch64.dmg` | ❌ | — |
| 6 | Linux .deb (x86_64) | `rustdesk-1.4.7-x86_64.deb` | ✅ | 23 MB |
| 7 | Linux .deb (ARM64) | `rustdesk-1.4.7-aarch64.deb` | ❌ | — |
| 8 | Linux .deb (ARMv7) | `rustdesk-1.4.7-armv7-sciter.deb` | ❌ | — |
| 9 | Linux .rpm (x86_64) | `rustdesk-1.4.7-0.x86_64.rpm` | ❌ | — |
| 10 | Linux .rpm (ARM64) | `rustdesk-1.4.7-0.aarch64.rpm` | ❌ | — |
| 11 | Linux Flatpak (x86_64) | `rustdesk-1.4.7-x86_64.flatpak` | ✅ | 23 MB |
| 12 | Linux Flatpak (ARM64) | `rustdesk-1.4.7-aarch64.flatpak` | ❌ | — |
| 13 | Linux AppImage (x86_64) | `rustdesk-1.4.7-x86_64.AppImage` | ❌ | — |
| 14 | Linux AppImage (ARM64) | `rustdesk-1.4.7-aarch64.AppImage` | ✅ | 74 MB |
| 15 | Android APK Universal | `rustdesk-1.4.7-universal-signed.apk` | ✅ | 69 MB |
| 16 | iOS | App Store | N/A | — |
| 17 | Web | rustdesk.com/web | N/A | — |

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
>
> ⚠️ **A pasta `apps/` serve como cache local** para instalação manual ou
> para quando não há internet. Se for usar os scripts automáticos, a pasta
> não é necessária.

---

## 5. Versões desatualizadas na documentação

A auditoria identificou **URLs hardcoded com versões antigas** em arquivos
de documentação. Elas foram corrigidas para a versão 1.4.7:

| Arquivo | Linha original | Versão antiga | Status |
|---|---|---|---|
| `MANUAL_IMPLANTACAO.md` | 433 | **1.2.6** | ✅ Corrigido para 1.4.7 |
| `docs/04-deployment-clientes.md` | 43 | **1.2.6** | ✅ Corrigido para 1.4.7 |
| `docs/11-manual-operacional-cliente.md` | 145 | **1.4.0** | ✅ Corrigido para 1.4.7 |
| `docs/11-manual-operacional-cliente.md` | 158 | **1.4.0** | ✅ Corrigido para 1.4.7 |

---

## 6. Anexo: SHA-256 checksums dos arquivos baixados

```
$ sha256sum apps/*

c451c9e0a6395fd0c4ba8c359ecb4368a7af8c052d1187da956017f802a3ec54  rustdesk-1.4.7-aarch64.AppImage
e8d1189dafd63acfa3c32098413a5da8aa033334f06b38e315c7bee717ec22f5  rustdesk-1.4.7-universal-signed.apk
12f61bb5ceb10a708089903357bd1f98dcb618bd0ea56ec568aaf1713a38070a  rustdesk-1.4.7-x86_64.deb
421c114dea7e15e6c501513847c03a83b97e5e19d6bcf2a724b36ddfb16109b2  rustdesk-1.4.7-x86_64.dmg
d3af4216c653e6ac0a98810dc59080ea26fb03045b79dbb6f859f3c954402c9f  rustdesk-1.4.7-x86_64.exe
b558f19436005e07b4f3763ae4b58a771b4533429017abbdfeea0b460e914f62  rustdesk-1.4.7-x86_64.flatpak
106849afa83e852b8f972efa84007d6b1a9d2f02de14c3c4977cf090e2bacb88  rustdesk-1.4.7-x86_64.msi
```
