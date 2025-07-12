# 🚀 Deploy Mega Sena App - Hostgator

## 📋 Tipos de Hospedagem Hostgator

### 1. Hospedagem Compartilhada (Recomendado para iniciantes)
- **Hatchling**: 1 domínio, 1GB RAM
- **Baby**: Domínios ilimitados, 2GB RAM
- **Business**: Domínios ilimitados, 4GB RAM

### 2. VPS (Para mais controle)
- **VPS 2**: 2GB RAM, 2 vCPU
- **VPS 4**: 4GB RAM, 4 vCPU
- **VPS 8**: 8GB RAM, 8 vCPU

### 3. Servidor Dedicado
- Para alto tráfego e controle total

## 🎯 Deploy na Hostgator - Passo a Passo

### Opção A: Hospedagem Compartilhada

#### 1. Acessar cPanel
1. Faça login no painel da Hostgator
2. Acesse o cPanel
3. Vá para "File Manager"

#### 2. Upload dos Arquivos
```bash
# Via cPanel File Manager
1. Navegue até public_html
2. Faça upload de todos os arquivos
3. Extraia se necessário
```

#### 3. Configurar Python
```bash
# No cPanel, vá para "Setup Python App"
1. Clique em "Create Application"
2. Escolha Python 3.8 ou superior
3. Configure o diretório: public_html/megasena
4. Configure o arquivo de entrada: app.py
```

#### 4. Configurar Requirements
```bash
# Via SSH ou Terminal do cPanel
cd public_html/megasena
pip install -r requirements.txt
```

#### 5. Configurar .htaccess
```apache
# Criar arquivo .htaccess na raiz
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^(.*)$ /megasena/app.py/$1 [QSA,L]

# Para arquivos estáticos
RewriteRule ^static/(.*)$ /megasena/static/$1 [L]
```

### Opção B: VPS Hostgator

#### 1. Acessar VPS
```bash
# Via SSH
ssh root@SEU-IP-DA-HOSTGATOR
```

#### 2. Preparar Sistema
```bash
# Atualizar sistema
apt update && apt upgrade -y

# Instalar dependências
apt install -y python3 python3-pip python3-venv nginx git ufw
```

#### 3. Upload dos Arquivos
```bash
# Via SCP
scp -r ./* root@SEU-IP-DA-HOSTGATOR:/var/www/megasena/

# Ou via Git
cd /var/www
git clone https://github.com/seu-usuario/megasena.git
cd megasena
```

#### 4. Setup Automático
```bash
# Usar o script adaptado para Hostgator
chmod +x setup_hostgator.sh
./setup_hostgator.sh
```

## 🔧 Configurações Específicas da Hostgator

### Hospedagem Compartilhada

#### 1. Configurar Python App
```bash
# No cPanel > Setup Python App
Application Name: megasena
Python Version: 3.8+
Application Root: public_html/megasena
Application URL: https://seu-dominio.com/megasena
Application Entry Point: app.py
```

#### 2. Configurar Domínio
```bash
# No cPanel > Domains
1. Adicione seu domínio
2. Configure DNS se necessário
3. Aponte para public_html
```

#### 3. Configurar SSL
```bash
# No cPanel > SSL/TLS
1. Instalar certificado SSL
2. Forçar HTTPS
3. Configurar redirecionamento
```

### VPS Hostgator

#### 1. Configurar Firewall
```bash
# Configurar UFW
ufw allow ssh
ufw allow 80
ufw allow 443
ufw --force enable
```

#### 2. Configurar Nginx
```bash
# Usar configuração específica da Hostgator
cp nginx_hostgator.conf /etc/nginx/sites-available/megasena
ln -sf /etc/nginx/sites-available/megasena /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx
```

## 📁 Arquivos Específicos para Hostgator

### 1. app_hostgator.py
```python
# Versão adaptada para hospedagem compartilhada
from flask import Flask, render_template
import os

app = Flask(__name__)

# Configuração para hospedagem compartilhada
app.config['PREFERRED_URL_SCHEME'] = 'https'

@app.route('/')
def home():
    return render_template('landing.html')

@app.route('/landing')
def landing():
    return render_template('landing.html')

if __name__ == '__main__':
    # Configuração para diferentes ambientes
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
```

### 2. .htaccess para Hospedagem Compartilhada
```apache
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
```

## 🛠️ Comandos Úteis para Hostgator

### Hospedagem Compartilhada
```bash
# Via Terminal do cPanel
cd public_html/megasena
python3 app_hostgator.py

# Verificar logs
tail -f error_log
tail -f access_log
```

### VPS Hostgator
```bash
# Gerenciar aplicação
systemctl status megasena
systemctl restart megasena
journalctl -u megasena -f

# Gerenciar Nginx
systemctl status nginx
systemctl restart nginx
nginx -t
```

## 🔍 Troubleshooting Hostgator

### Problema: Aplicação não carrega (Compartilhada)
```bash
# Verificar logs de erro
tail -f error_log

# Verificar configuração Python
python3 --version
pip list

# Verificar permissões
ls -la public_html/megasena/
```

### Problema: SSL não funciona
```bash
# Verificar certificado
openssl s_client -connect seu-dominio.com:443

# Verificar configuração .htaccess
# Certifique-se de que o redirecionamento HTTPS está correto
```

### Problema: Arquivos estáticos não carregam
```bash
# Verificar caminho dos arquivos
ls -la public_html/megasena/static/

# Verificar configuração .htaccess
# Certifique-se de que as regras para static estão corretas
```

## 💰 Otimizações para Hostgator

### Hospedagem Compartilhada
```bash
# Otimizar Python
pip install --upgrade pip
pip install -r requirements.txt --no-cache-dir

# Configurar cache
# Adicionar no .htaccess
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType text/css "access plus 1 month"
    ExpiresByType application/javascript "access plus 1 month"
</IfModule>
```

### VPS Hostgator
```bash
# Otimizar Nginx
nano /etc/nginx/nginx.conf
# Adicionar:
gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

# Otimizar Gunicorn
nano /var/www/megasena/gunicorn.conf.py
# Ajustar workers baseado na RAM
```

## 📞 Suporte Hostgator

### Contatos
- **Telefone**: 1-866-96-GATOR (1-866-964-2867)
- **Chat**: Disponível no painel da Hostgator
- **Email**: support@hostgator.com

### Informações Úteis
- **Painel**: https://portal.hostgator.com
- **cPanel**: https://seu-dominio.com/cpanel
- **Documentação**: https://www.hostgator.com/help

## 🎉 Deploy Concluído!

Após seguir todos os passos, sua aplicação estará disponível em:
- **Hospedagem Compartilhada**: `https://seu-dominio.com/megasena`
- **VPS**: `https://seu-dominio.com`

### Próximos Passos
1. Teste a aplicação acessando o domínio
2. Configure SSL se necessário
3. Configure backup automático
4. Monitore logs e performance
5. Configure monitoramento

---

**Dica**: A Hostgator é uma boa opção para iniciantes. Para melhor performance:
- Use hospedagem compartilhada para começar
- Migre para VPS quando o tráfego aumentar
- Configure CDN para arquivos estáticos
- Monitore uso de recursos no cPanel 