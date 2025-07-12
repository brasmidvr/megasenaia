# 📁 Arquivos para Subir - PythonAnywhere

## 🎯 Arquivos Essenciais (OBRIGATÓRIOS)

### 📄 Arquivos Python:
```
✅ app_pythonanywhere.py          # Aplicação principal
✅ requirements_pythonanywhere.txt # Dependências
✅ wsgi_pythonanywhere.py         # Configuração WSGI
```

### 📁 Pastas:
```
✅ templates/                     # Templates HTML
   ├── base.html                 # Template base
   ├── landing.html              # Landing page
   ├── checkout.html             # Página de checkout
   └── iframe_sistema.html       # Sistema para iframe

✅ static/                       # Arquivos estáticos
   └── prints/                   # Imagens do sistema
       ├── banner_ia.png         # Banner principal
       ├── exemplo_analise.jpg   # Exemplo de análise
       ├── print1.jpg            # Screenshots do sistema
       ├── print3.jpg
       ├── print4.jpg
       ├── print5.jpg
       ├── print6.jpg
       ├── print7.jpg
       ├── print8.jpg
       ├── print9.jpg
       ├── print10.jpg
       ├── print11.jpg
       ├── print12.jpg
       ├── print13.jpg
       ├── print14.jpg
       ├── print15.jpg
       └── print16.jpg
```

## 🔧 Arquivos de Configuração (OPCIONAIS)

### 📄 Scripts de Setup:
```
✅ setup_pythonanywhere.sh       # Setup automático
✅ check_pythonanywhere.sh       # Verificação de deploy
```

### 📄 Documentação:
```
✅ PYTHONANYWHERE_DEPLOY.md     # Guia completo
✅ PYTHONANYWHERE_QUICK_START.md # Guia rápido
```

## ❌ Arquivos NÃO Subir

### 🚫 Arquivos de Outras Plataformas:
```
❌ app_wix.py                    # Para Wix
❌ requirements_wix.txt          # Para Wix
❌ WIX_*.md                     # Para Wix
❌ app_hostgator.py             # Para Hostgator
❌ HOSTGATOR_*.md               # Para Hostgator
❌ setup_hostgator.sh           # Para Hostgator
❌ check_hostgator.sh           # Para Hostgator
❌ nginx_hostgator.conf         # Para Hostgator
❌ .htaccess                    # Para Hostgator
❌ app.py                       # Versão original
❌ requirements.txt              # Versão original
❌ wsgi.py                      # Versão original
❌ gunicorn.conf.py             # Para VPS
❌ nginx.conf                   # Para VPS
❌ systemd.service              # Para VPS
❌ start.sh                     # Para VPS
❌ deploy.sh                    # Para VPS
❌ setup_contabo.sh             # Para Contabo
❌ check_deploy.sh              # Para Contabo
❌ DEPLOY_CONTABO.md            # Para Contabo
❌ CONTABO_SPECIFIC.md          # Para Contabo
❌ README_DEPLOY.md             # Para Contabo
```

### 🚫 Arquivos do Sistema:
```
❌ .git/                        # Repositório Git
❌ .gitignore                   # Configuração Git
❌ fotos/                       # Pasta de fotos local
```

## 📋 Lista Final para PythonAnywhere

### ✅ Arquivos ESSENCIAIS:
```
📄 app_pythonanywhere.py
📄 requirements_pythonanywhere.txt
📄 wsgi_pythonanywhere.py
📁 templates/
📁 static/
```

### ✅ Arquivos ÚTEIS:
```
📄 setup_pythonanywhere.sh
📄 check_pythonanywhere.sh
📄 PYTHONANYWHERE_DEPLOY.md
📄 PYTHONANYWHERE_QUICK_START.md
```

## 🚀 Como Subir

### Opção 1: Via Git (Recomendado)
```bash
# No PythonAnywhere Console
git clone https://github.com/seu-usuario/megasena.git
cd megasena

# Remover arquivos desnecessários
rm -f app.py requirements.txt wsgi.py
rm -f app_wix.py requirements_wix.txt
rm -f app_hostgator.py
rm -f *.conf *.service *.sh
rm -rf .git fotos/
```

### Opção 2: Upload Manual
1. **Selecione apenas os arquivos essenciais**
2. **Compacte em ZIP**
3. **Faça upload no PythonAnywhere**
4. **Extraia no diretório correto**

### Opção 3: Upload Individual
```bash
# No PythonAnywhere Files
# Upload apenas:
# - app_pythonanywhere.py
# - requirements_pythonanywhere.txt
# - wsgi_pythonanywhere.py
# - templates/ (pasta completa)
# - static/ (pasta completa)
```

## 📊 Tamanho Estimado

### Arquivos Essenciais:
- **app_pythonanywhere.py**: ~5KB
- **requirements_pythonanywhere.txt**: ~1KB
- **wsgi_pythonanywhere.py**: ~1KB
- **templates/**: ~40KB
- **static/prints/**: ~3MB
- **Total**: ~3MB

### Arquivos Úteis:
- **Scripts**: ~10KB
- **Documentação**: ~15KB
- **Total útil**: ~25KB

## 🎯 Resumo Final

### ✅ SUBIR:
```
📄 app_pythonanywhere.py
📄 requirements_pythonanywhere.txt
📄 wsgi_pythonanywhere.py
📁 templates/
📁 static/
📄 setup_pythonanywhere.sh (opcional)
📄 check_pythonanywhere.sh (opcional)
```

### ❌ NÃO SUBIR:
```
📄 app.py (usar app_pythonanywhere.py)
📄 requirements.txt (usar requirements_pythonanywhere.txt)
📄 wsgi.py (usar wsgi_pythonanywhere.py)
📁 .git/
📁 fotos/
📄 Todos os arquivos de outras plataformas
```

## 💡 Dica Importante

**Use sempre os arquivos específicos para PythonAnywhere:**
- `app_pythonanywhere.py` (não `app.py`)
- `requirements_pythonanywhere.txt` (não `requirements.txt`)
- `wsgi_pythonanywhere.py` (não `wsgi.py`)

Isso garante que sua aplicação funcione perfeitamente no PythonAnywhere! 🎯 