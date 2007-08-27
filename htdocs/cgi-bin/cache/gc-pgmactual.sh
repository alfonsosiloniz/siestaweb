#!/bin/bash
# pepper, (c) Grupo SIESTA, 03-04-2007
#
# Genera fichero cache de programa actual

# Ejecutamos el script con baja prioridad
renice 20 $$ > /dev/null

# Configurar entorno
source ../www-setup.shi
LCK_SINCRO=${Cache}/cache.sincro.generating
LCK_PGMACTUAL=${Cache}/cache.pgmactual.generating
LOG=${Cache}/cache.pgmactual.log
CACHE_FILE=${Cache}/cache.pgmactual.xml

# Comprobar marcas de generacion de cache XML y programa actual
[ -f ${LCK_SINCRO} -o -f ${LCK_PGMACTUAL} ] && exit -1

# Crear marca de generacion de programa actual
touch ${LCK_PGMACTUAL}

# Log del proceso
echo "`date` Inicio generación XML de Programa Actual [host: `hostname`]" > $LOG

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
			# Obtener datos de canal de fichero .text
			echo "`date` Datos canal [$chID] -> ${CHANNEL_CACHE}.text" >> $LOG
			source ./pgact-text.shi $Sincrofile ${CHANNEL_CACHE}.text ${CACHE_FILE}.temp
		fi
	fi
done

# Pasar de fichero temporal a fichero definitivo
touch ${CACHE_FILE}.generating
rm -f ${CACHE_FILE}
mv ${CACHE_FILE}.temp ${CACHE_FILE}
rm -f ${CACHE_FILE}.generating

# Log del proceso
echo "`date` Fin generación XML de Programa Actual [host: `hostname`]" >> $LOG

# Eliminar marca de generacion de programa actual
rm -f ${LCK_PGMACTUAL}
