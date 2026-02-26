#!/bin/bash

ARQUIVO_CARROS="carros.txt"
CLIENTE_FILE="clientes.txt"

# Garante que os arquivos existam para evitar erros de leitura
touch "$ARQUIVO_CARROS" "$CLIENTE_FILE" "logs.txt" "historico_vendas.txt" "historico_alugueis.txt"

pausar () {
    echo ""
    read -p "Pressione ENTER para continuar..."
}

logar() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ${user:-Desconhecido} - $1" >> logs.txt
}

verficar_permissao_venda() {
    if [[ "$user" != "Admin" && "$user" != "Vendas" ]]; then
        echo "Erro: Sem permissão para vender carros!"
        pausar
        return 1
    fi
    return 0
}

visualizar_carros() {
    clear
    echo "============================================================"
    echo "                   CARROS CADASTRADOS                       "
    echo "============================================================"
    if [[ -s $ARQUIVO_CARROS ]]; then
        printf " %-3s | %-12s | %-15s | %-12s | %s\n" "Nº" "Marca" "Modelo" "Preço" "Status"
        echo "-----+--------------+-----------------+--------------+----------"
        counter=1
        while IFS=: read -r marca modelo preco status; do
            printf " %2d  | %-12s | %-15s | KZ$ %-9s | %s\n" \
                   "$counter" "$marca" "$modelo" "$preco" "$status"
            ((counter++))
        done < "$ARQUIVO_CARROS"
    else
        echo "Nenhum carro registrado ainda!!"
    fi
    echo "============================================================"
}

adicionar_carro() {
    clear
    echo "--- NOVO CARRO ---"
    read -p "Marca: " marca
    read -p "Modelo: " modelo
    read -p "Preço (apenas números): " preco
    
    if [[ -z "$marca" || -z "$modelo" || -z "$preco" ]]; then
        echo "Erro: Todos os campos são obrigatórios!"
        pausar
        return
    fi

    echo "$marca:$modelo:$preco:Disponível" >> "$ARQUIVO_CARROS"
    echo "Sucesso: Carro adicionado!"
    logar "Adicionou carro: $marca $modelo"
    pausar
}

vender_carro() {
    verficar_permissao_venda || return
    visualizar_carros
    echo ""
    read -p "Digite o NOME do carro para vender (ou ENTER para cancelar): " carro
    [ -z "$carro" ] && return

    if grep -iq "$carro" "$ARQUIVO_CARROS"; then
        # Remove o carro do arquivo (versão compatível com Git Bash)
        sed -i "/$carro/Id" "$ARQUIVO_CARROS"
        
        echo "Carro '$carro' vendido com sucesso!!"
        data=$(date "+%Y-%m-%d %H:%M:%S")
        echo "$data - $user vendeu o carro: $carro" >> historico_vendas.txt
        logar "Venda realizada: $carro"
    else
        echo "Erro: Carro não encontrado ou nome incorreto."
    fi
    pausar
}

adicionar_cliente() {
    clear
    echo "--- NOVO CLIENTE ---"
    read -p "Nome: " nome
    read -p "ID/Documento: " cliente_id
    read -p "Telefone: " telefone

    if [[ -z "$nome" || -z "$cliente_id" ]]; then
        echo "Erro: Nome e ID são obrigatórios!"
        pausar
        return
    fi

    echo "$nome:$cliente_id:$telefone" >> "$CLIENTE_FILE"
    echo "Cliente adicionado com sucesso!"
    logar "Adicionou cliente: $nome"
    pausar
}

listar_cliente() {
    clear
    echo "============================================================"
    echo "                   LISTA DE CLIENTES                        "
    echo "============================================================"
    if [[ -s "$CLIENTE_FILE" ]]; then
        printf " %-3s | %-20s | %-10s | %s\n" "Nº" "Nome" "ID" "Telefone"
        echo "-----+----------------------+------------+--------------"
        counter=1
        while IFS=: read -r nome id telefone; do
            printf " %2d  | %-20s | %-10s | %s\n" "$counter" "$nome" "$id" "$telefone"
            ((counter++))
        done < "$CLIENTE_FILE"
    else
        echo "Nenhum cliente cadastrado."
    fi
    echo "============================================================"
    pausar
}

