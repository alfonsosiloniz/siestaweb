#!/bin/bash
# Martin Ostermann, 2005-08-21
# pepper, jotabe, (c) Grupo SIESTA, 29-10-2007
# Modificado por phosy para devolver el espacio libre en disco, 06-05-2007
#
# Devolver informacion de lista de ficheros crid
# $1 Carpeta con ficheros .crid
# $2 Clase (TIMER o RECORDINGS)
# $3 Plantilla .xsl

# Obtener parametros
Recordings=$1
# Recordings=/usb/old
crid_class=$2

# Configurar entorno
source ../www-setup.shi
source ../fweb.shi
video_dir=`sed -n -e "/DeviceRecordingFolder/ s/D.* *\(.pvr.*\)/\1/p" /var/etc/settings.txt`
fmpg0=""
du=0

# Enviar documento xml
xml_doc "/xsl/${3}"

# Inicio resultado xml
echo "<M750>"

# Calculo de espacio libre
if [ -d $video_dir ]; then
	disk_space=`df $video_dir |tail -1 | cut -b 42-50`
	disk_spaceMb=$((disk_space/1024))
	disk_spaceGb=$((disk_spaceMb/1024))
	echo "	<SPACE>$disk_spaceMb Mb ($disk_spaceGb Gb ~ $((disk_spaceGb/2)) horas)</SPACE>"
fi

# Vaciar lista de ficheros para ordenacion
CachefileTemp=${Cache}/lista-grabaciones.xml.tmp
echo -n "" > $CachefileTemp

# Clase ficheros .crid
echo "	<${crid_class} now=\"`date +%s`\">"

# Comprobar carpeta
if [ -d $Recordings ]; then
	IDserieActual=""
	# Recorrer ficheros .crid
	for Cridfile in $Recordings/*.crid; do
# 	for Cridfile in $Recordings/*.refXML; do
		# Comprobar cache de fichero crid
# 		Cachefile=${Cridfile}
		Cachefile=${Cache}/`basename $Cridfile .crid`.refXML
		if [ $Cridfile -nt $Cachefile ] ; then
			# Procesar fichero crid
			eval `www-tools crid2var ${Cridfile}`

			# Calcular espacio usado en grabaciones
			if [ "$crid_class" = "RECORDINGS" ]; then
				# Nombres fragmentos
				i=0
				files=""
				while [ $i -lt $num_fmpg ]; do
					# Nombre fragmento
					TMP='$fmpg'${i}
					eval "TMP2=$TMP"
					files="${files} $Recordings/${TMP2}*"
					# Siguiente fragmento
					i=$(($i+1))
				done

				# Calcular espacio usado
				du=(`du -ch ${files} | tail -1`)
			 fi

			# Volcar datos a fichero cache
			# Es muy importante que cada grabacion vaya en una sola linea, y ademas que el SERIE_ID sea el primer tag del XML
			# para una posterior ordenacion de la lista por Serie
			( echo -n "<SERIE_ID>$IDserie</SERIE_ID><UTC_TIME>$EPG_start_time</UTC_TIME><CRID_FILE>$Cridfile</CRID_FILE><TITLE>$Titulo</TITLE><REC_STATE>$Rec_State</REC_STATE><INIT_TIME>$FMT_start_time</INIT_TIME><END_TIME>$FMT_end_time</END_TIME><DURATION>$Duration</DURATION><UTC_END_TIME>$EPG_end_time</UTC_END_TIME><IMPORTANT>$Grabacion_protegida</IMPORTANT><PLAYBACK_TS>$playback_timestamp</PLAYBACK_TS><PIDCID>$CRID_ID</PIDCID><NUM_FMPG>$num_fmpg</NUM_FMPG><FMPG>$fmpg0</FMPG>"

			# Recorrer fragmentos adicionales
			i=1
			while [ $i -lt $num_fmpg ]; do
				# Nombre fragmento
				TMP='$fmpg'${i}
				eval "TMP2=$TMP"
				echo -n "<FMPG${i}>$TMP2</FMPG${i}>"
				# Siguiente fragmento
				i=$(($i+1))
			done
	
			echo "<SPACE>$du</SPACE>" ) > $Cachefile
		fi

		# Devolver resultado de cache de fichero crid
		cat $Cachefile >> $CachefileTemp
	done
fi

# Por defecto, enviamos la lista de grabaciones ordenadas por serie, con un nuevo campo CAMBIO_SERIE que indica si del registro anterior
# al actual, ha cambiado el identificador de Serie, para luego pintarlo correctamente en pantalla, diferenciando entre series.
sort -r $CachefileTemp > ${CachefileTemp}.sort
echo -n "" > $CachefileTemp
serieAct="0"
while read line; do
	serie=`echo $line | cut -d ">" -f2 | cut -d "<" -f 1`
	if [ "Z$serie" != "Z$serieAct" ]; then
		cambio_serie=1
	else
		cambio_serie=0
	fi

	# Volcar linea datos
	echo "		<RECORD>
			<CAMBIO_SERIE>$cambio_serie</CAMBIO_SERIE>
			$line
		</RECORD>" >> $CachefileTemp
	serieAct=$serie
done < ${CachefileTemp}.sort

cat < $CachefileTemp
rm -f ${CachefileTemp} ${CachefileTemp}.sort

# Final xml
echo "	</${crid_class}>
</M750>"
