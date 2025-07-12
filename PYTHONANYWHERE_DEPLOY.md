# 🚀 Deploy Mega Sena App - PythonAnywhere

## 📋 Sobre o PythonAnywhere

### Tipos de Conta:
- **Free**: 1 aplicação web, domínio .pythonanywhere.com
- **Hacker**: 5 aplicações web, domínio customizado
- **Developer**: 10 aplicações web, domínio customizado, SSL

### Vantagens:
- ✅ **Especializado em Python** - Otimizado para Flask/Django
- ✅ **Fácil deploy** - Interface web amigável
- ✅ **SSL gratuito** - Certificados automáticos
- ✅ **Backup automático** - Segurança dos dados
- ✅ **Console Python** - Debugging fácil
- ✅ **Suporte Python** - Especialistas em Python

## 🎯 Deploy no PythonAnywhere - Passo a Passo

### 1. Criar Conta no PythonAnywhere

#### Passo a Passo:
1. **Acesse**: [pythonanywhere.com](https://pythonanywhere.com)
2. **Crie conta** gratuita
3. **Confirme email** de verificação
4. **Acesse dashboard**

### 2. Upload dos Arquivos

#### Opção A: Via Git (Recomendado)
```bash
# No console do PythonAnywhere
git clone https://github.com/seu-usuario/megasena.git
cd megasena
```

#### Opção B: Via Upload
1. **Dashboard** → **Files** → **Upload a file**
2. **Selecione** todos os arquivos do projeto
3. **Extraia** se necessário

### 3. Configurar Ambiente Virtual

```bash
# No console do PythonAnywhere
cd megasena
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

### 4. Configurar Aplicação Web

#### No Dashboard do PythonAnywhere:
1. **Web** → **Add a new web app**
2. **Escolha domínio**: seu-usuario.pythonanywhere.com
3. **Framework**: Manual configuration
4. **Python version**: 3.9 ou superior

#### Configurar WSGI:
```python
# /var/www/seu-usuario_pythonanywhere_com_wsgi.py
import sys
path = '/home/seu-usuario/megasena'
if path not in sys.path:
    sys.path.append(path)

from app import app as application
```

### 5. Configurar Variáveis de Ambiente

#### No Dashboard:
1. **Web** → **Environment variables**
2. **Adicionar**:
   - `FLASK_ENV=production`
   - `FLASK_DEBUG=False`

### 6. Configurar Domínio (Opcional)

#### Para conta paga:
1. **Web** → **Domains**
2. **Adicionar domínio**: seu-dominio.com
3. **Configurar DNS** no provedor de domínio

### 7. Configurar SSL

#### Automático (PythonAnywhere):
- **Free**: SSL automático para .pythonanywhere.com
- **Pago**: SSL automático para domínios customizados

### 8. Configurar Banco de Dados (Opcional)

#### MySQL (Incluído):
```bash
# No console
mysql -u seu-usuario -p
CREATE DATABASE megasena;
```

#### SQLite (Recomendado para começar):
```python
# app.py
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///megasena.db'
```

## 🔧 Configuração Detalhada

### 1. Estrutura de Arquivos

```
/home/seu-usuario/megasena/
├── app.py                 # Aplicação principal
├── requirements.txt       # Dependências
├── venv/                 # Ambiente virtual
├── static/               # Arquivos estáticos
├── templates/            # Templates HTML
├── logs/                 # Logs da aplicação
└── data/                 # Dados do sistema
```

### 2. Configurar Logs

```python
# app.py
import logging
from logging.handlers import RotatingFileHandler

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
```

### 3. Configurar Backup

#### Automático (PythonAnywhere):
- **Backup diário** automático
- **Retenção** de 30 dias
- **Restore** via dashboard

#### Manual:
```bash
# No console
tar -czf backup_$(date +%Y%m%d).tar.gz megasena/
```

### 4. Configurar Monitoramento

#### Logs:
```bash
# Ver logs em tempo real
tail -f logs/megasena.log

# Ver logs de erro
tail -f logs/megasena.log | grep ERROR
```

#### Performance:
```python
# app.py
@app.before_request
def before_request():
    g.start = time.time()

@app.after_request
def after_request(response):
    diff = time.time() - g.start
    app.logger.info(f'Request took {diff:.2f} seconds')
    return response
```

## 🛠️ Comandos Úteis

### Gerenciar Aplicação
```bash
# Reiniciar aplicação
touch /var/www/seu-usuario_pythonanywhere_com_wsgi.py

# Ver logs
tail -f logs/megasena.log

# Ver status
ps aux | grep python
```

### Gerenciar Arquivos
```bash
# Navegar para projeto
cd megasena

# Atualizar código
git pull origin main

# Instalar dependências
source venv/bin/activate
pip install -r requirements.txt
```

### Backup e Restore
```bash
# Backup manual
tar -czf backup_$(date +%Y%m%d).tar.gz megasena/

# Restore
tar -xzf backup_20240115.tar.gz
```

## 📊 Monitoramento

### Logs Importantes:
- **Aplicação**: `/home/seu-usuario/megasena/logs/megasena.log`
- **Erro**: `/var/log/seu-usuario.pythonanywhere.com.error.log`
- **Acesso**: `/var/log/seu-usuario.pythonanywhere.com.access.log`

### Dashboard PythonAnywhere:
- **CPU usage**: Monitoramento em tempo real
- **Disk usage**: Espaço em disco
- **Memory usage**: Uso de memória
- **Network**: Tráfego de rede

## 🔒 Segurança

### Configurações Recomendadas:
```python
# app.py
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY') or 'dev-key-change-in-production'

# Headers de segurança
@app.after_request
def add_security_headers(response):
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'SAMEORIGIN'
    response.headers['X-XSS-Protection'] = '1; mode=block'
    return response
```

### Variáveis de Ambiente:
```bash
# No dashboard PythonAnywhere
SECRET_KEY=sua-chave-secreta-aqui
FLASK_ENV=production
DATABASE_URL=sqlite:///megasena.db
```

## 💰 Otimização de Custos

### Conta Free:
- **Limite**: 512MB RAM, 1GB disco
- **Domínio**: .pythonanywhere.com
- **SSL**: Automático
- **Backup**: Automático

### Conta Paga:
- **Hacker**: $5/mês - 5 apps, domínio customizado
- **Developer**: $12/mês - 10 apps, domínio customizado

## 🚨 Troubleshooting

### Problema: Aplicação não carrega
```bash
# Verificar logs
tail -f logs/megasena.log

# Verificar WSGI
cat /var/www/seu-usuario_pythonanywhere_com_wsgi.py

# Reiniciar aplicação
touch /var/www/seu-usuario_pythonanywhere_com_wsgi.py
```

### Problema: Erro 500
```bash
# Verificar logs de erro
tail -f /var/log/seu-usuario.pythonanywhere.com.error.log

# Verificar dependências
source venv/bin/activate
pip list

# Testar aplicação localmente
python app.py
```

### Problema: Arquivos estáticos não carregam
```bash
# Verificar permissões
ls -la static/

# Verificar configuração
cat /var/www/seu-usuario_pythonanywhere_com_wsgi.py
```

### Problema: Domínio não funciona
```bash
# Verificar DNS
nslookup seu-dominio.com

# Verificar configuração no dashboard
# Web → Domains
```

## 📞 Suporte PythonAnywhere

### Recursos:
- **Documentação**: [help.pythonanywhere.com](https://help.pythonanywhere.com)
- **Fórum**: [forum.pythonanywhere.com](https://forum.pythonanywhere.com)
- **Email**: support@pythonanywhere.com

### Informações Úteis:
- **Status**: [status.pythonanywhere.com](https://status.pythonanywhere.com)
- **Limites**: [pythonanywhere.com/plans](https://pythonanywhere.com/plans)

## 🎉 Deploy Concluído!

Após seguir todos os passos, sua aplicação estará disponível em:
- **Free**: `https://seu-usuario.pythonanywhere.com`
- **Pago**: `https://seu-dominio.com`

### Próximos Passos:
1. **Testar aplicação** acessando o domínio
2. **Configurar domínio customizado** (se pago)
3. **Configurar backup automático**
4. **Monitorar logs e performance**
5. **Otimizar conforme necessário**

---

**Dica**: O PythonAnywhere é excelente para aplicações Flask. A conta gratuita é perfeita para começar, e você pode fazer upgrade conforme o projeto cresce. 