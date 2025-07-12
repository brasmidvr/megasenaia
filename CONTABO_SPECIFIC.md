# 🚀 Deploy Específico para Contabo

## 📋 Informações do Contabo

### Tipos de Servidor Recomendados
- **VPS S**: 4GB RAM, 2 vCPU (mínimo recomendado)
- **VPS M**: 8GB RAM, 4 vCPU (recomendado)
- **VPS L**: 16GB RAM, 6 vCPU (para alto tráfego)

### Localização dos Servidores
- **Europa**: Frankfurt, Nuremberg
- **América do Norte**: Seattle, Washington
- **Ásia**: Singapore

## 🎯 Deploy no Contabo - Passo a Passo

### 1. Criar VPS no Contabo

1. Acesse [contabo.com](https://contabo.com)
2. Escolha um VPS (recomendado: VPS M)
3. Selecione Ubuntu 20.04 ou superior
4. Escolha localização próxima aos seus usuários
5. Configure SSH key (recomendado) ou senha
6. Finalize a compra

### 2. Acessar o Servidor

```bash
# Via SSH com chave
ssh root@SEU-IP-DO-CONTABO

# Via SSH com senha
ssh root@SEU-IP-DO-CONTABO
# Digite a senha fornecida pelo Contabo
```

### 3. Configurar Domínio (Opcional)

Se você tem um domínio:
1. Acesse seu provedor de domínio
2. Configure DNS A record apontando para o IP do Contabo
3. Aguarde propagação (pode levar até 24h)

### 4. Upload dos Arquivos

**Opção A: Via SCP (Recomendado)**
```bash
# No seu computador local
scp -r ./* root@SEU-IP-DO-CONTABO:/var/www/megasena/
```

**Opção B: Via Git**
```bash
# No servidor Contabo
cd /var/www
git clone https://github.com/seu-usuario/megasena.git
cd megasena
```

### 5. Setup Automático

```bash
# No servidor Contabo
cd /var/www/megasena
chmod +x setup_contabo.sh
./setup_contabo.sh
```

### 6. Configurar Aplicação

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

### 7. Configurar SSL (Recomendado)

```bash
# Instalar Certbot
apt install -y certbot python3-certbot-nginx

# Obter certificado SSL
certbot --nginx -d seu-dominio.com

# Se não tiver domínio, pule esta etapa
```

### 8. Verificar Deploy

```bash
# Executar verificação
./check_deploy.sh

# Verificar manualmente
systemctl status megasena
curl http://localhost:8000
```

## 🔧 Configurações Específicas do Contabo

### Firewall do Contabo
O Contabo tem firewall próprio. Configure no painel:
- Porta 22 (SSH)
- Porta 80 (HTTP)
- Porta 443 (HTTPS)

### Otimizações para Contabo

#### 1. Configurar Swap (se necessário)
```bash
# Verificar se tem swap
free -h

# Se não tiver, criar swap
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
```

#### 2. Otimizar Nginx
```bash
# Editar configuração do Nginx
nano /etc/nginx/nginx.conf

# Adicionar no bloco http:
client_max_body_size 10M;
gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
```

#### 3. Otimizar Gunicorn
```bash
# Editar configuração do Gunicorn
nano /var/www/megasena/gunicorn.conf.py

# Ajustar workers baseado na RAM
# Para 4GB RAM: workers = 2
# Para 8GB RAM: workers = 4
# Para 16GB RAM: workers = 8
```

## 📊 Monitoramento no Contabo

### Verificar Recursos
```bash
# Uso de CPU
top

# Uso de memória
free -h

# Uso de disco
df -h

# Processos
ps aux | grep python
```

### Logs Importantes
```bash
# Logs da aplicação
journalctl -u megasena -f

# Logs do Nginx
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log

# Logs do sistema
tail -f /var/log/syslog
```

## 🔒 Segurança no Contabo

### 1. Configurar Fail2ban
```bash
apt install -y fail2ban
systemctl enable fail2ban
systemctl start fail2ban
```

### 2. Alterar Porta SSH (Opcional)
```bash
# Editar configuração SSH
nano /etc/ssh/sshd_config

# Alterar porta (exemplo: 2222)
# Port 2222

# Reiniciar SSH
systemctl restart ssh
```

### 3. Desabilitar Login Root (Recomendado)
```bash
# Criar usuário
adduser seu-usuario
usermod -aG sudo seu-usuario

# Configurar SSH
nano /etc/ssh/sshd_config
# PermitRootLogin no
# PasswordAuthentication no

# Reiniciar SSH
systemctl restart ssh
```

## 💰 Otimização de Custos

### 1. Backup Local
```bash
# Criar backup local
mkdir -p /backup
tar -czf /backup/megasena_$(date +%Y%m%d).tar.gz /var/www/megasena
```

### 2. Limpeza Automática
```bash
# Adicionar ao cron
crontab -e

# Limpar logs antigos
0 3 * * * find /var/log -name "*.log" -mtime +7 -delete

# Limpar backups antigos
0 4 * * * find /backup -name "*.tar.gz" -mtime +30 -delete
```

## 🚨 Troubleshooting Específico do Contabo

### Problema: Servidor não responde
```bash
# Verificar se está online
ping google.com

# Verificar serviços
systemctl status nginx
systemctl status megasena

# Verificar portas
netstat -tlnp
```

### Problema: Baixo desempenho
```bash
# Verificar recursos
htop
free -h
df -h

# Otimizar se necessário
# Reduzir workers do Gunicorn
# Aumentar swap
# Limpar logs antigos
```

### Problema: SSL não funciona
```bash
# Verificar certificados
certbot certificates

# Renovar certificados
certbot renew

# Verificar configuração Nginx
nginx -t
```

## 📞 Suporte Contabo

### Contatos
- **Email**: support@contabo.com
- **Telefone**: +49 89 212 68 52 0
- **Chat**: Disponível no painel do Contabo

### Informações Úteis
- **Painel**: https://my.contabo.com
- **Documentação**: https://docs.contabo.com
- **Status**: https://status.contabo.com

## 🎉 Deploy Concluído!

Após seguir todos os passos, sua aplicação estará disponível em:
- **HTTP**: `http://SEU-IP-DO-CONTABO`
- **HTTPS**: `https://seu-dominio.com` (se configurado SSL)

### Próximos Passos
1. Teste a aplicação acessando o IP
2. Configure SSL se tiver domínio
3. Configure monitoramento
4. Faça backup regular
5. Monitore logs e recursos

---

**Dica**: O Contabo oferece boa relação custo-benefício para aplicações Flask. Para melhor performance, considere:
- Usar SSD storage
- Configurar CDN para arquivos estáticos
- Implementar cache Redis (se necessário)
- Monitorar uso de recursos regularmente 