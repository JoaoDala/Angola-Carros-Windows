#!/bin/bash

# Garante que o script rode no diretório correto
cd "$(dirname "$0")"

# Tenta carregar as funções
if [ -f "funcoes.sh" ]; then
    source funcoes.sh
else
    echo "Erro: funcoes.sh não encontrado!"
    exit 1
fi

# Verificar existência de arquivos necessários
[[ ! -f "vendas.txt" ]] && touch vendas.txt
[[ ! -f "alugueis.txt" ]] && touch alugueis.txt
[[ ! -f "clientes.txt" ]] && touch clientes.txt

# Função para formatar valores monetários (Padrão Kwanza/Real)
formatar_moeda() {
    # Usando awk para formatar com milhar e duas casas decimais
    echo "$1" | awk '{printf "KZ$ %'\''2.f\n", $1}'
}

exibir_dashboard() {
    clear
    # Obter estatísticas das funções externas
    # Nota: Certifique-se que estas funções em funcoes.sh retornam apenas números (ex: 1500.50)
    vendas_raw=$(calcular_total_vendas)
    alugueis_raw=$(calcular_total_alugueis)
    
    # Cálculo usando AWK (mais confiável que 'bc' no Windows/Git Bash)
    total_geral=$(awk -v v="$vendas_raw" -v a="$alugueis_raw" 'BEGIN {print v + a}')
    
    # Contagens simples
    total_carros=$(contar_carros)
    total_clientes=$(wc -l < clientes.txt)

    # Formatando valores para exibição
    total_vendas_fmt=$(formatar_moeda "$vendas_raw")
    total_alugueis_fmt=$(formatar_moeda "$alugueis_raw")
    total_geral_fmt=$(formatar_moeda "$total_geral")

    echo "=================================================="
    echo "          DASHBOARD - RESUMO FINANCEIRO           "
    echo "=================================================="
    echo -e " RECEITA TOTAL:      $total_geral_fmt"
    echo "--------------------------------------------------"
    echo -e " Vendas:             $total_vendas_fmt"
    echo -e " Aluguéis:           $total_alugueis_fmt"
    echo "--------------------------------------------------"
    echo -e " Carros disponíveis:  $total_carros"
    echo -e " Clientes registrados: $total_clientes"
    echo "=================================================="
    echo ""
    read -p "Pressione Enter para voltar ao menu..."
}

# Executa a função
exibir_dashboard
