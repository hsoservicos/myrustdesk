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

A pasta `apps/` contém **15 arquivos** da versão **1.4.7** (457 MB total):

| # | Arquivo | Tamanho | Para qual sistema |
|---|---|---|---|
| 1 | `rustdesk-1.4.7-x86_64.exe` | 24 MB | Windows (instalador executável 64-bit) |
| 2 | `rustdesk-1.4.7-x86_64.msi` | 24 MB | Windows (instalador MSI 64-bit) |
| 3 | `rustdesk-1.4.7-x86-sciter.exe` | 12 MB | Windows (instalador executável 32-bit) |
| 4 | `rustdesk-1.4.7-x86_64.dmg` | 31 MB | macOS Intel |
| 5 | `rustdesk-1.4.7-aarch64.dmg` | 25 MB | macOS Apple Silicon |
| 6 | `rustdesk-1.4.7-x86_64.deb` | 23 MB | Linux Ubuntu/Debian (x86_64) |
| 7 | `rustdesk-1.4.7-aarch64.deb` | 21 MB | Linux Ubuntu/Debian (ARM64) |
| 8 | `rustdesk-1.4.7-armv7-sciter.deb` | 13 MB | Linux Ubuntu/Debian (ARMv7) |
| 9 | `rustdesk-1.4.7-x86_64.flatpak` | 23 MB | Linux Flatpak (x86_64) |
| 10 | `rustdesk-1.4.7-aarch64.flatpak` | 22 MB | Linux Flatpak (ARM64) |
| 11 | `rustdesk-1.4.7-aarch64.AppImage` | 74 MB | Linux AppImage (ARM64) |
| 12 | `rustdesk-1.4.7-universal-signed.apk` | 69 MB | Android (APK universal) |
| 13 | `rustdesk-1.4.7-aarch64-signed.apk` | 26 MB | Android (APK ARM64 only) |
| 14 | `rustdesk-1.4.7-armv7-signed.apk` | 25 MB | Android (APK ARMv7 only) |

> ⚠️ **Duplicata:** `rustdesk-1.4.7-aarch64 (1).dmg` (25 MB) é cópia
> idêntica de `rustdesk-1.4.7-aarch64.dmg` (mesmo SHA-256) — gerada por
> download repetido no navegador. Pode ser removida.

### Ainda faltando (7 arquivos)

| Plataforma | Arquivo ausente | Link |
|---|---|---|
| **Linux RPM (Fedora) x86_64** | `rustdesk-1.4.7-0.x86_64.rpm` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.x86_64.rpm) |
| **Linux RPM (Fedora) ARM64** | `rustdesk-1.4.7-0.aarch64.rpm` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.aarch64.rpm) |
| **Linux RPM (Suse) x86_64** | `rustdesk-1.4.7-0.x86_64-suse.rpm` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.x86_64-suse.rpm) |
| **Linux RPM (Suse) ARM64** | `rustdesk-1.4.7-0.aarch64-suse.rpm` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0.aarch64-suse.rpm) |
| **Linux AppImage x86_64** | `rustdesk-1.4.7-x86_64.AppImage` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.AppImage) |
| **Linux Arch Linux** | `rustdesk-1.4.7-0-x86_64.pkg.tar.zst` | [Download](https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-0-x86_64.pkg.tar.zst) |

> iOS, Web e outros formatos não são baixáveis localmente (App Store/AUR/site).

---

## 2. Links oficiais para download (v1.4.7)

> Fonte: https://github.com/rustdesk/rustdesk/releases/tag/1.4.7

### Windows

| Arquitetura | Instalador | Link |
|---|---|---|
| x86-64 (64-bit) | EXE | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.exe |
| x86-64 (64-bit) | MSI | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-x86_64.msi |
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
| APK Universal | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-universal-signed.apk |
| APK ARM64 apenas | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-aarch64-signed.apk |
| APK ARMv7 apenas | https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-armv7-signed.apk |

### iOS / Web

| Plataforma | Onde obter |
|---|---|
| iPhone/iPad (iOS) | https://apps.apple.com/us/app/rustdesk-remote-desktop/id1581225015 |
| Cliente Web | https://rustdesk.com/web/ |

---

## 3. Tabela completa de downloads

