#!/bin/bash

# Script para verificar deploy na Hostgator
echo "=== Verificação Deploy Hostgator ==="
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

# Função para verificar hospedagem compartilhada
check_shared_hosting() {
    echo ""
    echo "1. Verificando arquivos da aplicação..."
    
    if [ -f "public_html/megasena/app_hostgator.py" ]; then
        echo "✓ app_hostgator.py existe"
    else
        echo "✗ app_hostgator.py não encontrado"
    fi
    
    if [ -f "public_html/megasena/requirements.txt" ]; then
        echo "✓ requirements.txt existe"
    else
        echo "✗ requirements.txt não encontrado"
    fi
    
    if [ -d "public_html/megasena/templates" ]; then
        echo "✓ Pasta templates existe"
    else
        echo "✗ Pasta templates não encontrada"
    fi
    
    if [ -d "public_html/megasena/static" ]; then
        echo "✓ Pasta static existe"
    else
        echo "✗ Pasta static não encontrada"
    fi
    
    echo ""
    echo "2. Verificando ambiente Python..."
    
    if [ -d "public_html/megasena/venv" ]; then
        echo "✓ Ambiente virtual existe"
        
        # Verificar se Flask está instalado
        if public_html/megasena/venv/bin/python -c "import flask" 2>/dev/null; then
            echo "✓ Flask está instalado"
        else
            echo "✗ Flask não está instalado"
            echo "Execute: cd public_html/megasena && source venv/bin/activate && pip install -r requirements.txt"
        fi
    else
        echo "✗ Ambiente virtual não encontrado"
    fi
    
    echo ""
    echo "3. Verificando arquivo .htaccess..."
    
    if [ -f "public_html/.htaccess" ]; then
        echo "✓ .htaccess existe"
        
        # Verificar se tem as regras corretas
        if grep -q "RewriteEngine On" public_html/.htaccess; then
            echo "✓ Regras de rewrite configuradas"
        else
            echo "✗ Regras de rewrite não encontradas"
        fi
    else
        echo "✗ .htaccess não encontrado"
    fi
    
    echo ""
    echo "4. Verificando permissões..."
    
    if [ -r "public_html/megasena" ]; then
        echo "✓ Permissões de leitura OK"
    else
        echo "✗ Problemas com permissões de leitura"
    fi
    
    echo ""
    echo "5. Verificando configuração Python no cPanel..."
    echo "IMPORTANTE: Verifique manualmente no cPanel:"
    echo "1. Acesse o cPanel"
    echo "2. Vá para 'Setup Python App'"
    echo "3. Verifique se a aplicação está configurada"
    echo "4. Verifique se o domínio está apontando corretamente"
}

# Função para verificar VPS
check_vps() {
    echo ""
    echo "1. Verificando status do serviço..."
    if systemctl is-active --quiet megasena; then
        echo "✓ Serviço megasena está ativo"
    else
        echo "✗ Serviço megasena não está ativo"
        echo "Execute: sudo systemctl start megasena"
    fi
    
    echo ""
    echo "2. Verificando se a aplicação está rodando na porta 8000..."
    if netstat -tlnp | grep :8000 > /dev/null; then
        echo "✓ Aplicação está rodando na porta 8000"
    else
        echo "✗ Aplicação não está rodando na porta 8000"
    fi
    
    echo ""
    echo "3. Verificando status do Nginx..."
    if systemctl is-active --quiet nginx; then
        echo "✓ Nginx está ativo"
    else
        echo "✗ Nginx não está ativo"
        echo "Execute: sudo systemctl start nginx"
    fi
    
    echo ""
    echo "4. Verificando arquivos da aplicação..."
    if [ -f "/var/www/megasena/app.py" ]; then
        echo "✓ app.py existe"
    else
        echo "✗ app.py não encontrado"
    fi
    
    if [ -f "/var/www/megasena/wsgi.py" ]; then
        echo "✓ wsgi.py existe"
    else
        echo "✗ wsgi.py não encontrado"
    fi
    
    echo ""
    echo "5. Verificando ambiente virtual..."
    if [ -d "/var/www/megasena/venv" ]; then
        echo "✓ Ambiente virtual existe"
        
        if /var/www/megasena/venv/bin/python -c "import flask" 2>/dev/null; then
            echo "✓ Flask está instalado"
        else
            echo "✗ Flask não está instalado"
        fi
    else
        echo "✗ Ambiente virtual não encontrado"
    fi
    
    echo ""
    echo "6. Verificando permissões..."
    if [ "$(stat -c '%U' /var/www/megasena)" = "www-data" ]; then
        echo "✓ Permissões corretas"
    else
        echo "✗ Permissões incorretas"
        echo "Execute: sudo chown -R www-data:www-data /var/www/megasena"
    fi
    
    echo ""
    echo "7. Testando conexão HTTP..."
    if curl -s http://localhost:8000 > /dev/null; then
        echo "✓ Aplicação responde na porta 8000"
    else
        echo "✗ Aplicação não responde na porta 8000"
    fi
    
    echo ""
    echo "8. Verificando logs recentes..."
    echo "Últimas 10 linhas dos logs:"
    journalctl -u megasena --no-pager -n 10
    
    echo ""
    echo "9. Verificando configuração do Nginx..."
    if nginx -t > /dev/null 2>&1; then
        echo "✓ Configuração do Nginx está válida"
    else
        echo "✗ Configuração do Nginx tem erros"
        echo "Execute: sudo nginx -t"
    fi
}

# Executar verificação baseada no tipo
if [ "$HOSTING_TYPE" = "shared" ]; then
    check_shared_hosting
elif [ "$HOSTING_TYPE" = "vps" ]; then
    check_vps
fi

echo ""
echo "=== Verificação Concluída! ==="
echo ""
echo "Para acessar a aplicação:"
if [ "$HOSTING_TYPE" = "shared" ]; then
    echo "- Hospedagem Compartilhada: https://seu-dominio.com/megasena"
    echo ""
    echo "Comandos úteis:"
    echo "- Ver logs de erro: tail -f error_log"
    echo "- Ver logs de acesso: tail -f access_log"
    echo "- Testar Python: cd public_html/megasena && python3 app_hostgator.py"
else
    echo "- VPS: http://seu-ip-do-servidor"
    echo ""
    echo "Comandos úteis:"
    echo "- Ver logs: sudo journalctl -u megasena -f"
    echo "- Reiniciar: sudo systemctl restart megasena"
    echo "- Ver status: sudo systemctl status megasena"
fi 