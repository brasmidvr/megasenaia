from flask import Flask, render_template
import os

app = Flask(__name__)

# Configuração para hospedagem compartilhada
app.config['PREFERRED_URL_SCHEME'] = 'https'

@app.route('/')
def home():
    """Página inicial"""
    return render_template('landing.html')

@app.route('/landing')
def landing():
    """Landing page de vendas do sistema Mega Sena"""
    return render_template('landing.html')

# Rotas adicionais para hospedagem compartilhada
@app.route('/megasena/')
def megasena_home():
    """Página inicial com prefixo /megasena/"""
    return render_template('landing.html')

@app.route('/megasena/landing')
def megasena_landing():
    """Landing page com prefixo /megasena/"""
    return render_template('landing.html')

if __name__ == '__main__':
    # Configuração para diferentes ambientes
    port = int(os.environ.get('PORT', 5000))
    debug = os.environ.get('FLASK_DEBUG', 'False').lower() == 'true'
    
    app.run(
        host='0.0.0.0', 
        port=port,
        debug=debug
    ) 