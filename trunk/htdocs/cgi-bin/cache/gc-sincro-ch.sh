#!/bin/bash
# pepper, (c) Grupo SIESTA, 28-03-2007
#
# Genera cache de sincroguía en XML de 1 canal
# $1 Fichero sincroguia (.db)
# $2 horaUTCinicial

# Ejecutamos el script con baja prioridad
renice 20 $$ > /dev/null

# Obtener parametros
chID=`echo $1 | cut -d"_" -f2 | cut -d"." -f1`
if [ "Z$2" != "Z" ]; then
	horaUTCinicial=$2
else
	horaUTCinicial=`date +%s`
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
	# Generar ficheros vacios
	echo -n "" > ${CACHE_FILE}.xml
	echo -n "" > ${CACHE_FILE}.text
	echo -n "" > ${CACHE_FILE}.html

	# Proceso de generacion de ficheros xml y text
	echo -n "`date` Generación db->xml/text de Canal $chID" >> $LOG
	source ./db2xml.shi $1 ${CACHE_FILE}.xml ${CACHE_FILE}.text
	echo " [${NumBytes} bytes leidos]" >> $LOG

	# Proceso de generacion de fichero html
	if [ $horaUTCinicial -ge 0 ]; then
		echo "`date` Generación text->html de Canal $chID" >> $LOG
		source ./text2html.shi $1 ${CACHE_FILE}.text ${CACHE_FILE}.html ${horaUTCinicial}
	fi
fi

# Eliminar marca de generacion de cache de canal
rm -f ${LCK_FILE}
