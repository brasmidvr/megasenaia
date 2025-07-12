from flask import Flask, render_template, jsonify, request, g
import os
import logging
import time
from logging.handlers import RotatingFileHandler

app = Flask(__name__)

# Configuração para produção
app.config['PREFERRED_URL_SCHEME'] = 'https'
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY') or 'dev-key-change-in-production'

# Configurar logs
if not app.debug:
    if not os.path.exists('logs'):
        os.mkdir('logs')
    file_handler = RotatingFileHandler('logs/megasena.log', maxBytes=10240, backupCount=10)
    file_handler.setFormatter(logging.Formatter(
        '%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]'
    ))
    file_handler.setLevel(logging.INFO)
    app.logger.addHandler(file_handler)
    app.logger.setLevel(logging.INFO)
    app.logger.info('Mega Sena startup')

# Monitoramento de performance
@app.before_request
def before_request():
    g.start = time.time()

@app.after_request
def after_request(response):
    diff = time.time() - g.start
    app.logger.info(f'Request to {request.endpoint} took {diff:.2f} seconds')
    
    # Headers de segurança
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'SAMEORIGIN'
    response.headers['X-XSS-Protection'] = '1; mode=block'
    
    return response

@app.route('/')
def home():
    """Página inicial"""
    app.logger.info('Home page accessed')
    return render_template('landing.html')

@app.route('/landing')
def landing():
    """Landing page de vendas do sistema Mega Sena"""
    app.logger.info('Landing page accessed')
    return render_template('landing.html')

@app.route('/sistema')
def sistema():
    """Página do sistema"""
    app.logger.info('Sistema page accessed')
    return render_template('sistema.html')

@app.route('/comprar')
def comprar():
    """Página de checkout"""
    app.logger.info('Checkout page accessed')
    return render_template('checkout.html')

@app.route('/login')
def login():
    """Página de login"""
    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    """Dashboard do sistema"""
    return render_template('dashboard.html')

# APIs
@app.route('/api/status')
def api_status():
    """API para verificar status do sistema"""
    return jsonify({
        'status': 'online',
        'version': '1.0.0',
        'system': 'megasena_ia',
        'environment': 'pythonanywhere'
    })

@app.route('/api/contact', methods=['POST'])
def api_contact():
    """API para receber formulário de contato"""
    try:
        data = request.get_json() or request.form
        nome = data.get('nome', '')
        email = data.get('email', '')
        mensagem = data.get('mensagem', '')
        
        app.logger.info(f'Contact form submitted by {email}')
        
        # Aqui você pode processar o contato
        # Por exemplo, enviar email, salvar no banco, etc.
        
        return jsonify({
            'status': 'success',
            'message': 'Mensagem recebida com sucesso!'
        })
    except Exception as e:
        app.logger.error(f'Error processing contact form: {e}')
        return jsonify({
            'status': 'error',
            'message': 'Erro ao processar mensagem'
        }), 500

@app.route('/api/purchase', methods=['POST'])
def api_purchase():
    """API para processar compra"""
    try:
        data = request.get_json() or request.form
        email = data.get('email', '')
        nome = data.get('nome', '')
        
        app.logger.info(f'Purchase initiated by {email}')
        
        # Aqui você pode processar o pagamento
        # Integrar com gateway de pagamento
        
        return jsonify({
            'status': 'success',
            'message': 'Compra processada com sucesso!',
            'redirect_url': '/dashboard'
        })
    except Exception as e:
        app.logger.error(f'Error processing purchase: {e}')
        return jsonify({
            'status': 'error',
            'message': 'Erro ao processar compra'
        }), 500

@app.route('/api/system-data')
def api_system_data():
    """API para dados do sistema"""
    return jsonify({
        'users_count': 1250,
        'success_rate': 85,
        'last_update': '2024-01-15',
        'features': [
            'Análise Inteligente',
            'Resultados Rápidos',
            'Fácil de Usar',
            'Suporte 24/7'
        ]
    })

# Health check
@app.route('/health')
def health():
    """Health check para monitoramento"""
    return jsonify({
        'status': 'healthy',
        'timestamp': '2024-01-15T10:00:00Z',
        'environment': 'pythonanywhere'
    })

# Sitemap para SEO
@app.route('/sitemap.xml')
def sitemap():
    """Sitemap XML para SEO"""
    return render_template('sitemap.xml'), 200, {'Content-Type': 'application/xml'}

# Robots.txt
@app.route('/robots.txt')
def robots():
    """Robots.txt para SEO"""
    return render_template('robots.txt'), 200, {'Content-Type': 'text/plain'}

# Error handlers
@app.errorhandler(404)
def not_found_error(error):
    app.logger.error(f'Page not found: {request.url}')
    return render_template('404.html'), 404

@app.errorhandler(500)
def internal_error(error):
    app.logger.error(f'Server Error: {error}')
    return render_template('500.html'), 500

if __name__ == '__main__':
    # Configuração para diferentes ambientes
    port = int(os.environ.get('PORT', 5000))
    debug = os.environ.get('FLASK_DEBUG', 'False').lower() == 'true'
    
    app.run(
        host='0.0.0.0', 
        port=port,
        debug=debug
    ) 