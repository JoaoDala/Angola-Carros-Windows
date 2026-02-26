#!/bin/bash

# Garante que o script rode no diretório correto
cd "$(dirname "$0")"

# Função para gerar barras visuais
gerar_barras() {
    local qtd=$1
    local barra=""
    # Limita o tamanho da barra para não quebrar o layout do terminal
    [ $qtd -gt 30 ] && qtd=30
    for ((i = 0; i < qtd; i++)); do
        barra+="#"
    done
    echo "$barra"
}

# Função para contar registros por mês (Otimizada para Windows/Git Bash)
contar_por_mes() {
    local arquivo=$1
    local coluna_data=$2
    
    # Inicializa array com zeros (Índices 01 a 12)
    declare -A meses
    for m in {01..12}; do meses[$m]=0; done

    if [[ -f "$arquivo" ]]; then
        # Pula o cabeçalho se existir e lê o arquivo
        while IFS=: read -r linha; do
            # Extrai a data (ex: 2023-10-25)
            full_data=$(echo "$linha" | cut -d':' -f$coluna_data | xargs)
            # Pega apenas o mês (caracteres 6 e 7 da string YYYY-MM-DD)
            mes_extraido="${full_data:5:2}"
            
            if [[ "$mes_extraido" =~ ^(0[1-9]|1[0-2])$ ]]; then
                ((meses[$mes_extraido]++))
            fi
        done < <(tail -n +2 "$arquivo" 2>/dev/null)
    fi

    # Retorna os valores na ordem de Jan a Dez
    for m in {01..12}; do echo -n "${meses[$m]} "; done
}

# Verifica se existem dados
if [[ ! -s "historico_vendas.txt" && ! -s "historico_alugueis.txt" ]]; then
    echo "Erro: Nenhum dado de vendas ou alugueres encontrado para gerar gráfico."
    read -p "Pressione Enter para voltar..."
    exit 0
fi

# Realiza a contagem (Vendas coluna 1, Alugueres coluna 3)
vendas_contagem=($(contar_por_mes "historico_vendas.txt" 1))
alugueis_contagem=($(contar_por_mes "historico_alugueis.txt" 3))

# Meses para exibição
nomes_meses=(Jan Fev Mar Abr Mai Jun Jul Ago Set Out Nov Dez)

clear
echo "==========================================================================="
echo "             RELATÓRIO GRÁFICO - DESEMPENHO ANUAL (V vs A)                 "
echo "==========================================================================="
echo " Legenda: V = Vendas (#) | A = Alugueres (*)                               "
echo "---------------------------------------------------------------------------"

for i in {0..11}; do
    v_val=${vendas_contagem[$i]}
    a_val=${alugueis_contagem[$i]}
    
    # Gera as barras (Vendas com # e Alugueres com *)
    v_barra=$(gerar_barras $v_val)
    a_barra=$(echo "$(gerar_barras $a_val)" | tr '#' '*')
    
    printf "%s | V: %-20s (%d)\n" "${nomes_meses[$i]}" "$v_barra" "$v_val"
    printf "    | A: %-20s (%d)\n" "$a_barra" "$a_val"
    echo "----+----------------------------------------------------------------------"
done

echo ""
read -p "Pressione Enter para voltar ao menu..."