| # | Plataforma | Arquivo | apps/ | Tamanho |
|---|---|---|---|---|
| 1 | Windows x64 EXE | `rustdesk-1.4.7-x86_64.exe` | ✅ | 24 MB |
| 2 | Windows x64 MSI | `rustdesk-1.4.7-x86_64.msi` | ✅ | 24 MB |
| 3 | Windows x86-32 EXE | `rustdesk-1.4.7-x86-sciter.exe` | ✅ | 12 MB |
| 4 | macOS Intel | `rustdesk-1.4.7-x86_64.dmg` | ✅ | 31 MB |
| 5 | macOS Apple Silicon | `rustdesk-1.4.7-aarch64.dmg` | ✅ | 25 MB |
| 6 | Linux .deb x86_64 | `rustdesk-1.4.7-x86_64.deb` | ✅ | 23 MB |
| 7 | Linux .deb ARM64 | `rustdesk-1.4.7-aarch64.deb` | ✅ | 21 MB |
| 8 | Linux .deb ARMv7 | `rustdesk-1.4.7-armv7-sciter.deb` | ✅ | 13 MB |
| 9 | Linux .rpm x86_64 | `rustdesk-1.4.7-0.x86_64.rpm` | ❌ | — |
| 10 | Linux .rpm ARM64 | `rustdesk-1.4.7-0.aarch64.rpm` | ❌ | — |
| 11 | Linux .rpm Suse x86_64 | `rustdesk-1.4.7-0.x86_64-suse.rpm` | ❌ | — |
| 12 | Linux .rpm Suse ARM64 | `rustdesk-1.4.7-0.aarch64-suse.rpm` | ❌ | — |
| 13 | Linux Arch x86_64 | `rustdesk-1.4.7-0-x86_64.pkg.tar.zst` | ❌ | — |
| 14 | Linux Flatpak x86_64 | `rustdesk-1.4.7-x86_64.flatpak` | ✅ | 23 MB |
| 15 | Linux Flatpak ARM64 | `rustdesk-1.4.7-aarch64.flatpak` | ✅ | 22 MB |
| 16 | Linux AppImage x86_64 | `rustdesk-1.4.7-x86_64.AppImage` | ❌ | — |
| 17 | Linux AppImage ARM64 | `rustdesk-1.4.7-aarch64.AppImage` | ✅ | 74 MB |
| 18 | Android APK Universal | `rustdesk-1.4.7-universal-signed.apk` | ✅ | 69 MB |
| 19 | Android APK ARM64 | `rustdesk-1.4.7-aarch64-signed.apk` | ✅ | 26 MB |
| 20 | Android APK ARMv7 | `rustdesk-1.4.7-armv7-signed.apk` | ✅ | 25 MB |
| 21 | iOS | App Store | N/A | — |
| 22 | Web | rustdesk.com/web | N/A | — |

---

## 4. Onde os scripts baixam os aplicativos

Todos os scripts de deploy **não usam** `apps/`. Baixam dinamicamente via API GitHub:

| Script | O que baixa | Como |
|---|---|---|
| `deploy-client-windows.ps1` | `.exe` ou `.msi` | API → detecta última versão → baixa |
| `deploy-client-linux.sh` | `.deb` ou `.rpm` | API → detecta arquitetura → baixa |
| `deploy-client-macos.sh` | `.dmg` | API → detecta Intel/ARM → baixa |

> ✅ **Sempre versão mais recente.**
> ⚠️ `apps/` é cache local para instalação manual/sem internet.

---

## 5. Versões desatualizadas na documentação

URLs hardcoded encontradas e corrigidas para 1.4.7:

| Arquivo | Versão antiga | Status |
|---|---|---|
| `MANUAL_IMPLANTACAO.md` (linha 433) | **1.2.6** → 1.4.7 | ✅ |
| `docs/04-deployment-clientes.md` (linha 43) | **1.2.6** → 1.4.7 | ✅ |
| `docs/11-manual-operacional-cliente.md` (linha 145) | **1.4.0** → 1.4.7 | ✅ |
| `docs/11-manual-operacional-cliente.md` (linha 158) | **1.4.0** → 1.4.7 | ✅ |

---

## 6. Anexo: SHA-256 checksums dos arquivos baixados

```
apps/rustdesk-1.4.7-aarch64.AppImage
  c451c9e0a6395fd0c4ba8c359ecb4368a7af8c052d1187da956017f802a3ec54

apps/rustdesk-1.4.7-aarch64.deb
  36bf7758896feaee49c586dfb673bfead5f5c49a8217bf82c475c77758b58809

apps/rustdesk-1.4.7-aarch64.dmg
  f77e517fa792c8d46eb9eade3a2ce74f68d7f585924fc4202719f4ed82038ead

apps/rustdesk-1.4.7-aarch64.flatpak
  502f8571e7d62ee2a8d84eb38745644251f5940ca00ff7305a99b27dc1110a4c

apps/rustdesk-1.4.7-aarch64-signed.apk
  dc4cea9f1da5ec73bfbc0a428160c74f1a3618d61a1d873a7bcb38b7f8b2f6a7

apps/rustdesk-1.4.7-armv7-sciter.deb
  c4300614788f55c47ce6e441345bdb140a2da0b6e1420db92d8ce87bf3a40f50

apps/rustdesk-1.4.7-armv7-signed.apk
  0e6fb0c568edca415645c81a111dc8a239dc22204a06c1c3b9a8aaa00d907859

apps/rustdesk-1.4.7-universal-signed.apk
  e8d1189dafd63acfa3c32098413a5da8aa033334f06b38e315c7bee717ec22f5

apps/rustdesk-1.4.7-x86_64.deb
  12f61bb5ceb10a708089903357bd1f98dcb618bd0ea56ec568aaf1713a38070a

apps/rustdesk-1.4.7-x86_64.dmg
  421c114dea7e15e6c501513847c03a83b97e5e19d6bcf2a724b36ddfb16109b2

apps/rustdesk-1.4.7-x86_64.exe
  d3af4216c653e6ac0a98810dc59080ea26fb03045b79dbb6f859f3c954402c9f

apps/rustdesk-1.4.7-x86_64.flatpak
  b558f19436005e07b4f3763ae4b58a771b4533429017abbdfeea0b460e914f62

apps/rustdesk-1.4.7-x86_64.msi
  106849afa83e852b8f972efa84007d6b1a9d2f02de14c3c4977cf090e2bacb88

apps/rustdesk-1.4.7-x86-sciter.exe
  b64a0b75678678e9bf7c501c5eed24005a5814f8d8cac6b6b67df973a03de22d
```

> **Duplicata (pode remover):** `apps/rustdesk-1.4.7-aarch64 (1).dmg`
> SHA-256 `f77e517f...` — idêntico a `rustdesk-1.4.7-aarch64.dmg`
