import sys
import os

# Adicionar o diretório do projeto ao path
path = '/home/seu-usuario/megasena'
if path not in sys.path:
    sys.path.append(path)

# Configurar variáveis de ambiente
os.environ['FLASK_ENV'] = 'production'
os.environ['FLASK_DEBUG'] = 'False'

# Importar a aplicação
from app_pythonanywhere import app as application

# Configurar logging
import logging
logging.basicConfig(stream=sys.stderr) 