from flask import Flask, render_template, jsonify, request, redirect, url_for
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app)  # Permitir requisições do Wix

# Configuração para produção
app.config['PREFERRED_URL_SCHEME'] = 'https'

@app.route('/')
def home():
    """Página inicial - pode ser usada como fallback"""
    return render_template('landing.html')

@app.route('/landing')
def landing():
    """Landing page de vendas do sistema Mega Sena"""
    return render_template('landing.html')

@app.route('/sistema')
def sistema():
    """Página do sistema - acessada via iframe ou link direto"""
    return render_template('sistema.html')

@app.route('/comprar')
def comprar():
    """Página de checkout - link direto do Wix"""
    return render_template('checkout.html')

@app.route('/login')
def login():
    """Página de login do sistema"""
    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    """Dashboard do sistema"""
    return render_template('dashboard.html')

# APIs para integração com Wix
@app.route('/api/status')
def api_status():
    """API para verificar status do sistema"""
    return jsonify({
        'status': 'online',
        'version': '1.0.0',
        'system': 'megasena_ia'
    })

@app.route('/api/contact', methods=['POST'])
def api_contact():
    """API para receber formulário de contato do Wix"""
    try:
        data = request.get_json() or request.form
        nome = data.get('nome', '')
        email = data.get('email', '')
        mensagem = data.get('mensagem', '')
        
        # Aqui você pode processar o contato
        # Por exemplo, enviar email, salvar no banco, etc.
        
        return jsonify({
            'status': 'success',
            'message': 'Mensagem recebida com sucesso!'
        })
    except Exception as e:
        return jsonify({
            'status': 'error',
            'message': 'Erro ao processar mensagem'
        }), 500

@app.route('/api/purchase', methods=['POST'])
def api_purchase():
    """API para processar compra do Wix"""
    try:
        data = request.get_json() or request.form
        email = data.get('email', '')
        nome = data.get('nome', '')
        
        # Aqui você pode processar o pagamento
        # Integrar com gateway de pagamento
        
        return jsonify({
            'status': 'success',
            'message': 'Compra processada com sucesso!',
            'redirect_url': '/dashboard'
        })
    except Exception as e:
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

# Rotas para iframe
@app.route('/iframe/sistema')
def iframe_sistema():
    """Versão do sistema para iframe"""
    return render_template('iframe_sistema.html')

@app.route('/iframe/checkout')
def iframe_checkout():
    """Versão do checkout para iframe"""
    return render_template('iframe_checkout.html')

# Health check
@app.route('/health')
def health():
    """Health check para monitoramento"""
    return jsonify({
        'status': 'healthy',
        'timestamp': '2024-01-15T10:00:00Z'
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

if __name__ == '__main__':
    # Configuração para diferentes ambientes
    port = int(os.environ.get('PORT', 5000))
    debug = os.environ.get('FLASK_DEBUG', 'False').lower() == 'true'
    
    app.run(
        host='0.0.0.0', 
        port=port,
        debug=debug
    ) 