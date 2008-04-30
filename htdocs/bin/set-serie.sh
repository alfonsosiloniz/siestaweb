#!/bin/bash
# (c) Grupo SIESTA, 25-04-2008
#
# Asignar identificador de serie a grabacion

# Obtener parametros
if [ $# -ne 2 ]; then
	echo "Uso: $0 fichero_crid id_serie"
	exit -1
fi
fileCRID=$1
new_IDserie=$2

# Comprobar fichero
if [ ! -f $fileCRID ]; then
	echo "Fichero ${fileCRID} no encontrado"
	exit -2
else
	# Procesar fichero crid
	eval "`www-tools crid2var ${fileCRID} 'export'`"
	Titulo=\"${Titulo}\"
	EPG_short=\"${EPG_short}\"
	EPG_long=\"${EPG_long}\"

	# Nueva serie
	IDserie=${new_IDserie}

	# Comprobar IDserie/Rec_Type
	if [ ${IDserie} -lt 0 ]; then
		# IDserie < 0 -> Rec_Type=4,8 (Sincroguia en serie,Timer en serie)
		[ ${Rec_Type} -ne 4 -a ${Rec_Type} -ne 8 ] && Rec_Type=4
	elif [ ${IDserie} -eq 0 ]; then
		# IDserie = 0 -> Rec_Type=1,2,32 (Sincroguia,Timer,Manual)
		[ ${Rec_Type} -ne 1 -a ${Rec_Type} -ne 2 -a ${Rec_Type} -ne 32 ] && Rec_Type=1
	else
		# IDserie > 0 -> Rec_Type=1 (Sincroguia)
		Rec_Type=1
	fi

	# Modificar CRID_pid para refrescar en lista de grabaciones
	CRID_pid=1`cat /dev/urandom | tr -dc 0-9 | head -c9`

	# Guardar fichero y resultado
	www-tools var2crid ${fileCRID}.tmp
	if [ $? -ne 0 ]; then
		rm -f ${fileCRID}.tmp
		echo "Se ha producido un error al guardar el fichero de grabación ${fileCRID}"
	else
		mv -f ${fileCRID}.tmp ${fileCRID}
		echo "Asignado IDserie=${IDserie} y Rec_Type=${Rec_Type} a fichero ${fileCRID}"
	fi

# 	# Insertar Rec_Type
# 	TMP=`printf "\\%03o\\%03o\\%03o\\%03o" $((Rec_Type>>24&255)) $((Rec_Type>>16&255)) $((Rec_Type>>8&255)) $((Rec_Type&255))`
# 	printf ${TMP} | dd of=${fileCRID} bs=1 count=4 seek=36 conv=notrunc 2>/dev/null
# 
# 	# Insertar IDserie
# 	TMP=`printf "\\%03o\\%03o\\%03o\\%03o" $((IDserie>>24&255)) $((IDserie>>16&255)) $((IDserie>>8&255)) $((IDserie&255))`
# 	printf ${TMP} | dd of=${fileCRID} bs=1 count=4 seek=40 conv=notrunc 2>/dev/null
fi
