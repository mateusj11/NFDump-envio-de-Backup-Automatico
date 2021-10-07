#!/bin/bash

case "$dia_bkp" in
	1|2|3|4|5|6|7|8|9)
		dia_bkp=0$dia_bkp
		;;
esac

var_data=$dia_bkp-$var_mes-$var_ano
	
###Declarando Variavel nome do arquivo
	nome_arquivo=LogCGNAT_$dia_bkp-$var_mes-$var_ano
		
##Criando Diretórios
	mkdir -p /fxt_log_cgnat_txt/$var_ano/$var_mes/$dia_bkp/
	mkdir -p /fxt_log_cgnat_targz/$var_ano/$var_mes/$dia_bkp/

##Criando Arquivos para envio
	nfdump -R /fxt_log_cgnat/$var_ano/$var_mes/$dia_bkp -o "fmt: %ts %nevt %pr %sa %pbstart %pbend %pbstep %pbsize %nsa" > /fxt_log_cgnat_txt/$var_ano/$var_mes/$dia_bkp/$nome_arquivo.txt
	tar -czpf /fxt_log_cgnat_targz/$var_ano/$var_mes/$dia_bkp/$nome_arquivo.tar.gz /fxt_log_cgnat/$var_ano/$var_mes/$dia_bkp
		
##Declarando diretórios dos arquivos e enviando para o telegram
	curl --silent -X POST --data-urlencode "chat_id=$CHAT_ID" --data-urlencode "text=Envio de Backup $dia_bkp/$var_mes/$var_ano" "https://api.telegram.org/bot${TOKEN}/sendMessage?disable_web_page_preview=true&parse_mode=html" | grep -q '"ok":true' &>/dev/null
	caminho_bkp_txt=/fxt_log_cgnat_txt/$var_ano/$var_mes/$dia_bkp/$nome_arquivo.txt
	caminho_bkp_tar=/fxt_log_cgnat_targz/$var_ano/$var_mes/$dia_bkp/$nome_arquivo.tar.gz
	curl -F document=@"${caminho_bkp_txt}" -F caption="BKP TXT $var_data, envio as $var_hora" "https://api.telegram.org/bot${TOKEN}/sendDocument?chat_id=$CHAT_ID" &>/dev/null
	curl -F document=@"${caminho_bkp_tar}" -F caption="BKP TAR GZ $var_data, envio as $var_hora" "https://api.telegram.org/bot${TOKEN}/sendDocument?chat_id=$CHAT_ID" &>/dev/null

exit 0