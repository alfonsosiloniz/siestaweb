#!/bin/bash
# pepper, jotabe, (c) Grupo SIESTA, 26-09-2007
#
# Genera cache de sincroguía en XML de 1 canal
# $1 Fichero sincroguia (.db)
# $2 horaUTCparrilla

# Ejecutamos el script con baja prioridad
renice 20 $$ > /dev/null

# Obtener parametros
chID=`echo $1 | cut -d"_" -f2 | cut -d"." -f1`
if [ "Z$2" != "Z" ]; then
	horaUTCparrilla=$2
else
	horaUTCparrilla=`date +%s`
fi

# Configurar entorno
source ../www-setup.shi
LCK_FILE=${Cache}/cache.$chID.generating
LOG=${Cache}/cache.sincro.log
ERR=${Cache}/cache.sincro.err
CACHE_FILE=${Cache}/cache.$chID

# Crear marca de generacion de cache de canal
touch ${LCK_FILE}

# Generar cache
if [ -f $1 ]; then
	# Obtener datos canal
	mapping=`grep ":${chID}:" ${Cache}/info_channels.txt | head -1`
	cid=`echo "$mapping" | cut -d":" -f2`
	chName=`echo "$mapping" | cut -d":" -f4`
	numChannel=`echo "$mapping" | cut -d":" -f1`

	# Log del proceso
	printf "`date` Canal [%3s]: " "$chID" >> $LOG

	# Copia temporal de sincroguia
	DB_FILE=/tmp/`basename $1`
	cp $1 $DB_FILE

	# Extraer datos
	if [ $? -eq 0 -a -f $DB_FILE ]; then
		# Generar ficheros vacios
		echo -n "" > ${CACHE_FILE}.text
		echo -n "" > ${CACHE_FILE}.xml
		echo -n "" > ${CACHE_FILE}.html
	
		# Log del proceso
		echo -n "Generación " >> $LOG
	
		# Generar fichero text
		echo -n "db->text" >> $LOG
		www-tools db2text $DB_FILE > ${CACHE_FILE}.text.temp
		ST_db2text=$?
		if [ $ST_db2text -ne 0 ]; then
			echo " <b>ERROR</b>" >> $LOG
		else
			# Ordenar fichero text
			sort ${CACHE_FILE}.text.temp > ${CACHE_FILE}.text
	
			# Generar fichero xml
			echo -n ",text->xml" >> $LOG
			echo "<CHANNEL cid=\"$cid\" id=\"${chID}\" name=\"$chName\" file=\"$1\" numChannel=\"$numChannel\">" >> ${CACHE_FILE}.xml
			www-tools text2xml ${chID} ${CACHE_FILE}.text >> ${CACHE_FILE}.xml
			ST_text2xml=$?
			echo "</CHANNEL>" >> ${CACHE_FILE}.xml
			if [ $ST_text2xml -ne 0 ]; then
				echo " <b>ERROR</b>" >> $LOG
			else
				# Comprobar si mostrar imagenes
				if [ "$MOSTRAR_MINI_IMG" != "si" ]; then
					MOSTRAR_IMG=0
				else
					# Comprobar si obtener imagen de internet
					if [ "Z$OBTENER_IMG_INET" = "Zsi" ]; then
						MOSTRAR_IMG=2
					else
						MOSTRAR_IMG=1
					fi
				fi

				# Generar fichero html
				echo -n ",text->html" >> $LOG
				www-tools text2html ${chID} ${CACHE_FILE}.text ${horaUTCparrilla} ${MOSTRAR_IMG} >> ${CACHE_FILE}.html
				ST_text2html=$?
				if [ $ST_text2html -ne 0 ]; then
					echo " <b>ERROR</b>" >> $LOG
				else
					# Resultado generacion OK
					echo " = OK" >> $LOG
				fi
			fi
		fi
	else
		echo " <b>ERROR</b> copia fichero datos" >> $LOG
	fi

	# Eliminar temporales
	rm -f ${CACHE_FILE}.text.temp
    rm -f $DB_FILE
fi

# Eliminar marca de generacion de cache de canal
rm -f ${LCK_FILE}
