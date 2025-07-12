# 🚀 Deploy Rápido - PythonAnywhere

## ⚡ Deploy em 10 Minutos

### 1. Criar Conta (2 min)
```bash
# 1. Acesse pythonanywhere.com
# 2. Clique em "Create a Beginner account"
# 3. Preencha dados e confirme email
# 4. Acesse o dashboard
```

### 2. Upload dos Arquivos (3 min)
```bash
# No console do PythonAnywhere
git clone https://github.com/seu-usuario/megasena.git
cd megasena
```

### 3. Configurar Ambiente (2 min)
```bash
# Criar ambiente virtual
python3 -m venv venv
source venv/bin/activate

# Instalar dependências
pip install -r requirements_pythonanywhere.txt
```

### 4. Configurar Aplicação Web (3 min)
```bash
# No dashboard PythonAnywhere:
# 1. Web → Add a new web app
# 2. Escolha: seu-usuario.pythonanywhere.com
# 3. Framework: Manual configuration
# 4. Python version: 3.9+
```

### 5. Configurar WSGI (1 min)
```python
# Editar arquivo WSGI:
import sys
path = '/home/seu-usuario/megasena'
if path not in sys.path:
    sys.path.append(path)

from app_pythonanywhere import app as application
```

### 6. Testar (1 min)
```bash
# 1. Clique em "Reload" no dashboard
# 2. Acesse: https://seu-usuario.pythonanywhere.com
# 3. Verifique se está funcionando
```

## 🎯 Configuração Detalhada

### Dashboard PythonAnywhere:
1. **Web** → **Add a new web app**
2. **Domain**: seu-usuario.pythonanywhere.com
3. **Framework**: Manual configuration
4. **Python version**: 3.9 ou superior

### WSGI Configuration:
```python
# /var/www/seu-usuario_pythonanywhere_com_wsgi.py
import sys
import os

# Adicionar path do projeto
path = '/home/seu-usuario/megasena'
if path not in sys.path:
    sys.path.append(path)

# Configurar ambiente
os.environ['FLASK_ENV'] = 'production'
os.environ['FLASK_DEBUG'] = 'False'

# Importar aplicação
from app_pythonanywhere import app as application

# Configurar logging
import logging
logging.basicConfig(stream=sys.stderr)
```

### Environment Variables:
```bash
# No dashboard: Web → Environment variables
FLASK_ENV=production
FLASK_DEBUG=False
SECRET_KEY=sua-chave-secreta-aqui
```

## 🛠️ Comandos Úteis

### Gerenciar Aplicação:
```bash
# Reiniciar aplicação
touch /var/www/seu-usuario_pythonanywhere_com_wsgi.py

# Ver logs
tail -f megasena/logs/megasena.log

# Ver status
ps aux | grep python
```

### Gerenciar Código:
```bash
# Atualizar código
cd megasena
git pull origin main

# Instalar dependências
source venv/bin/activate
pip install -r requirements_pythonanywhere.txt
```

### Backup:
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

### Dashboard:
- **CPU usage**: Monitoramento em tempo real
- **Disk usage**: Espaço em disco
- **Memory usage**: Uso de memória

## 🔒 Segurança

### Configurações Automáticas:
- ✅ **SSL gratuito** para .pythonanywhere.com
- ✅ **Backup automático** diário
- ✅ **Headers de segurança** configurados
- ✅ **Logs de erro** automáticos

### Variáveis de Ambiente:
```bash
# Configurar no dashboard
SECRET_KEY=sua-chave-secreta-aqui
FLASK_ENV=production
DATABASE_URL=sqlite:///megasena.db
```

## 💰 Custos

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
tail -f megasena/logs/megasena.log

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

# Testar aplicação
python app_pythonanywhere.py
```

### Problema: Arquivos estáticos não carregam
```bash
# Verificar permissões
ls -la megasena/static/

# Verificar configuração WSGI
cat /var/www/seu-usuario_pythonanywhere_com_wsgi.py
```

## 📞 Suporte

### Recursos PythonAnywhere:
- **Documentação**: help.pythonanywhere.com
- **Fórum**: forum.pythonanywhere.com
- **Email**: support@pythonanywhere.com

### Informações Úteis:
- **Status**: status.pythonanywhere.com
- **Limites**: pythonanywhere.com/plans

## 🎉 Deploy Concluído!

Após seguir todos os passos, sua aplicação estará disponível em:
- **Free**: `https://seu-usuario.pythonanywhere.com`
- **Pago**: `https://seu-dominio.com`

### Próximos Passos:
1. ✅ **Testar aplicação** acessando o domínio
2. ✅ **Configurar domínio customizado** (se pago)
3. ✅ **Configurar backup automático**
4. ✅ **Monitorar logs e performance**
5. ✅ **Otimizar conforme necessário**

---

**Dica**: O PythonAnywhere é perfeito para aplicações Flask. A conta gratuita é excelente para começar, e você pode fazer upgrade conforme o projeto cresce.

**Tempo total**: 10 minutos
**Custo**: Gratuito para começar
**Resultado**: Aplicação Flask online e funcional 