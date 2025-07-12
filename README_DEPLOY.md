# Guia de Deploy - Mega Sena App para Contabo

## Pré-requisitos

1. **Servidor VPS Contabo** com Ubuntu 20.04 ou superior
2. **Domínio** apontando para o IP do servidor
3. **Acesso SSH** ao servidor

## Passo a Passo do Deploy

### 1. Conectar ao Servidor

```bash
ssh root@seu-ip-do-servidor
```

### 2. Preparar o Sistema

```bash
# Atualizar sistema
apt update && apt upgrade -y

# Instalar dependências
apt install -y python3 python3-pip python3-venv nginx git ufw
```

### 3. Fazer Upload dos Arquivos

**Opção A: Via Git (Recomendado)**
```bash
# No servidor
cd /var/www
git clone https://github.com/seu-usuario/megasena.git
cd megasena
```

**Opção B: Via SCP**
```bash
# No seu computador local
scp -r ./* root@seu-ip:/var/www/megasena/
```

### 4. Configurar Ambiente Virtual

```bash
cd /var/www/megasena
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

### 5. Configurar Permissões

```bash
chown -R www-data:www-data /var/www/megasena
chmod +x start.sh
```

### 6. Configurar Nginx

```bash
# Copiar configuração do Nginx
cp nginx.conf /etc/nginx/sites-available/megasena

# Editar o arquivo para seu domínio
nano /etc/nginx/sites-available/megasena
# Substitua "seu-dominio.com" pelo seu domínio real

# Ativar site
ln -sf /etc/nginx/sites-available/megasena /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Testar configuração
nginx -t

# Reiniciar Nginx
systemctl restart nginx
```

### 7. Configurar SSL (Certbot)

```bash
# Instalar Certbot
apt install -y certbot python3-certbot-nginx

# Obter certificado SSL
certbot --nginx -d seu-dominio.com -d www.seu-dominio.com

# Configurar renovação automática
crontab -e
# Adicionar linha: 0 12 * * * /usr/bin/certbot renew --quiet
```

### 8. Configurar Systemd Service

```bash
# Copiar arquivo de serviço
cp systemd.service /etc/systemd/system/megasena.service

# Ativar e iniciar serviço
systemctl daemon-reload
systemctl enable megasena.service
systemctl start megasena.service
```

### 9. Configurar Firewall

```bash
ufw allow 22
ufw allow 80
ufw allow 443
ufw --force enable
```

### 10. Verificar Deploy

```bash
# Verificar status do serviço
systemctl status megasena

# Verificar logs
journalctl -u megasena -f

# Verificar se está rodando
curl http://localhost:8000
```

## Comandos Úteis

### Gerenciar Aplicação
```bash
# Reiniciar aplicação
sudo systemctl restart megasena

# Ver logs em tempo real
sudo journalctl -u megasena -f

# Ver status
sudo systemctl status megasena
```

### Gerenciar Nginx
```bash
# Reiniciar Nginx
sudo systemctl restart nginx

# Ver logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### Atualizar Aplicação
```bash
cd /var/www/megasena
git pull
source venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart megasena
```

## Troubleshooting

### Problema: Aplicação não inicia
```bash
# Verificar logs
sudo journalctl -u megasena -f

# Verificar permissões
ls -la /var/www/megasena/

# Verificar se o ambiente virtual está correto
source /var/www/megasena/venv/bin/activate
python -c "import flask; print('Flask OK')"
```

### Problema: Nginx não carrega
```bash
# Testar configuração
sudo nginx -t

# Verificar se a porta 8000 está sendo usada
sudo netstat -tlnp | grep :8000
```

### Problema: SSL não funciona
```bash
# Verificar certificados
sudo certbot certificates

# Renovar certificados
sudo certbot renew
```

## Estrutura de Arquivos

```
/var/www/megasena/
├── app.py                 # Aplicação Flask
├── wsgi.py               # Arquivo WSGI
├── gunicorn.conf.py      # Configuração Gunicorn
├── requirements.txt       # Dependências Python
├── start.sh              # Script de inicialização
├── static/               # Arquivos estáticos
├── templates/            # Templates HTML
├── venv/                 # Ambiente virtual
└── nginx.conf           # Configuração Nginx
```

## Monitoramento

### Logs Importantes
- **Aplicação**: `/var/log/syslog` (via journalctl)
- **Nginx**: `/var/log/nginx/access.log` e `/var/log/nginx/error.log`
- **Sistema**: `/var/log/syslog`

### Comandos de Monitoramento
```bash
# Ver uso de recursos
htop

# Ver espaço em disco
df -h

# Ver memória
free -h

# Ver processos Python
ps aux | grep python
```

## Backup

### Backup Automático (Cron)
```bash
# Criar script de backup
nano /root/backup.sh
```

```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup"
APP_DIR="/var/www/megasena"

mkdir -p $BACKUP_DIR
tar -czf $BACKUP_DIR/megasena_$DATE.tar.gz $APP_DIR
find $BACKUP_DIR -name "megasena_*.tar.gz" -mtime +7 -delete
```

```bash
# Adicionar ao cron
chmod +x /root/backup.sh
crontab -e
# Adicionar: 0 2 * * * /root/backup.sh
```

## Segurança

### Atualizações Regulares
```bash
# Atualizar sistema semanalmente
crontab -e
# Adicionar: 0 3 * * 0 apt update && apt upgrade -y
```

### Monitoramento de Segurança
```bash
# Instalar fail2ban
apt install -y fail2ban

# Configurar fail2ban para SSH
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
systemctl enable fail2ban
systemctl start fail2ban
```

## Suporte

Se encontrar problemas:
1. Verifique os logs primeiro
2. Teste a aplicação localmente
3. Verifique configurações de firewall
4. Confirme se todas as dependências estão instaladas

Para suporte adicional, consulte a documentação do Flask, Nginx e Gunicorn. 