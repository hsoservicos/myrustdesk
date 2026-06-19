# Manutenção do Servidor RustDesk

## Atualização do Servidor

### Docker (Recomendado)

```bash
# Atualizar a imagem
sudo docker compose pull

# Recriar containers com a nova imagem
sudo docker compose up -d

# Remover imagens antigas
sudo docker image prune
```

### Script de Instalação

O repositório [Techahold/rustdeskinstall](https://github.com/techahold/rustdeskinstall) contém script de atualização.

### Pacote .deb

```bash
sudo apt-get update
sudo apt-get install --only-upgrade rustdesk-server-hbbs rustdesk-server-hbbr
```

## Backup

O único diretório com dados persistentes é `./data/`. Faça backup regularmente:

```bash
# Backup
tar -czf rustdesk-backup-$(date +%Y%m%d).tar.gz ./data/

# Restauração
tar -xzf rustdesk-backup-20250101.tar.gz
sudo docker compose restart
```

O que é preservado no backup:
- Chave privada `id_ed25519` (não compartilhe!)
- Chave pública `id_ed25519.pub`
- Configurações do servidor

## Logs e Monitoramento

### Docker

```bash
# Ver logs em tempo real
sudo docker compose logs -f

# Ver últimas N linhas
sudo docker compose logs --tail=100

# Logs de um serviço específico
sudo docker logs hbbs --tail=50
sudo docker logs hbbr --tail=50
```

### systemd (instalação nativa)

```bash
sudo journalctl -u rustdesk-hbbs -f
sudo journalctl -u rustdesk-hbbr -f
```

## Verificação de Saúde

```bash
# Verificar se os containers estão rodando
sudo docker compose ps

# Verificar portas abertas
sudo ss -tlnp | grep -E '2111[4-9]'
sudo ss -ulnp | grep 21116

# Testar conectividade do servidor
curl -s -o /dev/null -w "%{http_code}" http://localhost:21114 || echo "Porta 21114 (API Pro) não disponível"
```

## Reinicialização

```bash
# Após reboot do sistema (se configurado com restart: unless-stopped)
sudo docker compose start

# Se os containers pararam inesperadamente
sudo docker compose restart
```

## Programação de Backup (Cron)

Adicione ao crontab para backups automáticos:

```bash
# Editar crontab
crontab -e

# Adicionar linha (backup diário às 2h)
0 2 * * * cd /caminho/para/rustdesk && tar -czf backups/rustdesk-$(date +\%Y\%m\%d).tar.gz ./data/ && find backups/ -name "*.tar.gz" -mtime +30 -delete
```
---

