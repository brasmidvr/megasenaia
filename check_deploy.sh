#!/bin/bash

# Script para verificar se o deploy está funcionando
echo "=== Verificação do Deploy ==="
echo ""

# Verificar se o serviço está rodando
echo "1. Verificando status do serviço..."
if systemctl is-active --quiet megasena; then
    echo "✓ Serviço megasena está ativo"
else
    echo "✗ Serviço megasena não está ativo"
    echo "Execute: sudo systemctl start megasena"
fi

# Verificar se a porta 8000 está sendo usada
echo ""
echo "2. Verificando se a aplicação está rodando na porta 8000..."
if netstat -tlnp | grep :8000 > /dev/null; then
    echo "✓ Aplicação está rodando na porta 8000"
else
    echo "✗ Aplicação não está rodando na porta 8000"
fi

# Verificar se o Nginx está rodando
echo ""
echo "3. Verificando status do Nginx..."
if systemctl is-active --quiet nginx; then
    echo "✓ Nginx está ativo"
else
    echo "✗ Nginx não está ativo"
    echo "Execute: sudo systemctl start nginx"
fi

# Verificar se os arquivos da aplicação existem
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

if [ -f "/var/www/megasena/gunicorn.conf.py" ]; then
    echo "✓ gunicorn.conf.py existe"
else
    echo "✗ gunicorn.conf.py não encontrado"
fi

# Verificar ambiente virtual
echo ""
echo "5. Verificando ambiente virtual..."
if [ -d "/var/www/megasena/venv" ]; then
    echo "✓ Ambiente virtual existe"
    
    # Verificar se Flask está instalado
    if /var/www/megasena/venv/bin/python -c "import flask" 2>/dev/null; then
        echo "✓ Flask está instalado"
    else
        echo "✗ Flask não está instalado"
        echo "Execute: cd /var/www/megasena && source venv/bin/activate && pip install -r requirements.txt"
    fi
else
    echo "✗ Ambiente virtual não encontrado"
fi

# Verificar permissões
echo ""
echo "6. Verificando permissões..."
if [ "$(stat -c '%U' /var/www/megasena)" = "www-data" ]; then
    echo "✓ Permissões corretas"
else
    echo "✗ Permissões incorretas"
    echo "Execute: sudo chown -R www-data:www-data /var/www/megasena"
fi

# Testar conexão HTTP
echo ""
echo "7. Testando conexão HTTP..."
if curl -s http://localhost:8000 > /dev/null; then
    echo "✓ Aplicação responde na porta 8000"
else
    echo "✗ Aplicação não responde na porta 8000"
fi

# Verificar logs recentes
echo ""
echo "8. Verificando logs recentes..."
echo "Últimas 10 linhas dos logs:"
journalctl -u megasena --no-pager -n 10

# Verificar uso de recursos
echo ""
echo "9. Verificando uso de recursos..."
echo "Uso de memória:"
free -h | grep -E "Mem|Swap"

echo ""
echo "Uso de disco:"
df -h /var/www

echo ""
echo "Processos Python:"
ps aux | grep python | grep -v grep

# Verificar configuração do Nginx
echo ""
echo "10. Verificando configuração do Nginx..."
if nginx -t > /dev/null 2>&1; then
    echo "✓ Configuração do Nginx está válida"
else
    echo "✗ Configuração do Nginx tem erros"
    echo "Execute: sudo nginx -t"
fi

echo ""
echo "=== Verificação Concluída ==="
echo ""
echo "Se todos os itens estão marcados com ✓, seu deploy está funcionando!"
echo ""
echo "Para acessar a aplicação:"
echo "- Localmente: http://localhost"
echo "- Externamente: http://seu-ip-do-servidor"
echo ""
echo "Comandos úteis:"
echo "- Ver logs em tempo real: sudo journalctl -u megasena -f"
echo "- Reiniciar aplicação: sudo systemctl restart megasena"
echo "- Ver status: sudo systemctl status megasena" 