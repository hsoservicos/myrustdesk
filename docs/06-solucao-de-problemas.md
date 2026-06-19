# Solução de Problemas — RustDesk Server OSS

## 1. Conexão Recusada — Firewall

### Sintoma
Cliente não consegue conectar ou "Connection refused".

### Causa
Portas não liberadas no firewall do servidor.

### Solução
```bash
# Verificar portas abertas (devem aparecer 21115-21117 TCP e 21116 UDP)
sudo ss -tlnp | grep -E '2111[4-9]'
sudo ss -ulnp | grep 21116

# Liberar portas (UFW)
sudo ufw allow 21115:21117/tcp
sudo ufw allow 21116/udp
sudo ufw reload

# Se estiver usando iptables
sudo iptables -A INPUT -p tcp --dport 21115:21117 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 21116 -j ACCEPT
```

## 2. NAT Loopback

### Sintoma
Clientes na mesma rede local do servidor não conseguem conectar usando o IP público.

### Causa
Roteadores não suportam loopback NAT (hairpin NAT).

### Soluções possíveis:
- Use o **IP local** do servidor nos clientes da mesma rede
- Configure NAT loopback no roteador (se suportar)
- Configure um DNS interno apontando para o IP local

### Referência
Consulte a [documentação oficial sobre NAT Loopback](https://rustdesk.com/docs/en/self-host/nat-loopback-issues/).

## 3. Hole Punching Falhando

### Sintoma
Conexões sempre passam pelo relay (maior latência/tráfego).

### Causa
- NAT simétrico em uma das pontas
- Firewall bloqueando hole punching
- CGNAT (Carrier-Grade NAT)

### Soluções:
```bash
# Opção 1: Forçar relay no servidor
# Adicione ao compose.yml:
# environment:
#   - ALWAYS_USE_RELAY=Y

# Opção 2: Verificar tipo de NAT
# O hbbs testa o tipo NAT na porta 21115
```

## 4. Chave Inválida ou Incorreta

### Sintoma
Cliente mostra erro de chave ou "Connection not allowed".

### Solução
Verifique se a chave pública no cliente corresponde ao `id_ed25519.pub` do servidor:

```bash
# Ler chave correta no servidor
sudo cat ./data/id_ed25519.pub

# A chave não deve ter espaços ou quebras de linha extras
```

## 5. Docker — Problemas de Rede

### Sintoma
Containers não conseguem se comunicar ou não respondem.

### Verificações:
```bash
# Verificar logs
sudo docker compose logs

# Testar se hbbs está respondendo
sudo docker exec hbbs hbbs --help

# Verificar network_mode (deve ser "host" no Linux)
sudo docker inspect hbbs | grep -A 5 NetworkMode

# Se não puder usar --net=host (Windows/Mac), mapeie portas:
# ports:
#   - "21115:21115/tcp"
#   - "21116:21116/tcp"
#   - "21116:21116/udp"
#   - "21117:21117/tcp"
```

## 6. Cliente Não Aparece no Servidor

### Sintoma
Dispositivo conecta mas não aparece na lista (Pro) ou não é encontrado por outro ID.

### Soluções:
- Verifique se o cliente está apontando para o **Servidor ID** correto
- Confirme se o heartbeat UDP está chegando (porta 21116/UDP)
- Teste com outro cliente na mesma rede

## 7. Reinicialização Segura

```bash
# Parar tudo
sudo docker compose down

# Verificar se as portas foram liberadas
sudo ss -tlnp | grep 2111

# Iniciar novamente
sudo docker compose up -d

# Verificar logs de inicialização
sudo docker compose logs --tail=30
```

## 8. Problemas de Permissão (Linux)

### Sintoma
Erro "Permission denied" ao acessar `./data/`.

### Solução
```bash
# Ajustar permissões
sudo chown -R 1000:1000 ./data/
# Ou use o usuário atual
sudo chown -R $(id -u):$(id -g) ./data/
```

---

