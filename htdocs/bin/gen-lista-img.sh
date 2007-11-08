#!/bin/bash
# (c) Grupo SIESTA, 24-07-2007
#
# Genera lista de imágenes para descargar desde internet
# log en salida estandar
# errores en salida error

# Ejecutamos el script con baja prioridad
renice 20 $$ > /dev/null

# Obtener parametros
if [ $# -ne 3 ]; then
	echo "Uso: $0 lista_imagenes dir_imagenes dir_cache"
	exit -1
fi
LST_IMG=`echo $1 | sed 's/\/$//'`
DIR_IMG=`echo $2 | sed 's/\/$//'`
DIR_CACHE=`echo $3 | sed 's/\/$//'`

# Log del proceso
echo "`date` Inicio listado imágenes de Sincroguía"

# Recorrer ficheros .text
echo -n "" > $LST_IMG.tmp
for textfile in $DIR_CACHE/*.text; do
    chID=`echo $textfile | cut -d"." -f2`
	printf "`date` Canal [%3s]: Fichero datos -> ${textfile}\n" "$chID" 
    cat $textfile | cut -d"_" -f8- >> $LST_IMG.tmp
done

# Ordenamos el fichero de imagenes para eliminar imágenes repetidas
sort -u $LST_IMG.tmp > $LST_IMG.tmp2

# Eliminamos lineas vacias y lineas con imágen ya descargada
echo -n "" > $LST_IMG
while read line; do
	if [ ${#line} -ne 0 ]; then
		if [ ! -s $DIR_IMG/$line ]; then
			echo $line >> $LST_IMG
		fi
	fi
done < $LST_IMG.tmp2

# Eliminar temporales
rm -f $LST_IMG.tmp $LST_IMG.tmp2

# Fin del proceso
echo "`date` Fin listado imágenes de Sincroguía (`cat $LST_IMG | wc -l` imágenes)"
