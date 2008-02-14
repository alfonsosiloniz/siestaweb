#!/usr/bin/awk -f
# jotabe, (c) Grupo SIESTA, 13-02-2008
#
# Formatear horas de actualizacion de sincroguia

BEGIN {col=1}

{
	if ( col++ == 1 )
		printf("<tr align=\"center\" style=\"font-family:courier new; font-size:12px;\">\n")

	printf("\t<td>%s</td><td>%s</td>\n",$2,strftime("%d/%m/%Y %H:%M %Z",$1))

	if ( col > 3 ) {
		col=1
		printf("</tr>\n")
	}
}
