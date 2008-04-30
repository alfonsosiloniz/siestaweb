#!/bin/bash
# Martin Ostermann, 2005-08-21
# pepper, jotabe, (c) Grupo SIESTA, 26-03-2008
# Modificado por phosy para devolver el espacio libre en disco, 06-05-2007
#
# Devolver informacion de lista de ficheros crid
# $1 Carpeta con ficheros .crid
# $2 Clase (record/timer)
# $3 Orden (serie/time)
# $4 Proxima carpeta a usar para lista de grabaciones

# Obtener parametros
Recordings=$1
crid_class=$2
orden=$3
carpeta_ver=$4

# Configurar entorno
source ../www-setup.shi
source fweb.shi
validate_login
fmpg0=""
du=0
RecordingFolder=`awk '/DeviceRecordingFolder/ {print $2}' /var/etc/settings.txt`
carpeta_cpmv=/var/media/PC1/Video
if [ -f ${SERVER_ROOT}/cfg/.carpeta_cpmv.txt ]; then
	carpeta_cpmv=`cat ${SERVER_ROOT}/cfg/.carpeta_cpmv.txt`
else
	echo "$carpeta_cpmv" > ${SERVER_ROOT}/cfg/.carpeta_cpmv.txt
fi

# Enviar documento xml
xml_doc "/xsl/${crid_class}.xsl"

# Inicio resultado xml
echo "<M750 orden=\"${orden}\">
	<CARPETA>$Recordings</CARPETA>
	<CARPETA_REALPATH>`realpath $Recordings 2>/dev/null`</CARPETA_REALPATH>
	<CARPETA_GRABACIONES>$RecordingFolder</CARPETA_GRABACIONES>
	<CARPETA_GRABACIONES_REALPATH>`realpath $RecordingFolder 2>/dev/null`</CARPETA_GRABACIONES_REALPATH>
	<CARPETA_ARCHIVO>$ARCHIVO_GRABACIONES</CARPETA_ARCHIVO>
	<CARPETA_ARCHIVO_REALPATH>`realpath $ARCHIVO_GRABACIONES 2>/dev/null`</CARPETA_ARCHIVO_REALPATH>
	<CARPETA_VER>$carpeta_ver</CARPETA_VER>
	<CARPETA_CPMV>$carpeta_cpmv</CARPETA_CPMV>"

# Calculo de espacio libre
if [ "$crid_class" = "record" ]; then
	if [ -d $Recordings ]; then
		disk_spaceMb=`df -m $Recordings | tail -1 | awk '{print $4}'`
		disk_spaceGb=$((disk_spaceMb/1024))
		echo "	<SPACE>$disk_spaceMb Mb ($disk_spaceGb Gb ~ $((disk_spaceGb/2)) horas) en $Recordings</SPACE>"
	fi
else
	if [ -d $RecordingFolder ]; then
		disk_spaceMb=`df -m $RecordingFolder | tail -1 | awk '{print $4}'`
		disk_spaceGb=$((disk_spaceMb/1024))
		echo "	<SPACE>$disk_spaceMb Mb ($disk_spaceGb Gb ~ $((disk_spaceGb/2)) horas) en $RecordingFolder</SPACE>"
	fi
fi

# Vaciar lista de ficheros para ordenacion
CachefileTemp=${Cache}/lista-grabaciones.xml.tmp
echo -n "" > $CachefileTemp

# Clase ficheros .crid
CLASS=`awk "BEGIN {print toupper(\"${crid_class}\")}"`
echo "	<${CLASS} now=\"`date +%s`\">"

# Comprobar carpeta, contar nº de ficheros .crid
numCrids=`ls -la $Recordings/*.crid 2>/dev/null | wc -l`
if [ $numCrids -ne 0 ]; then
	# Recorrer ficheros .crid
	for Cridfile in $Recordings/*.crid; do
		# Comprobar cache de fichero crid
		Cachefile=${Cache}/`basename $Cridfile .crid`.refXML
		if [ $Cridfile -nt $Cachefile ]; then
			# Procesar fichero crid
			eval `www-tools crid2var ${Cridfile}`

			# Obtener datos canal (numChannel, cid, chID, chName)
			chID=""
			chName=""
			eval `www-tools infoID ${CRID_cid} ${Cache}/info_channels.txt 2>/dev/null`
			if [ ${#chID} -eq 0 ]; then
				[ ${#chName} -eq 0 ] && chID="---" || chID=${chName}
			fi

			# Grabaciones: Calcular espacio usado y error de fmpg0_end_timestamp
			if [ "$crid_class" = "record" ]; then
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
				du=(`du -ch ${files} 2>/dev/null | tail -1`)

				# Comprobar error de fmpg0_end_timestamp
				[ $fmpg0_end_timestamp -eq 0 ] && error_end_timestamp=1 || error_end_timestamp=0
			fi

			# Volcar datos a fichero cache
			# Cada grabacion va en una sola linea incluyendo campo ORDEN_SERIE
			( [ ${IDserie} -gt 0 ] && IDorden=-2147483648 || IDorden=$IDserie
			echo -n "<ORDEN_SERIE>$IDorden</ORDEN_SERIE><SERIE_ID>$IDserie</SERIE_ID><UTC_TIME>$EPG_start_time</UTC_TIME><CRID_FILE>$Cridfile</CRID_FILE><CH_ID>$chID</CH_ID><TITLE>$Titulo</TITLE><REC_STATE>$Rec_State</REC_STATE><INIT_TIME>$FMT_start_time</INIT_TIME><END_TIME>$FMT_end_time</END_TIME><DURATION>$Duration</DURATION><UTC_END_TIME>$EPG_end_time</UTC_END_TIME><IMPORTANT>$Grabacion_protegida</IMPORTANT><PLAYBACK_TS>$playback_timestamp</PLAYBACK_TS><PIDCID>$CRID_ID</PIDCID><NUM_FMPG>$num_fmpg</NUM_FMPG><FMPG>$fmpg0</FMPG>"

			# Recorrer fragmentos adicionales
			i=1
			while [ $i -lt $num_fmpg ]; do
				# Nombre fragmento
				TMP='$fmpg'${i}
				eval "TMP2=$TMP"
				echo -n "<FMPG${i}>$TMP2</FMPG${i}>"
				# end_timestamp fragmento
				TMP='$fmpg'${i}_end_timestamp
				eval "end_timestamp=$TMP"
				[ $end_timestamp -eq 0 ] && error_end_timestamp=1
				# Siguiente fragmento
				i=$(($i+1))
			done

			echo "<ERROR_END_TIMESTAMP>$error_end_timestamp</ERROR_END_TIMESTAMP><SPACE>$du</SPACE>" ) > $Cachefile
		fi

		# Devolver resultado de cache de fichero crid
		cat $Cachefile >> $CachefileTemp
	done
fi

# Insertar campo <CAMBIO_SERIE> que indica si del registro anterior al actual,
# ha cambiado el identificador de Serie, para luego mostrarlo correctamente,
# diferenciando entre series. Si el orden es por tiempo este campo no se utiliza.
sort -r $CachefileTemp | ins-info-serie.awk -v "cache=${Cache}" -v "orden=${orden}"

# Final clase
echo "	</${CLASS}>"

# Añadir info_series.xml
echo "	<INFO_SERIES>"
cat ${Cache}/info_series.xml
echo "	</INFO_SERIES>"

# Final xml
echo "</M750>"

# Eliminar temporales
rm -f ${CachefileTemp}
