#!/bin/bash
# jotabe, (c) Grupo SIESTA, 16-04-2008
#
# Genera lista de ficheros crid que incluyen un fichero fmpg
# $1 Carpeta de grabaciones
# $2 Fichero fmpg

# Comprobar parametros
if [ $# -eq 2 ]; then
	DIR=`echo $1 | sed 's/\/$//'`
	FMPG=`basename $2`

	# Metodo aproximado
	# Buscar nombre fmpg dentro de ficheros .crid
	grep -l "${FMPG}" $DIR/*.crid

	# Metodo exacto
	# Recorrer ficheros .crid, extraer nombres fragmentos y comprobar
# 	# Comprobar nº ficheros .crid
# 	numCrids=`ls -la $DIR/*.crid 2>/dev/null | wc -l`
# 	if [ $numCrids -ne 0 ]; then
# 		# Recorrer ficheros .crid
# 		for Cridfile in $DIR/*.crid; do
# 			# Procesar fichero crid
# 			eval `www-tools crid2var ${Cridfile}`
# 
# 			# Nombres fragmentos
# 			i=0
# 			while [ $i -lt $num_fmpg ]; do
# 				# Nombre fragmento
# 				TMP='$fmpg'${i}
# 				eval "fileFMPG=$TMP"
# 
# 				# Comprobar fichero fmpg
# 				[ "Z$FMPG" = "Z$fileFMPG" ] && echo ${Cridfile}
# 
# 				# Siguiente fragmento
# 				i=$(($i+1))
# 			done
# 		done
# 	fi
fi
