#!/bin/bash
# pepper, (c) grupo SIESTA, 24-07-2007
#
# Script que realiza la comprobacion de una particion del HD

# Configurar entorno
source ../cgi-bin/www-setup.shi
source fweb.shi
partition=$1
fstype=$2
LOG=/var/log/checkdisk.log
ERR=/var/log/checkdisk.err

# Log del proceso
echo "`date` Iniciando el script de chequeo de la particion $partition con tipo $fstype" > $LOG
echo -n "" > $ERR

# Nos guardamos el estado inicial del giga por si está apagado, apagarlo al final
get_modo_video
echo "`date` El M750 está <b>${ModoVideo}</b>, y así lo dejaremos al acabar el chequeo" >> $LOG

if [ "$ModoVideo" = "Encendido" ]; then
	/data/scripts/irsim.sh POWER
	echo "`date` Apagando el gigaset..." >> $LOG
	(sleep 4 ; /usr/bin/txt2osd -x -1 -y -1 -s 20 -b 0x9F000000 -f 0xFFFFFFFF -d 4000 "Apagando para iniciar chequeo") &
	sleep 20
fi

# Comprobar particion no esta montada
PART_MOUNTED=`grep $partition /proc/mounts | wc -l`
cont=0
while [ ${PART_MOUNTED} -gt 0 -a $cont -lt 10 ]; do
	echo "`date` Particion $1 montada. La particion debe estar desmontada para poder ejecutar la comprobacion. Esperamos otros 5 segundos..." >> $LOG
	# Si el gigaset no ha desmontado automaticamente la unidad con el apagado rapido, la intentamos desmontar nosotros.
	umount $partition >> $LOG 2>> $ERR
	sleep 5
	cont=$((cont+1))
	PART_MOUNTED=`grep $partition /proc/mounts | wc -l`
done

if [ ${PART_MOUNTED} -eq 0 ]; then
	if [ "${fstype}" = "ext2" -o "${fstype}" = "ext3" ]; then
		echo "`date` Iniciando chequeo del disco: e2fsck -y -v $partition" >> $LOG
		e2fsck -y -v $partition >> $LOG 2>> $ERR
	else
		echo "`date` Iniciando chequeo del disco: dosfsck -a -v -w $partition" >> $LOG
		dosfsck -a -v -w $partition >> $LOG 2>> $ERR
	fi
	echo "`date` Chequeo del disco finalizado" >> $LOG
else
	echo "`date` No se ha podido desmontar la particion. Abortamos el proceso de chequeo." >> $LOG
fi

if [ "$ModoVideo" = "Encendido" ]; then
	/data/scripts/irsim.sh POWER
	echo "`date` Encendiendo el gigaset..." >> $LOG
	sleep 5
	/usr/bin/txt2osd -x -1 -y -1 -s 20 -b 0x9F000000 -f 0xFFFFFFFF -d 4000 "Chequeo de disco finalizado"
fi
