from flask import Flask, render_template

app = Flask(__name__)

@app.route('/landing')
def landing():
    """Landing page de vendas do sistema Mega Sena"""
    return render_template('landing.html')

if __name__ == '__main__':
    app.run(debug=True) 
    # Forçando novo deploy no Render