#!/bin/bash
# (c) Grupo SIESTA, 27-04-2008
#
# Copiar fichero con medición de tiempo

# Obtener parametros
if [ $# -ne 2 ]; then
	echo "Uso: $0 fichero dir_destino"
	exit -1
fi
file=$1
DIR_DESTINO=$2

# Comprobar fichero y destino
if [ ! -f $file ]; then
	echo "Fichero ${file} no encontrado"
	exit -2
elif [ ! -d $DIR_DESTINO ]; then
	echo "Destino ${DIR_DESTINO} no encontrado"
	exit -3
else
	# Log del proceso
	echo "Copiando $file a $DIR_DESTINO"

	# Copiar fichero
	inicio=`date +%s`
	cp -f $file $DIR_DESTINO
	final=`date +%s`

	# Calculos
	secs=$((final-inicio))
	du=(`du -ch ${file} | tail -1`)
	dunum=(`du -k ${file} | tail -1`)

	# Resultado
	echo -n "  <i>Fichero `basename $file` copiado: $du en $secs segundos"
	[ $secs -gt 0 ] && echo -n " --> $((dunum/secs)) KBytes/sec"
	echo ".</i>"
fi
