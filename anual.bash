#!/bin/bash

var_dia=$dia_bkp_diaanterior
var_mes=$mes_bkp_diaanterior
				
dia_bkp=$var_dia
var_data=$dia_bkp-$var_mes-$var_ano
		
		
###Declarando Variavel nome do arquivo
	nome_arquivo=LogCGNAT_$dia_bkp-$var_mes-$var_ano
	nome_arquivo_mensal=LogCGNAT_$var_mes-$var_ano
	nome_arquivo_anual=LogCGNAT_$var_ano
	
##Criando Diretórios
	mkdir -p /fxt_log_cgnat_txt/$var_ano/$var_mes/$dia_bkp/
	mkdir -p /fxt_log_cgnat_targz/$var_ano/$var_mes/$dia_bkp/
	mkdir -p /fxt_log_cgnat_mensal/$var_ano
		
##Criando Arquivos DIARIO para envio
	nfdump -R /fxt_log_cgnat/$var_ano/$var_mes/$dia_bkp -o "fmt: %ts %nevt %pr %sa %pbstart %pbend %pbstep %pbsize %nsa" > /fxt_log_cgnat_txt/$var_ano/$var_mes/$dia_bkp/$nome_arquivo.txt
	tar -czpf /fxt_log_cgnat_targz/$var_ano/$var_mes/$dia_bkp/$nome_arquivo.tar.gz /fxt_log_cgnat/$var_ano/$var_mes/$dia_bkp
					
##Criando Arquivos MENSAL para envio
	nfdump -R /fxt_log_cgnat/$var_ano/$var_mes -o "fmt: %ts %nevt %pr %sa %pbstart %pbend %pbstep %pbsize %nsa" > /fxt_log_cgnat_mensal/$var_ano/$nome_arquivo_mensal.txt
	tar -czpf /fxt_log_cgnat_mensal/$var_ano/$nome_arquivo_mensal.tar.gz /fxt_log_cgnat/$var_ano/$var_mes
	
##Criando Arquivos ANUAL para envio
	nfdump -R /fxt_log_cgnat/$var_ano -o "fmt: %ts %nevt %pr %sa %pbstart %pbend %pbstep %pbsize %nsa" > /fxt_log_cgnat_mensal/$var_ano/$nome_arquivo_anual.txt
	tar -czpf /fxt_log_cgnat_mensal/$var_ano/$nome_arquivo_anual.tar.gz /fxt_log_cgnat/$var_ano
	
##Declarando diretórios dos arquivos DIARIO, e enviando para o telegram
	curl --silent -X POST --data-urlencode "chat_id=$CHAT_ID" --data-urlencode "text=Envio de Backup $dia_bkp_diaanterior/$mes_bkp_diaanterior/$var_ano" "https://api.telegram.org/bot${TOKEN}/sendMessage?disable_web_page_preview=true&parse_mode=html" | grep -q '"ok":true' &>/dev/null
	sleep 5
	caminho_bkp_txt=/fxt_log_cgnat_txt/$var_ano/$var_mes/$dia_bkp/$nome_arquivo.txt
	caminho_bkp_tar=/fxt_log_cgnat_targz/$var_ano/$var_mes/$dia_bkp/$nome_arquivo.tar.gz
	curl -F document=@"${caminho_bkp_txt}" -F caption="BKP TXT $var_data, envio as $var_hora" "https://api.telegram.org/bot${TOKEN}/sendDocument?chat_id=$CHAT_ID" &>/dev/null
	curl -F document=@"${caminho_bkp_tar}" -F caption="BKP TAR GZ $var_data, envio as $var_hora" "https://api.telegram.org/bot${TOKEN}/sendDocument?chat_id=$CHAT_ID" &>/dev/null
				
##Pausa entre envios
	sleep 5

##Declarando diretórios dos arquivos MENSAL, e enviando para o telegram
	curl --silent -X POST --data-urlencode "chat_id=$CHAT_ID" --data-urlencode "text=!--- Envio de Backup mensal $mes_bkp_diaanterior/$var_ano ---!" "https://api.telegram.org/bot${TOKEN}/sendMessage?disable_web_page_preview=true&parse_mode=html" | grep -q '"ok":true' &>/dev/null
	sleep 5
	caminho_bkp_mensal_txt=/fxt_log_cgnat_mensal/$var_ano/$nome_arquivo_mensal.txt
	caminho_bkp_mensal_tar=/fxt_log_cgnat_mensal/$var_ano/$nome_arquivo_mensal.tar.gz
	curl -F document=@"${caminho_bkp_mensal_txt}" -F caption="BKP TXT MENSAL $var_mes/$var_ano , envio as $var_data $var_hora" "https://api.telegram.org/bot${TOKEN}/sendDocument?chat_id=$CHAT_ID" &>/dev/null
	curl -F document=@"${caminho_bkp_mensal_tar}" -F caption="BKP TAR GZ MENSAL $var_mes/$var_ano, envio as $var_data $var_hora" "https://api.telegram.org/bot${TOKEN}/sendDocument?chat_id=$CHAT_ID" &>/dev/null
	
##Pausa entre envios
	sleep 5

##Declarando diretórios dos arquivos ANUAL, e enviando para o telegram
	curl --silent -X POST --data-urlencode "chat_id=$CHAT_ID" --data-urlencode "text=!--- Envio de Backup mensal $mes_bkp_diaanterior/$var_ano ---!" "https://api.telegram.org/bot${TOKEN}/sendMessage?disable_web_page_preview=true&parse_mode=html" | grep -q '"ok":true' &>/dev/null
	sleep 5
	caminho_bkp_mensal_txt=/fxt_log_cgnat_mensal/$var_ano/$nome_arquivo_anual.txt
	caminho_bkp_mensal_tar=/fxt_log_cgnat_mensal/$var_ano/$nome_arquivo_anual.tar.gz
	curl -F document=@"${caminho_bkp_mensal_txt}" -F caption="BKP TXT MENSAL $var_mes/$var_ano , envio as $var_data $var_hora" "https://api.telegram.org/bot${TOKEN}/sendDocument?chat_id=$CHAT_ID" &>/dev/null
	curl -F document=@"${caminho_bkp_mensal_tar}" -F caption="BKP TAR GZ MENSAL $var_mes/$var_ano, envio as $var_data $var_hora" "https://api.telegram.org/bot${TOKEN}/sendDocument?chat_id=$CHAT_ID" &>/dev/null
		
	
	
##Apaga arquivos gerados do backup MENSAL
	rm $caminho_bkp_mensal_tar
	rm $caminho_bkp_mensal_txt
	rm $caminho_bkp_anual_tar
	rm $caminho_bkp_anual_txt
	
exit 0