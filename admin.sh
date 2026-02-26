#!/bin/bash

# Garante que o script rode no diretório onde está salvo
cd "$(dirname "$0")"

# Tenta carregar as funções, se o arquivo existir
if [ -f "funcoes.sh" ]; then
    source funcoes.sh
else
    echo "Erro: funcoes.sh não encontrado!"
fi

while true; do
    clear
    echo "========================================"
    echo "           MENU ADMINISTRADOR           "
    echo "========================================"
    echo " 1) Visualizar carros"
    echo " 2) Visualizar histórico de vendas"
    echo " 3) Visualizar Dashboard"
    echo " 4) Backups"
    echo " 5) Visualizar Logs"
    echo " 6) Gerenciar Usuários"
    echo " 7) Relatórios de Atividades"
    echo " 8) Configurações do Sistema"
    echo " 9) Gráfico de Desempenho"
    echo " 0) Sair da aplicação"
    echo "========================================"
    
    read -p "Escolha uma opção: " opcao

    case $opcao in
        1)
            visualizar_carros
            read -p "Pressione Enter para voltar..."
            ;;
        2)
            ver_historico_vendas
            read -p "Pressione Enter para voltar..."
            ;;
        3)
            bash dashboard.sh
            read -p "Pressione Enter para voltar..."
            ;;
        4)
            bash backup.sh
            read -p "Pressione Enter para voltar..."
            ;;
        5)
            echo "--- Exibindo logs.txt ---"
            if [ -f "logs.txt" ]; then
                cat logs.txt
            else
                echo "Arquivo de logs não encontrado."
            fi
            read -p "Pressione Enter para voltar..."
            ;;
        6)
            gerenciar_usuarios
            read -p "Pressione Enter para voltar..."
            ;;
        7)
            gerar_relatorios
            read -p "Pressione Enter para voltar..."
            ;;
        8)
            configurar_sistema
            read -p "Pressione Enter para voltar..."
            ;;
        9)
            bash relatorio_grafico.sh
            read -p "Pressione Enter para voltar..."
            ;;
        0)
            echo "Saindo do sistema..."
            sleep 1
            break
            ;;
        *)	
            echo "Opção inválida!"
            sleep 1
            ;;
    esac
done
