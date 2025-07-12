#!/bin/bash

# Script de deploy para Contabo
echo "=== Deploy Mega Sena App ==="

# Atualizar sistema
echo "Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependências do sistema
echo "Instalando dependências..."
sudo apt install -y python3 python3-pip python3-venv nginx git

# Criar diretório da aplicação
echo "Configurando diretório da aplicação..."
sudo mkdir -p /var/www/megasena
sudo chown -R $USER:$USER /var/www/megasena

# Copiar arquivos da aplicação
echo "Copiando arquivos..."
cp -r * /var/www/megasena/

# Configurar ambiente virtual
echo "Configurando ambiente virtual..."
cd /var/www/megasena
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Configurar permissões
echo "Configurando permissões..."
sudo chown -R www-data:www-data /var/www/megasena
sudo chmod +x /var/www/megasena/start.sh

# Configurar Nginx
echo "Configurando Nginx..."
sudo cp nginx.conf /etc/nginx/sites-available/megasena
sudo ln -sf /etc/nginx/sites-available/megasena /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx

# Configurar systemd service
echo "Configurando serviço systemd..."
sudo cp systemd.service /etc/systemd/system/megasena.service
sudo systemctl daemon-reload
sudo systemctl enable megasena.service
sudo systemctl start megasena.service

# Configurar firewall
echo "Configurando firewall..."
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw --force enable

echo "=== Deploy concluído! ==="
echo "Aplicação rodando em: http://seu-dominio.com"
echo "Para verificar status: sudo systemctl status megasena"
echo "Para ver logs: sudo journalctl -u megasena -f" 