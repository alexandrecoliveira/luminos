#!/usr/bin/env bash

echo "inicio ..."
arq='/sys/class/backlight/intel_backlight/brightness'
config='/root/.brilho_monitor'

function lerValorBrilho()
{
	if [ -e "$arq" ]
	then
		valor=$(cat "$arq")
		echo "$valor"
	else
		return 1
	fi
}

function ajustarBrilho()
{
	if [ "$2" == "+" ]
	then
		echo "$2"
		vlrAtual=$(lerValorBrilho)
		vlrAtual=$((vlrAtual+$1))
		echo "Valor atual .:" "$vlrAtual"
		echo "$vlrAtual" > $arq
	else
		echo "$2"
		vlrAtual=$(lerValorBrilho)
		vlrAtual=$((vlrAtual-$1))
		echo "Valor atual .:" "$vlrAtual"
		echo "$vlrAtual" > $arq
	fi
	return 1
}

function ultimoValor()
{
	if [ -e "$config" ]
	then
		vlr_atual=$(cat "$config")
		printf "%s\n" "$vlr_atual"
                echo "$vlr_atual" > "$arq"
	else
		vlr_atual=$(lerValorBrilho)
		echo "$vlr_atual" > "$config"
	fi
}

function salvarValorAtual()
{
	echo "Salvando o valor atual em disco ..."
	vlr_atual=$(lerValorBrilho)
	echo "$vlr_atual" > "$config"
}

function receberFator()
{
	while true
	do
		printf "Digite um fator [0-9] .: "
	        read -r fator
	        echo "$fator" | grep "^[0-9]"
		if [ "$?" -eq "0" ]
		then
			return 0
		else
			echo "Inválido ..."
		fi
	done
}

receberFator

while true
do
	printf "Digite [A|D|U|S] .: "
	read -r -sn1 t
	case $t in
        	A) ajustarBrilho "$fator" "+";;
        	D) ajustarBrilho "$fator" "-";;
		U) printf "Usando ultimo valor ...";
	   	   ultimoValor ;;
		S) salvarValorAtual ;;
        	*) printf "erro, recebido .: %s\n" "$t";;
	esac
	printf "\n"
done
