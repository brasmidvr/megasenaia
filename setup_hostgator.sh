#!/bin/bash

# Script de setup para Hostgator
echo "=== Setup Hostgator ==="
echo ""

# Detectar tipo de hospedagem
if [ -d "/home" ] && [ -d "/public_html" ]; then
    echo "Detectado: Hospedagem Compartilhada"
    HOSTING_TYPE="shared"
elif [ -d "/var/www" ]; then
    echo "Detectado: VPS"
    HOSTING_TYPE="vps"
else
    echo "Tipo de hospedagem não detectado"
    exit 1
fi

# Função para hospedagem compartilhada
setup_shared_hosting() {
    echo "Configurando hospedagem compartilhada..."
    
    # Criar diretório da aplicação
    mkdir -p public_html/megasena
    
    # Configurar Python
    echo "Configurando Python..."
    python3 -m venv public_html/megasena/venv
    source public_html/megasena/venv/bin/activate
    pip install --upgrade pip
    pip install -r requirements.txt
    
    # Configurar permissões
    chmod 755 public_html/megasena
    chmod 644 public_html/megasena/*.py
    chmod 644 public_html/megasena/templates/*
    chmod 644 public_html/megasena/static/*
    
    # Criar .htaccess
    cat > public_html/.htaccess << 'EOF'
RewriteEngine On

# Redirecionar para HTTPS
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Servir arquivos estáticos
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^static/(.*)$ /megasena/static/$1 [L]

# Redirecionar tudo para app.py
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ /megasena/app_hostgator.py/$1 [QSA,L]

# Configurações de segurança
<Files ".htaccess">
    Order allow,deny
    Deny from all
</Files>

# Cache para arquivos estáticos
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
</IfModule>
EOF
    
    echo "✓ Hospedagem compartilhada configurada"
}

# Função para VPS
setup_vps() {
    echo "Configurando VPS..."
    
    # Atualizar sistema
    apt update && apt upgrade -y
    
    # Instalar dependências
    apt install -y python3 python3-pip python3-venv nginx git ufw
    
    # Configurar firewall
    ufw allow ssh
    ufw allow 80
    ufw allow 443
    ufw --force enable
    
    # Configurar Nginx
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
    rm -f /etc/nginx/sites-enabled/default
    
    # Testar e reiniciar Nginx
    nginx -t
    systemctl restart nginx
    systemctl enable nginx
    
    # Configurar systemd
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
    
    echo "✓ VPS configurado"
}

# Executar configuração baseada no tipo
if [ "$HOSTING_TYPE" = "shared" ]; then
    setup_shared_hosting
elif [ "$HOSTING_TYPE" = "vps" ]; then
    setup_vps
fi

echo ""
echo "=== Setup Concluído! ==="
echo ""
echo "Próximos passos:"
if [ "$HOSTING_TYPE" = "shared" ]; then
    echo "1. Acesse o cPanel"
    echo "2. Vá para 'Setup Python App'"
    echo "3. Configure a aplicação Python"
    echo "4. Teste acessando: https://seu-dominio.com/megasena"
else
    echo "1. Configure o ambiente virtual:"
    echo "   cd /var/www/megasena"
    echo "   source venv/bin/activate"
    echo "   pip install -r requirements.txt"
    echo "2. Configure permissões:"
    echo "   chown -R www-data:www-data /var/www/megasena"
    echo "3. Inicie a aplicação:"
    echo "   systemctl start megasena"
    echo "4. Teste acessando: http://seu-ip-do-servidor"
fi 