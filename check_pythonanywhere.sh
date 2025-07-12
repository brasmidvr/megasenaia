#!/bin/bash

# Script para verificar deploy no PythonAnywhere
echo "=== Verificação Deploy PythonAnywhere ==="
echo ""

# Verificar se estamos no PythonAnywhere
if [[ "$HOSTNAME" != *"pythonanywhere"* ]]; then
    echo "⚠️  Este script é otimizado para PythonAnywhere"
    echo "Execute no console do PythonAnywhere"
    exit 1
fi

echo "✅ Detectado PythonAnywhere"

# Função para verificar arquivos
check_files() {
    echo ""
    echo "1. Verificando arquivos do projeto..."
    
    if [ -f "megasena/app_pythonanywhere.py" ]; then
        echo "✅ app_pythonanywhere.py existe"
    else
        echo "❌ app_pythonanywhere.py não encontrado"
    fi
    
    if [ -f "megasena/requirements_pythonanywhere.txt" ]; then
        echo "✅ requirements_pythonanywhere.txt existe"
    else
        echo "❌ requirements_pythonanywhere.txt não encontrado"
    fi
    
    if [ -d "megasena/templates" ]; then
        echo "✅ Pasta templates existe"
    else
        echo "❌ Pasta templates não encontrada"
    fi
    
    if [ -d "megasena/static" ]; then
        echo "✅ Pasta static existe"
    else
        echo "❌ Pasta static não encontrada"
    fi
}

# Função para verificar ambiente virtual
check_venv() {
    echo ""
    echo "2. Verificando ambiente virtual..."
    
    if [ -d "megasena/venv" ]; then
        echo "✅ Ambiente virtual existe"
        
        # Verificar se Flask está instalado
        if megasena/venv/bin/python -c "import flask" 2>/dev/null; then
            echo "✅ Flask está instalado"
        else
            echo "❌ Flask não está instalado"
            echo "Execute: cd megasena && source venv/bin/activate && pip install -r requirements_pythonanywhere.txt"
        fi
    else
        echo "❌ Ambiente virtual não encontrado"
    fi
}

# Função para verificar logs
check_logs() {
    echo ""
    echo "3. Verificando logs..."
    
    if [ -d "megasena/logs" ]; then
        echo "✅ Diretório de logs existe"
        
        if [ -f "megasena/logs/megasena.log" ]; then
            echo "✅ Arquivo de log existe"
            echo "Últimas 5 linhas dos logs:"
            tail -5 megasena/logs/megasena.log
        else
            echo "❌ Arquivo de log não encontrado"
        fi
    else
        echo "❌ Diretório de logs não encontrado"
    fi
}

# Função para verificar aplicação web
check_web_app() {
    echo ""
    echo "4. Verificando aplicação web..."
    
    # Verificar se o arquivo WSGI existe
    if [ -f "/var/www/seu-usuario_pythonanywhere_com_wsgi.py" ]; then
        echo "✅ Arquivo WSGI existe"
        
        # Verificar conteúdo do WSGI
        if grep -q "app_pythonanywhere" /var/www/seu-usuario_pythonanywhere_com_wsgi.py; then
            echo "✅ WSGI configurado corretamente"
        else
            echo "⚠️  WSGI pode não estar configurado corretamente"
            echo "Verifique se aponta para app_pythonanywhere.py"
        fi
    else
        echo "❌ Arquivo WSGI não encontrado"
        echo "Configure a aplicação web no dashboard do PythonAnywhere"
    fi
}

# Função para verificar permissões
check_permissions() {
    echo ""
    echo "5. Verificando permissões..."
    
    if [ -r "megasena" ]; then
        echo "✅ Permissões de leitura OK"
    else
        echo "❌ Problemas com permissões de leitura"
    fi
    
    if [ -w "megasena/logs" ]; then
        echo "✅ Permissões de escrita nos logs OK"
    else
        echo "❌ Problemas com permissões de escrita nos logs"
    fi
}

# Função para verificar conectividade
check_connectivity() {
    echo ""
    echo "6. Verificando conectividade..."
    
    # Verificar se a aplicação responde
    if curl -s https://seu-usuario.pythonanywhere.com/health > /dev/null; then
        echo "✅ Aplicação responde via HTTPS"
    else
        echo "❌ Aplicação não responde via HTTPS"
    fi
    
    # Verificar se a aplicação responde via HTTP
    if curl -s http://seu-usuario.pythonanywhere.com/health > /dev/null; then
        echo "✅ Aplicação responde via HTTP"
    else
        echo "❌ Aplicação não responde via HTTP"
    fi
}

# Função para verificar recursos
check_resources() {
    echo ""
    echo "7. Verificando recursos do sistema..."
    
    echo "💾 Uso de disco:"
    df -h /home/seu-usuario
    
    echo ""
    echo "🧠 Uso de memória:"
    free -h
    
    echo ""
    echo "📊 Processos Python:"
    ps aux | grep python | grep -v grep
}

# Função para verificar configuração do dashboard
check_dashboard() {
    echo ""
    echo "8. Verificando configuração do dashboard..."
    echo ""
    echo "IMPORTANTE: Verifique manualmente no dashboard:"
    echo "1. Web → Sua aplicação está listada?"
    echo "2. Web → Code → WSGI file está correto?"
    echo "3. Web → Environment variables estão configuradas?"
    echo "4. Web → Reload foi feito após mudanças?"
    echo ""
}

# Executar todas as verificações
main() {
    check_files
    check_venv
    check_logs
    check_web_app
    check_permissions
    check_connectivity
    check_resources
    check_dashboard
}

# Executar verificações
main

echo ""
echo "=== Verificação Concluída! ==="
echo ""
echo "Para acessar a aplicação:"
echo "- HTTPS: https://seu-usuario.pythonanywhere.com"
echo "- HTTP: http://seu-usuario.pythonanywhere.com"
echo ""
echo "Comandos úteis:"
echo "- Ver logs: tail -f megasena/logs/megasena.log"
echo "- Backup: ./megasena/backup.sh"
echo "- Monitor: ./megasena/monitor.sh"
echo "- Reiniciar: touch /var/www/seu-usuario_pythonanywhere_com_wsgi.py"
echo ""
echo "Se encontrar problemas:"
echo "1. Verifique os logs primeiro"
echo "2. Confirme configuração no dashboard"
echo "3. Teste a aplicação localmente"
echo "4. Verifique variáveis de ambiente" 