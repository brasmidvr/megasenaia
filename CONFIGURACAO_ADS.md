# 🔧 Configuração de Rastreamento de Conversões

## 📊 Problema Identificado
As vendas não estão aparecendo no gerenciador de anúncios porque faltam os eventos de conversão configurados corretamente.

## ✅ Solução Implementada
Adicionei o código de rastreamento de conversões no arquivo `templates/base.html`. Agora você precisa configurar os IDs corretos.

## 🔧 Configurações Necessárias

### 1. Google Ads
**Substitua no arquivo `templates/base.html`:**

**Linha 25:** `AW-CONVERSION_ID` → Seu ID de conversão do Google Ads
**Linha 47:** `AW-CONVERSION_ID/CONVERSION_LABEL` → Seu ID/Label de conversão

**Como encontrar:**
1. Acesse Google Ads
2. Vá em Ferramentas → Conversões
3. Clique em "+" para criar nova conversão
4. Copie o ID e Label

### 2. Facebook Ads (Já configurado)
✅ ID: `2269497933481722` (já está funcionando)

## 📋 Passos para Configurar

### Google Ads:
1. **Acesse:** [ads.google.com](https://ads.google.com)
2. **Vá em:** Ferramentas → Conversões
3. **Clique:** "+" para criar nova conversão
4. **Configure:**
   - Nome: "Compra MegaIA"
   - Valor: R$ 50,00
   - Contagem: Uma vez
   - Janela de conversão: 30 dias
5. **Copie o ID** e substitua no código

### Exemplo de código configurado:
```html
<!-- Google Ads -->
gtag('config', 'AW-1234567890'); // Seu ID real

<!-- Evento de conversão -->
gtag('event', 'conversion', {
    'send_to': 'AW-1234567890/ABC123', // Seu ID/Label real
    'value': 50.00,
    'currency': 'BRL'
});
```

## 🚀 Após a Configuração

1. **Faça upload** do arquivo `base.html` atualizado
2. **Teste** clicando nos botões de compra
3. **Verifique** no Google Ads se as conversões aparecem
4. **Aguarde** 24-48h para ver os dados consolidados

## 📞 Suporte

Se precisar de ajuda para encontrar os IDs ou configurar, me avise! 