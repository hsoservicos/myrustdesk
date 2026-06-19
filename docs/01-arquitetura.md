# Arquitetura do RustDesk Server OSS

## Visão Geral

O RustDesk Server OSS é composto por dois serviços binários que trabalham juntos para estabelecer conexões remotas seguras entre dispositivos.

## Componentes

### hbbs — Servidor de ID / Sinalização

Responsável por:
- Registrar e gerenciar os IDs dos dispositivos
- Estabelecer a sinalização inicial entre cliente e destino
- Realizar hole punching NAT para conexão direta (P2P)
- Servir a chave pública para criptografia

### hbbr — Servidor de Retransmissão

Responsável por:
- Atuar como relay quando o hole punching falha
- Encaminhar tráfego criptografado entre cliente e destino

## Fluxo de Conexão

```
┌───────────┐        ┌──────────┐        ┌──────────┐
│ Cliente A │        │  hbbs    │        │ Cliente B │
│ (Origem)  │        │  (ID)    │        │ (Destino) │
└─────┬─────┘        └────┬─────┘        └─────┬─────┘
      │                   │                    │
      │  ① Ping ID/hbbs   │                    │
      │──────────────────►│                    │
      │                   │   ② Ping ID/hbbs   │
      │                   │◄───────────────────│
      │                   │                    │
      │  ③ Solicita conexão com B             │
      │──────────────────►│                    │
      │                   │                    │
      │        ④ Tenta hole punching          │
      │◄──────────────────────────────────────►│
      │                                        │
      │  ╔══════════════════════════════════╗  │
      │  ║ Se hole punching falhar:         ║  │
      │  ║                                  ║  │
      │  ║ A ──► hbbr (relay) ──► B         ║  │
      │  ╚══════════════════════════════════╝  │
      │                   │                    │
      │        ⑤ Conexão estabelecida         │
      │◄──────────────────────────────────────►│
```

## Portas de Rede

### Portas Mínimas Necessárias

| Porta | Protocolo | Serviço | Função |
|---|---|---|---|
| 21115 | TCP | hbbs | Teste de tipo NAT |
| 21116 | TCP | hbbs | Hole punching TCP e conexão |
| 21116 | UDP | hbbs | Registro de ID e heartbeat |
| 21117 | TCP | hbbr | Serviço de retransmissão |

### Portas Opcionais

| Porta | Protocolo | Serviço | Função |
|---|---|---|---|
| 21114 | TCP | hbbs | API HTTP (apenas Pro) |
| 21118 | TCP | hbbs | Suporte a cliente Web |
| 21119 | TCP | hbbr | Suporte a cliente Web |

> Se não for usar o cliente web, as portas 21118 e 21119 podem permanecer fechadas.

## Modelo de Tráfego

| Cenário | Tráfego estimado |
|---|---|
| Hole punching direto (P2P) | Zero no servidor |
| Retransmissão (escritório) | ~100 K/s |
| Retransmissão (1920x1080) | 30 K/s - 3 M/s |

## Requisitos de Hardware

- **CPU**: Mínimo — qualquer processador moderno (Raspberry Pi incluso)
- **RAM**: Mínimo — 128 MB
- **Disco**: ~100 MB para binários + logs
- **Rede**: Conexão estável com as portas acima liberadas

---

