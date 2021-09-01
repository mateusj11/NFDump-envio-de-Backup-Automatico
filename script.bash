#!/bin/bash

#Busca Informações para envio das mensagens do Telegram
source ./telegram.bash

##Declarando Variaveis de Data###
	var_dia=`date +%d`
	var_mes=`date +%m`
	var_ano=`date +%Y`
	var_hora=`date +%H:%M:%S`

##Declarando Variavel de dia do Backup (sempre o dia anterior)
	dia_bkp=`expr $var_dia - 1`

case "$dia_bkp" in
    0)
        if [ $var_mes -eq 01 ]
			then
				var_mes=13
				var_ano=`expr $var_ano - 1`
		fi
		mes_bkp_diaanterior=`expr $var_mes - 1`
		valida_mes_backup=`echo $mes_bkp_diaanterior | wc -c`
			case "$valida_mes_backup" in
				2) 
					mes_bkp_diaanterior=0$mes_bkp_diaanterior
				;;
			esac
		dia_bkp_diaanterior=`ls -l /fxt_log_cgnat/$var_ano/$mes_bkp_diaanterior | awk '{ print $9 }' | tail -1`		
		
		
		case "$mes_bkp_diaanterior" in
			#Se for primeiro de Janeiro chame o script backup anual
			12)
				source ./anual.bash
			;;
			
			#Se for o primeiro dia do mês e for Fevereiro a Dezembro, chame o script backup Mensal
			01|02|03|04|05|06|07|08|09|10|11)
				source ./mensal.bash
			;;
		esac
		
    ;;
    1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30)
		##Caso seja dia 2 até dia 31 chame o script Backup Diario
		source ./diario.bash
	;;
    *)
        echo "Opção inválida"
    ;;
esac

exit 0