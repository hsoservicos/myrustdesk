# Configuração de Clientes RustDesk

Após o servidor estar rodando, configure cada dispositivo cliente com o endereço do servidor e a chave pública.

## Informações Necessárias

| Campo | Onde obter |
|---|---|
| **ID Server** | IP ou hostname do servidor onde o `hbbs` está rodando |
| **Key** | Conteúdo do arquivo `./data/id_ed25519.pub` no servidor |
| **Relay Server** | Opcional — o RustDesk infere automaticamente a partir do ID Server |

## Configuração Manual

### Windows / Linux / macOS

1. Abra o RustDesk Client
2. Clique no menu `☰` (ou `⋯`) ao lado do ID
3. Acesse **Configurações → Rede**
4. Clique em **Desbloquear** (necessário privilégios elevados)
5. Preencha:

   | Campo | Valor |
   |---|---|
   | **Servidor ID** | `seu-servidor:21116` (ex: `192.168.1.100:21116`) |
   | **Chave** | Cole a chave pública obtida do servidor |
   | **Servidor Relay** | Deixe em branco |

   Apenas o **Servidor ID** e a **Chave** são obrigatórios.
6. Clique em **Aplicar**

### Android

1. Abra o RustDesk Client
2. Toque no menu `⋯` ao lado do ID
3. Acesse **Configurações → Rede**
4. Preencha os campos **Servidor ID** e **Chave**
5. Toque em **OK**

## Método de Importação/Exportação

Útil para configurar múltiplos dispositivos sem digitar:

1. Em um dispositivo já configurado, vá em **Configurações → Rede**
2. Clique em **Exportar Config do Servidor**
3. Cole o texto copiado em um bloco de notas
4. No novo dispositivo, vá em **Configurações → Rede**
5. Clique em **Importar Config do Servidor**
6. Clique em **Aplicar**

## Configuração via Linha de Comando

Útil para automação e scripts:

```bash
# No terminal do cliente
rustdesk --config <config-string>
```

O `config-string` pode ser obtido exportando a configuração de um cliente já configurado (Settings → Network → Export Server Config).

## Configuração Avançada

### Forçar Relay

Se o hole punching não funcionar na rede, configure o relay explicitamente:

| Campo | Valor |
|---|---|
| **Servidor ID** | `servidor:21116` |
| **Servidor Relay** | `servidor:21117` |
| **Chave** | `<chave_publica>` |

### Cliente Web (Opcional)

Para usar o [Cliente Web RustDesk](https://rustdesk.com/web/), é necessário configurar um proxy reverso Nginx com suporte WSS (WebSocket Secure). Consulte a documentação oficial para detalhes.
