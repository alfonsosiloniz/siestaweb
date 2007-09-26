#!/bin/bash
# (c) Grupo SIESTA, 24-07-2007
#
# Descarga de imágenes desde internet
# log en salida estandar
# errores en salida error

# Ejecutamos el script con baja prioridad
renice 20 $$ > /dev/null

# Obtener parametros
if [ $# -ne 2 ] ; then
	echo "Uso: $0 lista_imagenes dir_imagenes"
	exit -1
fi
LST_IMG=`echo $1 | sed 's/\/$//'`
DIR_IMG=`echo $2 | sed 's/\/$//'`

# Configurar entorno
WWW_INOUT="www.inout.tv"

# Comprobar lista de imágenes
if [ ! -s $LST_IMG ]; then
	echo "Lista de imágenes ($LST_IMG) vacia"
	exit -2
else
	# Comprobar carpeta de descarga
	if [ ! -d $DIR_IMG ]; then
		echo "No existe la carpeta de descarga de imágenes ($DIR_IMG)"
		exit -3
	else
		# Resolver direccion ip
		echo "`date` Resolviendo la IP del servidor $WWW_INOUT"
		ping -c 1 $WWW_INOUT > $LST_IMG.ping

		# Comprobar resultado ping
		if [ `cat $LST_IMG.ping | wc -l` -eq 0 ]; then
			# ping sin resultado, no tenemos direccion ip
			no_ip=1
		else
			# ping correcto, extraer ip
			ipInOut=`cat $LST_IMG.ping | head -1 | cut -d"(" -f2 | cut -d")" -f1`
			no_ip=`echo "$ipInOut" | grep -i "unknown host" | wc -l`
		fi

		# Eliminar temporales
		rm -f $LST_IMG.ping

		# Comprobar resultado de ip
		if [ $no_ip -ne 0 ]; then
			echo "`date` No se ha podido resolver la IP del servidor www.inout.tv... Abortamos el proceso"
			exit -4
		else
			echo "`date` Servidor www.inout.tv, <b>IP=[$ipInOut]</b>"

			# Recorrer lista de imágenes
			URL_INOUT=http://$ipInOut/fotos
			while read line; do
				# Comprobar linea
				if [ ${#line} -ne 0 ]; then
					# Comprobar si ya existe
					if [ -s $DIR_IMG/$line ] ; then
						echo "La imágen $DIR_IMG/$line ya existe en el disco. No la descargamos."
					else
						# Descargar imágen
						echo -n "wget -P $DIR_IMG $URL_INOUT/$line -> "
						wget -q -P $DIR_IMG $URL_INOUT/$line
						# Comprobar descarga
						if [ -s $DIR_IMG/$line ]; then
							echo "OK"
						else
							echo "ERROR, imágen borrada"
							rm -f $DIR_IMG/$line
						fi
					fi
				fi
			done < $LST_IMG

			# Mensaje de final
			echo "`date` Fin descarga de imágenes de Sincroguía"
		fi
	fi
fi
