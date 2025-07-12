# 🚀 Deploy Mega Sena App - Contabo

## 📋 Pré-requisitos

- ✅ Servidor VPS Contabo (Ubuntu 20.04+)
- ✅ Domínio apontando para o IP do servidor
- ✅ Acesso SSH ao servidor

## 🎯 Deploy Rápido (Automático)

### 1. Upload dos Arquivos
```bash
# No seu computador local
scp -r ./* root@SEU-IP-DO-SERVIDOR:/var/www/megasena/
```

### 2. Setup Automático no Servidor
```bash
# Conectar ao servidor
ssh root@SEU-IP-DO-SERVIDOR

# Executar setup automático
cd /var/www/megasena
chmod +x setup_contabo.sh
./setup_contabo.sh
```

### 3. Configurar Aplicação
```bash
# Configurar ambiente virtual
cd /var/www/megasena
source venv/bin/activate
pip install -r requirements.txt

# Configurar permissões
chown -R www-data:www-data /var/www/megasena

# Iniciar aplicação
systemctl start megasena
```

### 4. Configurar SSL (Opcional)
```bash
certbot --nginx -d seu-dominio.com
```

### 5. Verificar Deploy
```bash
./check_deploy.sh
```

## 🔧 Deploy Manual (Passo a Passo)

### 1. Preparar Servidor
```bash
# Atualizar sistema
apt update && apt upgrade -y

# Instalar dependências
apt install -y python3 python3-pip python3-venv nginx git ufw
```

### 2. Configurar Firewall
```bash
ufw allow ssh
ufw allow 80
ufw allow 443
ufw --force enable
```

### 3. Configurar Nginx
```bash
# Copiar configuração
cp nginx.conf /etc/nginx/sites-available/megasena

# Editar domínio
nano /etc/nginx/sites-available/megasena
# Substituir "seu-dominio.com" pelo seu domínio

# Ativar site
ln -sf /etc/nginx/sites-available/megasena /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Testar e reiniciar
nginx -t
systemctl restart nginx
```

### 4. Configurar Aplicação
```bash
# Criar ambiente virtual
cd /var/www/megasena
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Configurar permissões
chown -R www-data:www-data /var/www/megasena
```

### 5. Configurar Systemd
```bash
# Copiar arquivo de serviço
cp systemd.service /etc/systemd/system/megasena.service

# Ativar e iniciar
systemctl daemon-reload
systemctl enable megasena.service
systemctl start megasena.service
```

## 📁 Arquivos Criados

- `wsgi.py` - Arquivo WSGI para produção
- `gunicorn.conf.py` - Configuração do Gunicorn
- `nginx.conf` - Configuração do Nginx
- `systemd.service` - Arquivo de serviço systemd
- `setup_contabo.sh` - Script de setup automático
- `check_deploy.sh` - Script de verificação
- `deploy.sh` - Script de deploy completo
- `start.sh` - Script de inicialização

## 🛠️ Comandos Úteis

### Gerenciar Aplicação
```bash
# Ver status
systemctl status megasena

# Reiniciar
systemctl restart megasena

# Ver logs
journalctl -u megasena -f

# Parar
systemctl stop megasena
```

### Gerenciar Nginx
```bash
# Ver status
systemctl status nginx

# Reiniciar
systemctl restart nginx

# Ver logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

### Atualizar Aplicação
```bash
cd /var/www/megasena
git pull
source venv/bin/activate
pip install -r requirements.txt
systemctl restart megasena
```

## 🔍 Troubleshooting

### Problema: Aplicação não inicia
```bash
# Verificar logs
journalctl -u megasena -f

# Verificar permissões
ls -la /var/www/megasena/

# Verificar ambiente virtual
source /var/www/megasena/venv/bin/activate
python -c "import flask; print('OK')"
```

### Problema: Nginx não carrega
```bash
# Testar configuração
nginx -t

# Verificar se porta 8000 está em uso
netstat -tlnp | grep :8000
```

### Problema: SSL não funciona
```bash
# Verificar certificados
certbot certificates

# Renovar certificados
certbot renew
```

## 📊 Monitoramento

### Verificar Recursos
```bash
# Uso de CPU e memória
htop

# Espaço em disco
df -h

# Processos Python
ps aux | grep python
```

### Logs Importantes
- **Aplicação**: `journalctl -u megasena -f`
- **Nginx**: `/var/log/nginx/access.log`
- **Sistema**: `/var/log/syslog`

## 🔒 Segurança

### Configurar Fail2ban
```bash
apt install -y fail2ban
systemctl enable fail2ban
systemctl start fail2ban
```

### Backup Automático
```bash
# Backup diário às 2h da manhã
crontab -e
# Adicionar: 0 2 * * * /root/backup.sh
```

## 🎉 Sucesso!

Se tudo foi configurado corretamente, sua aplicação estará disponível em:
- **HTTP**: `http://seu-ip-do-servidor`
- **HTTPS**: `https://seu-dominio.com` (após configurar SSL)

## 📞 Suporte

Se encontrar problemas:
1. Execute `./check_deploy.sh` para diagnóstico
2. Verifique os logs com `journalctl -u megasena -f`
3. Confirme se todas as dependências estão instaladas
4. Verifique configurações de firewall

---

**Arquivos criados para facilitar o deploy:**
- ✅ `wsgi.py` - Para produção
- ✅ `gunicorn.conf.py` - Configuração do servidor
- ✅ `nginx.conf` - Configuração do proxy reverso
- ✅ `systemd.service` - Serviço do sistema
- ✅ `setup_contabo.sh` - Setup automático
- ✅ `check_deploy.sh` - Verificação de deploy
- ✅ `README_DEPLOY.md` - Guia completo
- ✅ `DEPLOY_CONTABO.md` - Este resumo 