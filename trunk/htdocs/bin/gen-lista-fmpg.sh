#!/bin/bash
# (c) Grupo SIESTA, 31-10-2007
#
# Genera lista de ficheros fmpg sin utilizar
# log en salida estandar
# errores en salida error

# Ejecutamos el script con baja prioridad
# renice 20 $$ > /dev/null

# Obtener parametros
if [ $# -ne 2 ] ; then
	echo "Uso: $0 dir_grabaciones lista_ficheros"
	exit -1
fi
DIR=`echo $1 | sed 's/\/$//'`
LST=`echo $2 | sed 's/\/$//'`

# Log del proceso
echo "`date` Inicio listado ficheros de video sin usar"

# Obtener lista de todos los ficheros fmpg
ls $DIR/*.fmpg > $LST

# Recorrer ficheros .crid
for Cridfile in $DIR/*.crid; do
	# Procesar fichero crid
	eval `./www-tools crid2var ${Cridfile}`
	echo "Fichero: `basename ${Cridfile}` -> $Titulo ($num_fmpg)"

	# Nombres fragmentos
	i=0
	while [ $i -lt $num_fmpg ]; do
		# Nombre fragmento
		TMP='$fmpg'${i}
		eval "TMP2=$TMP"

		# Quitar fmpg
		grep -v $TMP2 $LST > $LST.tmp
		mv -f $LST.tmp $LST

		# Siguiente fragmento
		i=$(($i+1))
	done
done

# Calcular espacio usado en grabaciones
files=""
for FMPGfile in `cat $LST`; do
	files="${files} ${FMPGfile}*"
done
du=(`du -ch ${files} | tail -1`)

# Fin del proceso
echo "`date` Fin listado ficheros de video sin usar (`cat $LST | wc -l` ficheros, $du)"

cat $LST
# rm -f $LST