alugar_carro() {
    visualizar_carros
    echo ""
    read -p "Digite o NOME do modelo que deseja alugar: " modelo_alugar
    [ -z "$modelo_alugar" ] && return

    if grep -q "$modelo_alugar.*Disponível" "$ARQUIVO_CARROS"; then
        read -p "Nome do Cliente: " nome_cli
        read -p "Dias de aluguer: " dias
        
        # Pega o preço do carro via awk
        preco=$(grep "$modelo_alugar" "$ARQUIVO_CARROS" | cut -d: -f3)
        valor_total=$((dias * preco))
        
        # Atualiza status para Alugado
        sed -i "s/\($modelo_alugar.*\)Disponível/\1Alugado/" "$ARQUIVO_CARROS"
        
        data_ini=$(date "+%Y-%m-%d")
        echo "$nome_cli:$modelo_alugar:$data_ini:$dias dias:KZ$ $valor_total" >> historico_alugueis.txt
        
        echo "Sucesso! Valor Total: KZ$ $valor_total"
        logar "Aluguer: $modelo_alugar para $nome_cli"
    else
        echo "Carro não disponível ou não encontrado."
    fi
    pausar
}

ver_historico_vendas() {
    clear
    echo "--- HISTÓRICO DE VENDAS ---"
    if [ -s "historico_vendas.txt" ]; then
        cat "historico_vendas.txt"
    else
        echo "Nenhuma venda registrada."
    fi
    pausar
}

# Funções auxiliares para o Dashboard
calcular_total_vendas() {
    # Exemplo simples: soma a última coluna do historico_vendas se houver valor
    # Como seu historico_vendas é texto puro, aqui retorna 0 ou ajuste a lógica
    echo "0" 
}

calcular_total_alugueis() {
    if [ -f "historico_alugueis.txt" ]; then
        awk -F'KZ\\$ ' '{sum += $2} END {print sum + 0}' historico_alugueis.txt
    else
        echo "0"
    fi
}

contar_carros() {
    grep -c "Disponível" "$ARQUIVO_CARROS"
}
gerenciar_usuarios() {
    while true; do
        clear
        echo "=============================================="
        echo "           GERENCIAR UTILIZADORES             "
        echo "=============================================="
        echo " 1) Listar Utilizadores"
        echo " 2) Adicionar Novo Utilizador"
        echo " 3) Remover Utilizador"
        echo " 0) Voltar"
        echo "=============================================="
        read -p "Escolha uma opção: " opt_user

        case $opt_user in
            1)
                clear
                echo "--- LISTA DE UTILIZADORES ---"
                echo "Utilizador | Tipo"
                echo "----------------------------"
                # Exibe user e tipo (campos 1 e 3), ocultando a senha (campo 2)
                awk -F: '{printf "%-12s | %s\n", $1, $3}' usuarios.txt
                echo "----------------------------"
                read -p "Pressione Enter para continuar..."
                ;;
            2)
                echo -e "\n--- NOVO UTILIZADOR ---"
                read -p "Nome de Utilizador: " novo_user
                read -s -p "Senha: " nova_pass
                echo ""
                echo "Tipos disponíveis: Admin, Vendas, Recepcao"
                read -p "Tipo de acesso: " novo_tipo

                if [[ -n "$novo_user" && -n "$nova_pass" ]]; then
                    # Verifica se o utilizador já existe
                    if grep -q "^$novo_user:" usuarios.txt; then
                        echo "Erro: Este utilizador já existe!"
                    else
                        echo "$novo_user:$nova_pass:$novo_tipo" >> usuarios.txt
                        echo "Utilizador cadastrado com sucesso!"
                        logar "Admin criou utilizador: $novo_user"
                    fi
                else
                    echo "Erro: Nome e senha são obrigatórios!"
                fi
                sleep 2
                ;;
            3)
                echo -e "\n--- REMOVER UTILIZADOR ---"
                read -p "Digite o nome do utilizador a remover: " user_del
                
                if [[ "$user_del" == "Admin" ]]; then
                    echo "Erro: O Admin principal não pode ser removido!"
                elif grep -q "^$user_del:" usuarios.txt; then
                    # Remove a linha do utilizador (versão compatível Windows)
                    sed -i "/^$user_del:/d" usuarios.txt
                    echo "Utilizador '$user_del' removido."
                    logar "Admin removeu utilizador: $user_del"
                else
                    echo "Utilizador não encontrado."
                fi
                sleep 2
                ;;
            0) break ;;
            *) echo "Opção inválida!"; sleep 1 ;;
        esac
    done
}
