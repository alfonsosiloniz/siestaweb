#!/bin/bash
# pepper, jotabe, (c) Grupo SIESTA, 10-10-2007
#
# Generacion de cache de sincroguía
# $1 Tipo de generacion / Lista de canales
#    full         -> Generacion completa (por defecto)
#    update       -> Actualizacion todos los canales
#    TV3:TV1:...: -> Actualizacion lista de canales (siempre termina con ":")

# Ejecutamos el script con baja prioridad
renice 20 $$ > /dev/null

# Obtener parametros
case $1 in
	full )
		full_cache=1;lst_ch="";;
	update )
		full_cache=0;lst_ch="";;
	*:* )
		full_cache=0;lst_ch=$1;;
	* )
		full_cache=2;lst_ch="";;
esac

# Configurar entorno
source ../cgi-bin/www-setup.shi
LCK_SINCRO=${Cache}/cache.sincro.generating
LOG=${Cache}/cache.sincro.log
ERR=${Cache}/cache.sincro.err
SORT_CHANNELS=${Cache}/sort_channels.txt
horaUTCparrilla=`date +%s`

# Comprobar marca de generacion de cache XML
[ -f ${LCK_SINCRO} ] && exit -1

# Crear marca de generacion de cache XML
touch ${LCK_SINCRO}

# Si en actualizacion no existe horaUTCparrilla.txt se pasa a generacion completa
if [ $full_cache -eq 0 -a ! -f ${Cache}/horaUTCparrilla.txt ]; then
	full_cache=1
	lst_ch=""
fi

# Guardar horaUTCparrilla de generacion de la parrilla
if [ $full_cache -ne 0 ]; then
	echo "$horaUTCparrilla" > ${Cache}/horaUTCparrilla.txt
else
	[ -f ${Cache}/horaUTCparrilla.txt ] && horaUTCparrilla=`cat ${Cache}/horaUTCparrilla.txt`
fi

# Log del proceso
utc_inicio=`date +%s`
if [ $full_cache -ne 0 ]; then
	echo "`date` Inicio generación XML de Sincroguía [host: `hostname`], [Hora UTC parrilla: $horaUTCparrilla]" > $LOG
else
	echo "`date` Inicio actualización XML de Sincroguía [host: `hostname`], [$*]" >> $LOG
fi
echo -n "" > $ERR

# Generar datos de canales
if [ ! -f $SORT_CHANNELS ]; then
	echo "`date` Generación datos de canales (info_channels.txt)" >> $LOG
	source gen-info-canales.shi
fi

# Recorrer lista de canales
if [ -f $SORT_CHANNELS ]; then
	for Sincrofile in `cat $SORT_CHANNELS`; do
		# Obtener identificador de canal
		chID=`echo "$Sincrofile" | cut -d"_" -f2 | cut -d"." -f1`

		# Comprobar si canal esta en la lista de canales a generar
		if [ $full_cache -ne 0 ]; then
			found=1
		else
			if [ ${#lst_ch} -eq 0 ]; then
				found=1
			else
				found=`echo $lst_ch | grep "$chID:" | wc -l`
			fi
		fi

		# Generar cache
		[ $found -eq 1 ] && gc-sincro-ch.sh $Sincrofile $full_cache $horaUTCparrilla >> $LOG 2>> $ERR
	done
else
	echo "`date` Datos de canales no encontrados (${SORT_CHANNELS})" >> $LOG
fi

# Eliminar marca de generacion de cache XML
rm -f ${LCK_SINCRO}

# Descarga de imagenes de sincroguia si full explicito y no venimos de apagado completo
if [ $full_cache -eq 1 -a "Z$DESCARGA_IMG" = "Zsi" -a ! -f /data/.STOP ]; then
	echo "`date` Lanzado proceso de descarga de imágenes de Sincroguía" >> $LOG
	run-http.sh /bin/getsincroimg.sh &
fi

# Log del proceso
utc_final=`date +%s`
tiempo_proceso=`TZ=UTC awk "BEGIN {print strftime( \"%H:%M:%S\", $(($utc_final-$utc_inicio))) }"`
echo "`date` Fin generación XML de Sincroguía [host: `hostname`], Tiempo generación: ${tiempo_proceso}" >> $LOG
