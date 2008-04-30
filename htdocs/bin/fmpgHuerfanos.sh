#!/bin/bash
# (c) Grupo SIESTA, 08-11-2007
#
# Genera lista de ficheros fmpg sin utilizar
# $1 Carpeta de grabaciones

# Ejecutamos el script con baja prioridad
# renice 20 $$ > /dev/null

# Comprobar parametros
if [ $# -eq 1 ]; then
	DIR=`echo $1 | sed 's/\/$//'`
	LST=/tmp/fmpg-huerfanos-$$.txt

	# Obtener lista de todos los ficheros fmpg
	ls $DIR/*.fmpg  2>/dev/null > $LST

	# Comprobar nº ficheros .crid
	numCrids=`ls -la $DIR/*.crid 2>/dev/null | wc -l`
	if [ $numCrids -ne 0 ]; then
		# Recorrer ficheros .crid
		for Cridfile in $DIR/*.crid; do
			# Procesar fichero crid
			eval `www-tools crid2var ${Cridfile}`

			# Nombres fragmentos
			i=0
			while [ $i -lt $num_fmpg ]; do
				# Nombre fragmento
				TMP='$fmpg'${i}
				eval "fileFMPG=$TMP"

				# Quitar fmpg
				grep -v $fileFMPG $LST > $LST.tmp
				mv -f $LST.tmp $LST

				# Siguiente fragmento
				i=$(($i+1))
			done
		done
	fi

	# Resultado
	cat $LST

	# Eliminar ficheros temporales
	rm -f $LST
fi
