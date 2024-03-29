#!/usr/bin/awk -f
# Lemmi @ m740.info/forum, 2005-08-22 -> GPL
# jotabe, (c) Grupo SIESTA, 26-02-2008
#
# Formatear resultdo ls -la
# nc_file	n� campo que contiene el nombre de fichero
# col_file	n� columna comienzo busqueda nombre de fichero
# uri		url completa de carpeta a mostrar, incluye script y path

# Inicializar variables
# {nc_file=9; col_file=42} para PC
# {nc_file=9; col_file=57} para M750
{img="unknown"; idx=nc_file}

# Comprobar tipo fichero
$1 ~ /^l/		{img="link"}
$1 ~ /^d/		{img="dir"}
$1 ~ /^b/		{img="block-dev"; idx=nc_file+1}
$1 ~ /^c/		{img="char-dev"; idx=nc_file+1}
$idx ~ /.txt$/	{img="text"}
$idx ~ /.ini$/	{img="text"}
$idx == ".."	{img="dirup"}

{
	# Separar info y nombre fichero
	name=substr($0,col_file)
	pos=index(name,$idx)+col_file-1
	info=substr($0,1,pos-1)
	name=substr($0,pos)

	# Comprobar icono enlace
	if ( img == "link" ) {
		pos=index(name," -> ")
		if ( pos > 0 ) {
			n1 = substr(name,1,pos-1)
			n2 = substr(name,pos+4)
			# Icono borrar enlace
			printf("<a title=\"Eliminar enlace %s\" href=\"javascript:ConfirmarBorradoURL('el enlace \\'%s\\'', '%s/%s?delete')\"><img src=\"/img/icon-borrar.png\" border=0></a> ",name,name,uri,n1)
			# Icono
			printf("<img src=\"/img/%s.png\" title=\"enlace\"> ",img)
			# Info, enlace y fichero
			printf("%s<a href=\"%s/%s\">%s</a> -> <a href=\"%s/%s\">%s</a>\n",info,uri,n1,n1,ENVIRON["SCRIPT_NAME"],n2,n2)
		}
	# Comprobar icono texto/desconocido
	} else if ( img == "text" || img == "unknown" ) {
		# Icono borrar
		printf("<a title=\"Eliminar %s\" href=\"javascript:ConfirmarBorradoURL('\\'%s\\'', '%s/%s?delete')\"><img src=\"/img/icon-borrar.png\" border=0></a> ",name,name,uri,name)
		# Icono, mostrar envio
		printf("<a title=\"Abrir/Descargar %s\" href=\"%s/%s?send\"><img src=\"/img/%s.png\" border=0></a> ",name,uri,name,img)
		# Info y fichero
		printf("%s<a href=\"%s/%s\">%s</a>\n",info,uri,name,name)
	# Directorio o dispositivo
	} else {
		# Icono borrar
		printf("<a title=\"Eliminar %s\" href=\"javascript:ConfirmarBorradoURL('\\'%s\\'', '%s/%s?delete')\"><img src=\"/img/icon-borrar.png\" border=0></a> ",name,name,uri,name)
		# Icono, no mostrar envio
		printf("<a title=\"Abrir %s\" href=\"%s/%s\"><img src=\"/img/%s.png\" border=0></a> ",name,uri,name,img)
		# Info y fichero
		printf("%s<a href=\"%s/%s\">%s</a>\n",info,uri,name,name)
	}
}
