#!/bin/bash

# Garante que o script rode no diretório correto
cd "$(dirname "$0")"

# Tenta carregar as funções auxiliares
[ -f "funcoes.sh" ] && source funcoes.sh

# Garante que o arquivo de usuários existe com o admin padrão
if [[ ! -f "usuarios.txt" ]]; then
    echo "Admin:0000:Admin" > usuarios.txt
fi

login() {
    tentativas=0
    while [[ $tentativas -lt 3 ]]; do
        clear
        echo "========================================"
        echo "            TELA DE LOGIN               "
        echo "========================================"
        read -p " Nome de Utilizador: " user
        
        # O -s esconde a senha enquanto o utilizador digita
        read -s -p " Senha: " pass
        echo "" # Pula linha após digitar a senha
        echo "========================================"

        # 1. Verificar se é o Admin fixo (redundância de segurança)
        if [[ "$user" == "Admin" && "$pass" == "0000" ]]; then
            export user_type="Admin"
            export user="$user"
            echo "Acesso concedido como Administrador!"
            sleep 1
            bash admin.sh
            return
        fi
        
        # 2. Verificar nos usuários cadastrados em usuarios.txt
        login_sucesso=false
        while IFS=: read -r username password tipo; do
            # Remove possíveis espaços ou caracteres \r do Windows
            username=$(echo "$username" | tr -d '\r')
            password=$(echo "$password" | tr -d '\r')
            tipo=$(echo "$tipo" | tr -d '\r')

            if [[ "$user" == "$username" && "$pass" == "$password" ]]; then
                export user_type="$tipo"
                export user="$user"
                login_sucesso=true
                
                echo "Bem-vindo, $user ($tipo)!"
                sleep 1
                
                case "$tipo" in
                    "Vendas")   bash vendas.sh ;;
                    "Recepcao") bash recepcao.sh ;;
                    "Admin")    bash admin.sh ;;
                    *) 
                        echo "Erro: Tipo de usuário '$tipo' inválido!"
                        sleep 2
                        return
                        ;;
                esac
                return
            fi
        done < "usuarios.txt"
        
        if [ "$login_sucesso" = false ]; then
            echo "Erro: Utilizador ou senha incorretos!"
            ((tentativas++))
            echo "Tentativas restantes: $((3 - tentativas))"
            sleep 2
        fi
    done

    echo "Número máximo de tentativas excedido. Saindo..."
    sleep 2
    clear
    exit 1
}

# Inicia o processo de login
login
