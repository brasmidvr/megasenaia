#!/bin/bash

# Script de setup automatizado para Contabo
# Execute este script como root no servidor Contabo

set -e  # Parar em caso de erro

echo "=== Setup Automatizado para Contabo ==="
echo "Este script irá configurar seu servidor para rodar a aplicação Mega Sena"
echo ""

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then
    echo "Erro: Execute este script como root"
    echo "Use: sudo bash setup_contabo.sh"
    exit 1
fi

# Função para instalar pacotes
install_packages() {
    echo "Instalando pacotes do sistema..."
    apt update
    apt install -y python3 python3-pip python3-venv nginx git ufw curl wget unzip
    echo "✓ Pacotes instalados"
}

# Função para configurar firewall
setup_firewall() {
    echo "Configurando firewall..."
    ufw --force reset
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw allow 80
    ufw allow 443
    ufw --force enable
    echo "✓ Firewall configurado"
}

# Função para configurar Nginx
setup_nginx() {
    echo "Configurando Nginx..."
    
    # Remover configuração padrão
    rm -f /etc/nginx/sites-enabled/default
    
    # Criar configuração básica
    cat > /etc/nginx/sites-available/megasena << 'EOF'
server {
    listen 80;
    server_name _;
    
    location /static/ {
        alias /var/www/megasena/static/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

    # Ativar site
    ln -sf /etc/nginx/sites-available/megasena /etc/nginx/sites-enabled/
    
    # Testar e reiniciar Nginx
    nginx -t
    systemctl restart nginx
    systemctl enable nginx
    echo "✓ Nginx configurado"
}

# Função para configurar ambiente Python
setup_python_env() {
    echo "Configurando ambiente Python..."
    
    # Criar diretório da aplicação
    mkdir -p /var/www/megasena
    cd /var/www/megasena
    
    # Criar ambiente virtual
    python3 -m venv venv
    source venv/bin/activate
    
    # Atualizar pip
    pip install --upgrade pip
    
    echo "✓ Ambiente Python configurado"
}

# Função para configurar systemd service
setup_systemd() {
    echo "Configurando serviço systemd..."
    
    cat > /etc/systemd/system/megasena.service << 'EOF'
[Unit]
Description=Mega Sena Flask App
After=network.target

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=/var/www/megasena
Environment=PATH=/var/www/megasena/venv/bin
ExecStart=/var/www/megasena/venv/bin/gunicorn --config gunicorn.conf.py wsgi:app
ExecReload=/bin/kill -s HUP $MAINPID
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable megasena.service
    echo "✓ Systemd service configurado"
}

# Função para configurar SSL com Certbot
setup_ssl() {
    echo "Configurando SSL..."
    
    # Instalar Certbot
    apt install -y certbot python3-certbot-nginx
    
    echo ""
    echo "Para configurar SSL, execute manualmente:"
    echo "certbot --nginx -d seu-dominio.com"
    echo ""
    echo "Substitua 'seu-dominio.com' pelo seu domínio real"
    echo ""
}

# Função para criar usuário de deploy
create_deploy_user() {
    echo "Criando usuário de deploy..."
    
    # Criar usuário se não existir
    if ! id "deploy" &>/dev/null; then
        useradd -m -s /bin/bash deploy
        usermod -aG sudo deploy
        echo "deploy:$(openssl rand -base64 32)" | chpasswd
        echo "✓ Usuário deploy criado"
        echo "Senha do usuário deploy: $(openssl rand -base64 32)"
    else
        echo "✓ Usuário deploy já existe"
    fi
}

# Função para configurar backup automático
setup_backup() {
    echo "Configurando backup automático..."
    
    mkdir -p /backup
    
    cat > /root/backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup"
APP_DIR="/var/www/megasena"

mkdir -p $BACKUP_DIR
tar -czf $BACKUP_DIR/megasena_$DATE.tar.gz $APP_DIR
find $BACKUP_DIR -name "megasena_*.tar.gz" -mtime +7 -delete
EOF

    chmod +x /root/backup.sh
    
    # Adicionar ao cron (backup diário às 2h da manhã)
    (crontab -l 2>/dev/null; echo "0 2 * * * /root/backup.sh") | crontab -
    
    echo "✓ Backup automático configurado"
}

# Função para configurar monitoramento
setup_monitoring() {
    echo "Configurando monitoramento..."
    
    # Instalar htop para monitoramento
    apt install -y htop
    
    # Configurar logrotate para logs da aplicação
    cat > /etc/logrotate.d/megasena << 'EOF'
/var/log/megasena.log {
    daily
    missingok
    rotate 7
    compress
    notifempty
    create 644 www-data www-data
}
EOF

    echo "✓ Monitoramento configurado"
}

# Função para mostrar próximos passos
show_next_steps() {
    echo ""
    echo "=== Setup Concluído! ==="
    echo ""
    echo "Próximos passos:"
    echo "1. Faça upload dos arquivos da aplicação para /var/www/megasena/"
    echo "2. Configure o ambiente virtual:"
    echo "   cd /var/www/megasena"
    echo "   source venv/bin/activate"
    echo "   pip install -r requirements.txt"
    echo ""
    echo "3. Configure permissões:"
    echo "   chown -R www-data:www-data /var/www/megasena"
    echo ""
    echo "4. Inicie a aplicação:"
    echo "   systemctl start megasena"
    echo ""
    echo "5. Configure SSL (opcional):"
    echo "   certbot --nginx -d seu-dominio.com"
    echo ""
    echo "6. Verifique se está funcionando:"
    echo "   systemctl status megasena"
    echo "   curl http://localhost:8000"
    echo ""
    echo "Comandos úteis:"
    echo "- Ver logs: journalctl -u megasena -f"
    echo "- Reiniciar: systemctl restart megasena"
    echo "- Ver status: systemctl status megasena"
    echo ""
}

# Executar todas as funções
main() {
    install_packages
    setup_firewall
    setup_nginx
    setup_python_env
    setup_systemd
    setup_ssl
    create_deploy_user
    setup_backup
    setup_monitoring
    show_next_steps
}

# Executar script
main 