#!/bin/bash
# (c) Grupo SIESTA, 10-01-2008
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
num_img=0
echo -n "" > $LST_IMG
while read line; do
	if [ ${#line} -ne 0 ]; then
		num_img=$((num_img+1))
		[ ! -s $DIR_IMG/$line ] && echo $line >> $LST_IMG
	fi
done < $LST_IMG.tmp2

# Eliminar temporales
rm -f $LST_IMG.tmp $LST_IMG.tmp2

# Fin del proceso
printf "       Imágenes actuales: %4i\n" "`ls -la $DIR_IMG/*.jpg 2>/dev/null | wc -l`"
printf "  Imágenes en Sincroguía: %4i\n" "$num_img"
printf "    Imágenes a descargar: %4i\n" "`cat $LST_IMG | wc -l`"
echo "`date` Fin listado imágenes de Sincroguía"
