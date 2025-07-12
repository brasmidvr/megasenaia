# 🔧 Configuração de Rastreamento de Conversões - Facebook Ads

## 📊 Problema Identificado
As vendas não estão aparecendo no Facebook Ads porque faltam os eventos de conversão configurados corretamente.

## ✅ Solução Implementada
Adicionei o código de rastreamento de conversões no arquivo `templates/base.html`. O Facebook Pixel já estava configurado, agora também rastreia as conversões.

## 🔧 Configuração Atual

### Facebook Ads (Já configurado e funcionando)
✅ **Pixel ID:** `2269497933481722`
✅ **Evento de conversão:** `Purchase`
✅ **Valor:** R$ 50,00
✅ **Moeda:** BRL

## 📋 Como Funciona

### Eventos Rastreados:
1. **PageView** - Quando alguém visita a página
2. **Purchase** - Quando alguém clica no botão de compra

### Dados Enviados:
- **Valor:** R$ 50,00
- **Moeda:** BRL
- **Nome do produto:** MegaIA - Sistema Mega Sena
- **Categoria:** Software

## 🚀 Para Atualizar o Site

**No PythonAnywhere:**
```bash
cd /home/megasenaia/megasena
git pull origin main
```

**Depois recarregue o site no painel do PythonAnywhere.**

## 📊 Verificar se Está Funcionando

### 1. Teste Manual:
- Clique nos botões de compra
- Verifique no Facebook Events Manager se os eventos aparecem

### 2. Facebook Events Manager:
- Acesse: [business.facebook.com](https://business.facebook.com)
- Vá em: Events Manager
- Verifique se os eventos "Purchase" estão chegando

### 3. Facebook Ads:
- Vá em: Anúncios
- Verifique se as conversões aparecem nos relatórios

## ⏰ Tempo de Processamento
- **Eventos:** Aparecem em tempo real no Events Manager
- **Conversões nos anúncios:** 24-48h para consolidar

## 📞 Suporte
Se as conversões ainda não aparecerem, verifique:
1. Se o pixel está ativo no Facebook Ads
2. Se os eventos estão chegando no Events Manager
3. Se a configuração de conversão está correta no anúncio

**Agora as vendas devem aparecer corretamente no Facebook Ads!** 🚀 