#!/bin/bash

# Script de inicialização para o servidor Contabo
echo "Iniciando aplicação Flask..."

# Ativar ambiente virtual (se existir)
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Instalar dependências se necessário
pip install -r requirements.txt

# Iniciar aplicação com Gunicorn
gunicorn --config gunicorn.conf.py wsgi:app 