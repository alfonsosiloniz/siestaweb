#!/bin/bash
# pepper, jotabe, (c) Grupo SIESTA, 26-09-2007
#
# Genera fichero cache de programa actual

# Ejecutamos el script con baja prioridad
renice 20 $$ > /dev/null

# Configurar entorno
source ../www-setup.shi
LCK_SINCRO=${Cache}/cache.sincro.generating
LCK_PGMACTUAL=${Cache}/cache.pgmactual.generating
LOG=${Cache}/cache.pgmactual.log
ERR=${Cache}/cache.pgmactual.err
CACHE_FILE=${Cache}/cache.pgmactual.xml
now=`date +%s`

# Comprobar marcas de generacion de cache XML y programa actual
[ -f ${LCK_SINCRO} -o -f ${LCK_PGMACTUAL} ] && exit -1

# Crear marca de generacion de programa actual
touch ${LCK_PGMACTUAL}

# Log del proceso
utc_inicio=`date +%s`
echo "`date` Inicio generación XML de Programa Actual [host: `hostname`], [Hora UTC: $now]" > $LOG
echo -n "" > $ERR

# Obtenemos lista de canales
source gen-lista-canales.shi

# Crear fichero temporal vacio
echo -n "" > ${CACHE_FILE}.temp

# Recorremos lista de canales
for Sincrofile in $ListaCanales; do
	if [ -f $Sincrofile ]; then
		# Obtener identificador de canal
		chID=`echo $Sincrofile | cut -d"_" -f2 | cut -d"." -f1`
		CHANNEL_CACHE=${Cache}/cache.$chID

		# Comprobar generacion de caché de canal
		if [ ! -f ${CHANNEL_CACHE}.generating ]; then
			# Obtener datos canal
			mapping=`grep ":${chID}:" ${Cache}/info_channels.txt | head -1`
			cid=`echo "$mapping" | cut -d":" -f2`
			chName=`echo "$mapping" | cut -d":" -f4`
			numChannel=`echo "$mapping" | cut -d":" -f1`

			# Log del proceso
			printf "`date` Canal [%3s]: text->programa_actual" "$chID" >> $LOG

			# Obtener programa actual de fichero .text
			echo "<CHANNEL cid=\"$cid\" id=\"${chID}\" name=\"$chName\" file=\"$1\" numChannel=\"$numChannel\">" >> ${CACHE_FILE}.temp
			www-tools text2pgact ${chID} ${CHANNEL_CACHE}.text ${now} >> ${CACHE_FILE}.temp 2>> $ERR
			ST_text2pgact=$?
			echo "</CHANNEL>" >> ${CACHE_FILE}.temp
			if [ $ST_text2pgact -ne 0 ]; then
				echo " <b>ERROR</b>" >> $LOG
			else
				# Resultado generacion OK
				echo " = OK" >> $LOG
			fi
		fi
	fi
done

# Pasar de fichero temporal a fichero definitivo
touch ${CACHE_FILE}.generating
rm -f ${CACHE_FILE}
mv ${CACHE_FILE}.temp ${CACHE_FILE}
rm -f ${CACHE_FILE}.generating

# Eliminar marca de generacion de programa actual
rm -f ${LCK_PGMACTUAL}

# Log del proceso
utc_final=`date +%s`
tiempo_proceso=`TZ=UTC awk "BEGIN {print strftime( \"%H:%M:%S\", $(($utc_final-$utc_inicio))) }"`
echo "`date` Fin generación XML de Programa Actual [host: `hostname`], Tiempo generación: ${tiempo_proceso}" >> $LOG
