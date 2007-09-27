#!/bin/bash
# pepper, jotabe, (c) Grupo SIESTA, 26-09-2007
#
# Generacion de cache de todos los canales
# $1 Lista opcional de canales a actualizar (formato TV3:TV1:...: / siempre termina con ":")
# Sin parametro se actualizan todos los canales

# Ejecutamos el script con baja prioridad
renice 20 $$ > /dev/null

# Obtener parametros
numParams=$#
params=$1

# Configurar entorno
source ../www-setup.shi
LCK_SINCRO=${Cache}/cache.sincro.generating
LCK_PGMACTUAL=${Cache}/cache.pgmactual.generating
LOG=${Cache}/cache.sincro.log
ERR=${Cache}/cache.sincro.err
horaUTCparrilla=`date +%s`

# Comprobar marca de generacion de cache XML
[ -f ${LCK_SINCRO} ] && exit -1

# Crear marca de generacion de cache XML
touch ${LCK_SINCRO}

# Guardar horaUTCparrilla de generacion de la parrilla
if [ $numParams -eq 0 ]; then
	echo "$horaUTCparrilla" > ${Cache}/horaUTCparrilla.txt
else
	if [ -f ${Cache}/horaUTCparrilla.txt ]; then
		horaUTCparrilla=`cat ${Cache}/horaUTCparrilla.txt`
	fi
fi

# Log del proceso
utc_inicio=`date +%s`
echo "`date` Inicio generación XML de Sincroguía [host: `hostname`], [Hora UTC parrilla: $horaUTCparrilla]" > $LOG
echo -n "" > $ERR

# Obtenemos lista de canales
source gen-lista-canales.shi

# Recorremos lista de canales
for Sincrofile in $ListaCanales; do
	# Obtener identificador de canal
	chID=`echo "$Sincrofile" | cut -d"_" -f2 | cut -d"." -f1`

	# Comprobar si canal esta en la lista de canales a generar
	found=1
	[ $numParams -eq 1 ] && found=`echo $params | grep "$chID:" | wc -l`

	# Generar cache
	[ $found -eq 1 ] && ./gc-sincro-ch.sh $Sincrofile $horaUTCparrilla >> $LOG 2>> $ERR
done

# Eliminar marcas de generacion de cache XML
rm -f ${LCK_SINCRO}
rm -f ${LCK_PGMACTUAL}

# Log del proceso
utc_final=`date +%s`
tiempo_proceso=`TZ=UTC awk "BEGIN {print strftime( \"%H:%M:%S\", $(($utc_final-$utc_inicio))) }"`
echo "`date` Fin generación XML de Sincroguía [host: `hostname`], Tiempo generación: ${tiempo_proceso}" >> $LOG
