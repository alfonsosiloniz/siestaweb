#!/bin/bash
# pepper, (c) grupo SIESTA, 10-01-2008
#
# Listado y descarga de todas las imagenes de la sincro a la carpeta de grabaciones

# Ejecutamos el script con baja prioridad
renice 20 $$ > /dev/null

# Configurar entorno
source ../cgi-bin/www-setup.shi
source fweb.shi
LST=/tmp/images.txt
LOG=/tmp/getsincroimg.log
ERR=/tmp/getsincroimg.err

# Log del proceso
utc_inicio=`date +%s`
echo "`date` Inicio proceso descarga de imágenes de Sincroguía [host: `hostname`]" > $LOG
echo -n "" > $ERR

# Nos guardamos el estado inicial del giga por si está apagado, apagarlo al final
get_modo_video
echo "`date` El M750 está <b>${ModoVideo}</b>, y así lo dejaremos al acabar la descarga" >> $LOG

# Gestionar estado gigaset
if [ "$ModoVideo" = "Apagado" ]; then
	/data/scripts/irsim.sh POWER
	echo "`date` Encendiendo el gigaset..." >> $LOG
	sleep 20
fi

# Obtenemos carpeta de imágenes
RecordingFolder=`sed -n -e "/DeviceRecordingFolder/ s/D.* *\(.pvr.*\)/\1/p" /var/etc/settings.txt`
if [ -d $RecordingFolder/EPG ]; then
	# Generar lista de imágenes
	gen-lista-img.sh $LST $RecordingFolder/EPG $Cache >> $LOG 2>>$ERR

	# Descargar lista de imágenes
	get-lista-img.sh $LST $RecordingFolder/EPG >> $LOG 2>>$ERR

	# Mostrar numero imagenes finales
	printf "        Imágenes finales: %4i\n" "`ls -la $RecordingFolder/EPG/*.jpg | wc -l`" >> $LOG 2>>$ERR
fi

# Gestionar estado gigaset
if [ "$ModoVideo" = "Apagado" ]; then
	/data/scripts/irsim.sh POWER
	echo "`date` Apagando el gigaset..." >> $LOG
fi

# Log del proceso
utc_final=`date +%s`
tiempo_proceso=`TZ=UTC awk "BEGIN {print strftime( \"%H:%M:%S\", $(($utc_final-$utc_inicio))) }"`
echo "`date` Fin proceso descarga de imágenes de Sincroguía, Tiempo proceso descarga: ${tiempo_proceso}" >> $LOG
