#!/usr/bin/awk -f
# jotabe, (c) Grupo SIESTA, 28-02-2008
#
# Formatear resultado busquedas
# cache		carpeta cache datos

BEGIN {FS="_"; fileAnt=""}

{
	# Obtener datos linea
	if ( split($1,tmp,":") == 2 ) {
		file=tmp[1]
		dateIni=tmp[2]
	}
	if ( split($1,tmp,".") == 3 ) {
		chID=tmp[2]
	}
	pid=$2
	pidcid=$3
	dateFormatIni=$4
	longs=$5
	titulo=$6
	subtitulo=$7
	# Imagen es campo 8 y sucesivos, por si el nombre contiene _
	imagen=$8
	for(i=9;i<=NF;i++)
		imagen=imagen "_" $i

	# Comprobar cambio de canal
	if ( fileAnt != file ) {
		# Completar canal anterior
		if ( fileAnt != "" )
			printf("\t\t</CHANNEL>\n")

		# Obtener datos canal
		command="grep :" chID ": " cache "/info_channels.txt | head -1"
		command | getline mapping
		close(command)
		if ( split(mapping,tmp,":") == 5 ) {
			numChannel=tmp[1]
			cid=tmp[2]
			chName=tmp[4]
		}

		# Datos xml de canal
		printf("\t\t<CHANNEL numChannel=\"%i\" cid=\"%s\" chID=\"%s\" chName=\"%s\" file=\"%s\">\n",numChannel,cid,chID,chName,file)
	}

	# Volcar datos xml programa
	printf("\t\t\t<PROGRAM pid=\"%i\" pidcid=\"%s\" chID=\"%s\">\n",pid,pidcid,chID)
	printf("\t\t\t\t<TITLE>%s</TITLE>\n",titulo)
	printf("\t\t\t\t<SUBTITLE>%s</SUBTITLE>\n",subtitulo)
	printf("\t\t\t\t<IMAGE>%s</IMAGE>\n",imagen)
	printf("\t\t\t\t<LONG>%i</LONG>\n",longs)
	printf("\t\t\t\t<DATE>%s</DATE>\n",dateFormatIni)
	printf("\t\t\t\t<DATE_UTC>%s</DATE_UTC>\n",dateIni)
	printf("\t\t\t</PROGRAM>\n")

	# Actualizar fichero
	fileAnt=file
}

END {
	# Completar canal anterior
	if ( fileAnt != "" )
		printf("\t\t</CHANNEL>\n")
}
