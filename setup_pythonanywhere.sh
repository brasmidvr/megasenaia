#!/bin/bash

# Script de setup para PythonAnywhere
echo "=== Setup PythonAnywhere ==="
echo ""

# Verificar se estamos no PythonAnywhere
if [[ "$HOSTNAME" != *"pythonanywhere"* ]]; then
    echo "⚠️  Este script é otimizado para PythonAnywhere"
    echo "Execute no console do PythonAnywhere"
    exit 1
fi

echo "✅ Detectado PythonAnywhere"

# Função para configurar ambiente
setup_environment() {
    echo "Configurando ambiente..."
    
    # Criar diretório do projeto se não existir
    mkdir -p megasena
    cd megasena
    
    # Criar ambiente virtual
    python3 -m venv venv
    source venv/bin/activate
    
    # Atualizar pip
    pip install --upgrade pip
    
    echo "✓ Ambiente configurado"
}

# Função para instalar dependências
install_dependencies() {
    echo "Instalando dependências..."
    
    # Verificar se requirements existe
    if [ -f "requirements_pythonanywhere.txt" ]; then
        pip install -r requirements_pythonanywhere.txt
    elif [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
    else
        echo "⚠️  Arquivo requirements não encontrado"
        echo "Instalando Flask manualmente..."
        pip install Flask==3.1.1
    fi
    
    echo "✓ Dependências instaladas"
}

# Função para configurar logs
setup_logs() {
    echo "Configurando logs..."
    
    # Criar diretório de logs
    mkdir -p logs
    
    # Criar arquivo de log inicial
    touch logs/megasena.log
    
    echo "✓ Logs configurados"
}

# Função para configurar backup
setup_backup() {
    echo "Configurando backup..."
    
    # Criar script de backup
    cat > backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/home/seu-usuario/backups"
PROJECT_DIR="/home/seu-usuario/megasena"

mkdir -p $BACKUP_DIR
tar -czf $BACKUP_DIR/megasena_$DATE.tar.gz $PROJECT_DIR

# Manter apenas os últimos 7 backups
find $BACKUP_DIR -name "megasena_*.tar.gz" -mtime +7 -delete

echo "Backup criado: megasena_$DATE.tar.gz"
EOF

    chmod +x backup.sh
    
    echo "✓ Backup configurado"
}

# Função para configurar monitoramento
setup_monitoring() {
    echo "Configurando monitoramento..."
    
    # Criar script de monitoramento
    cat > monitor.sh << 'EOF'
#!/bin/bash
echo "=== Monitoramento Mega Sena ==="
echo ""

echo "📊 Status da aplicação:"
if curl -s https://seu-usuario.pythonanywhere.com/health > /dev/null; then
    echo "✅ Aplicação online"
else
    echo "❌ Aplicação offline"
fi

echo ""
echo "📈 Logs recentes:"
tail -5 logs/megasena.log

echo ""
echo "💾 Uso de disco:"
df -h /home/seu-usuario

echo ""
echo "🧠 Uso de memória:"
free -h
EOF

    chmod +x monitor.sh
    
    echo "✓ Monitoramento configurado"
}

# Função para mostrar próximos passos
show_next_steps() {
    echo ""
    echo "=== Setup Concluído! ==="
    echo ""
    echo "Próximos passos:"
    echo ""
    echo "1. No Dashboard do PythonAnywhere:"
    echo "   - Vá para 'Web'"
    echo "   - Clique em 'Add a new web app'"
    echo "   - Escolha 'Manual configuration'"
    echo "   - Selecione Python 3.9+"
    echo ""
    echo "2. Configure o WSGI:"
    echo "   - Edite o arquivo WSGI"
    echo "   - Substitua o conteúdo por:"
    echo "   import sys"
    echo "   path = '/home/seu-usuario/megasena'"
    echo "   if path not in sys.path:"
    echo "       sys.path.append(path)"
    echo "   from app_pythonanywhere import app as application"
    echo ""
    echo "3. Configure variáveis de ambiente:"
    echo "   - Web → Environment variables"
    echo "   - Adicione: FLASK_ENV=production"
    echo ""
    echo "4. Reinicie a aplicação:"
    echo "   - Clique em 'Reload' no dashboard"
    echo ""
    echo "5. Teste a aplicação:"
    echo "   - Acesse: https://seu-usuario.pythonanywhere.com"
    echo ""
    echo "Comandos úteis:"
    echo "- Ver logs: tail -f logs/megasena.log"
    echo "- Backup: ./backup.sh"
    echo "- Monitor: ./monitor.sh"
    echo "- Reiniciar: touch /var/www/seu-usuario_pythonanywhere_com_wsgi.py"
    echo ""
}

# Executar todas as funções
main() {
    setup_environment
    install_dependencies
    setup_logs
    setup_backup
    setup_monitoring
    show_next_steps
}

# Executar script
main 