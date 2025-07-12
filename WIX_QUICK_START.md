# 🚀 Guia Rápido - Wix + Flask

## ⚡ Deploy Rápido em 5 Passos

### 1. Criar Site no Wix (5 minutos)
```bash
# 1. Acesse wix.com
# 2. Clique em "Criar Site"
# 3. Escolha template "Business" ou "Technology"
# 4. Digite seu domínio (ex: megasena-ia)
# 5. Clique em "Começar"
```

### 2. Personalizar Landing Page (10 minutos)
```html
<!-- Hero Section -->
<h1>Transforme sua sorte com IA</h1>
<p>Sistema avançado de análise para Mega Sena</p>
<button>Comprar Agora - R$ 50,00</button>

<!-- Benefícios -->
<div>
    <div>✅ Análise Inteligente</div>
    <div>✅ Resultados Rápidos</div>
    <div>✅ Fácil de Usar</div>
</div>
```

### 3. Deploy do Backend (5 minutos)
```bash
# 1. Fazer push para GitHub
git add .
git commit -m "Add Wix integration"
git push origin main

# 2. Conectar ao Render
# - Acesse render.com
# - Conecte seu GitHub
# - Selecione o repositório
# - Build Command: pip install -r requirements_wix.txt
# - Start Command: gunicorn app_wix:app
```

### 4. Integrar Wix ↔ Backend (2 minutos)
```html
<!-- No Wix Editor, botão "Comprar Agora" -->
<a href="https://seu-app.onrender.com/comprar" target="_blank">
    Comprar Agora - R$ 50,00
</a>

<!-- Ou incorporar sistema via iframe -->
<iframe src="https://seu-app.onrender.com/iframe/sistema" 
        width="100%" 
        height="600px">
</iframe>
```

### 5. Testar e Publicar (3 minutos)
```bash
# 1. Testar links no Wix
# 2. Verificar responsividade
# 3. Configurar domínio customizado
# 4. Publicar site
```

## 🎯 Estrutura Recomendada do Wix

### Páginas:
- **Home**: Landing page principal
- **Sobre**: Informações do sistema
- **Contato**: Formulário de contato

### Seções na Home:
1. **Header**: Logo + Menu
2. **Hero**: Título + CTA principal
3. **Problema**: "Chega de apostar no escuro"
4. **Solução**: "Sistema MegaIA"
5. **Benefícios**: 3-4 cards
6. **Screenshots**: Galeria de imagens
7. **Depoimentos**: Testimonials
8. **FAQ**: Perguntas frequentes
9. **Preço**: Destaque do valor
10. **CTA Final**: "Comprar Agora"
11. **Footer**: Links + Contato

## 🔧 Configuração Técnica

### Backend (Render):
```python
# app_wix.py
from flask import Flask, render_template, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Permitir requisições do Wix

@app.route('/comprar')
def comprar():
    return render_template('checkout.html')

@app.route('/iframe/sistema')
def iframe_sistema():
    return render_template('iframe_sistema.html')
```

### Wix (Landing Page):
```html
<!-- Botão de compra -->
<a href="https://seu-app.onrender.com/comprar" target="_blank">
    Comprar Agora - R$ 50,00
</a>

<!-- Iframe do sistema -->
<iframe src="https://seu-app.onrender.com/iframe/sistema" 
        width="100%" 
        height="600px">
</iframe>
```

## 🎨 Design Recomendado

### Cores:
- **Primária**: Verde (#28a745) - Sucesso
- **Secundária**: Azul (#007bff) - Confiança
- **Acento**: Vermelho (#dc3545) - Urgência

### Elementos:
- **Hero**: Fundo gradiente verde
- **CTA**: Botão vermelho destacado
- **Cards**: Fundo branco com bordas
- **Footer**: Fundo escuro

## 📊 Monitoramento

### Wix Analytics:
- Visitas diárias
- Tempo na página
- Dispositivos (mobile/desktop)
- Conversões (cliques nos botões)

### Backend Analytics:
- Logs de acesso
- Compras realizadas
- Performance da aplicação

## 💰 Otimização de Conversão

### Elementos de Conversão:
1. **Urgência**: "Oferta limitada"
2. **Escassez**: "Apenas X vagas"
3. **Social Proof**: "500+ usuários"
4. **Garantia**: "30 dias de garantia"

### A/B Testing:
- Testar diferentes cores de CTA
- Testar diferentes textos
- Testar posicionamento dos elementos

## 🚨 Troubleshooting

### Problema: Links não funcionam
```bash
# Verificar se o backend está online
curl https://seu-app.onrender.com/health

# Verificar se o domínio está correto no Wix
```

### Problema: Iframe não carrega
```bash
# Verificar CORS no backend
# Verificar se a URL está correta
# Testar em navegador diferente
```

### Problema: Formulário não envia
```bash
# Verificar se a API está funcionando
curl -X POST https://seu-app.onrender.com/api/contact
```

## 🎉 Próximos Passos

1. **Criar conta no Wix** ✅
2. **Escolher template** ✅
3. **Personalizar design** ✅
4. **Deploy do backend** ✅
5. **Integrar links** ✅
6. **Testar tudo** ✅
7. **Publicar site** ✅
8. **Monitorar resultados** ✅

---

**Tempo total estimado**: 25 minutos
**Custo**: Gratuito para começar
**Resultado**: Site profissional + Backend funcional 