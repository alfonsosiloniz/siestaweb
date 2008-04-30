#!/usr/bin/awk -f
# jotabe, (c) Grupo SIESTA, 06-03-2008
#
# Formatear resultado busquedas

BEGIN {sint=0; lin_bloque=2}

{
	# Saltar primera linea
	if ( FNR > 1 ) {
		# Comprobar linea comienzo bloque, contiene nº grabaciones sintonizador
		if ( FNR == lin_bloque ) {
			# Actualizar datos sintonizador, nº grabaciones y linea comienzo bloque
			sint++
			nRecs=$1
			lin_bloque=FNR+nRecs+2

			# Comprobar tipo de encabezado necesario
			if ( sint <= 3 ) {
				# Linea separador
				printf("\t\t\t\t\t\t<tr><td colspan=\"6\" class=\"txtNegrita\" height=\"4\"></td></tr>\n")
				printf("\t\t\t\t\t\t<tr><td colspan=\"6\" class=\"txtNegrita\" height=\"1\" bgcolor=\"#000000\"></td></tr>\n")
				printf("\t\t\t\t\t\t<tr><td colspan=\"6\" class=\"txtNegrita\" height=\"4\"></td></tr>\n")
				if ( sint < 3 ) {
					# Encabezado sintonizador
					printf("\t\t\t\t\t\t<tr><td colspan=\"6\" class=\"txtNegrita\">Sintonizador %i (%i grabaciones)</td></tr>\n",sint,nRecs)
					printf("\t\t\t\t\t\t<tr><td colspan=\"6\" class=\"txtNegrita\" height=\"4\"></td></tr>\n")
				} else {
					# Encabezado detalle
					printf("\t\t\t\t\t\t<tr><td colspan=\"6\" class=\"txtGrande\">Detalle Grabaciones (%i grabaciones)</td></tr>\n",nRecs)
					printf("\t\t\t\t\t\t<tr><td colspan=\"6\" class=\"txtNegrita\" height=\"4\"></td></tr>\n")
					printf("\t\t\t\t\t\t<tr><td colspan=\"6\" class=\"txtNegrita\" height=\"4\"></td></tr>\n")
					printf("\t\t\t\t\t</table>\n")
					printf("\t\t\t\t\t<table width=\"100%%\" border=\"1\" bordercolor=\"#000000\" cellpadding=\"2\" cellspacing=\"0\" bgcolor=\"#FFEEE6\">\n")
					printf("\t\t\t\t\t\t<tr class=\"txtNegrita\">\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">ID Grab</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">X</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">ID Programa</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">ID Serie</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">Pri.</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">Inicio</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">Final</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">Guarda Ini</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">Guarda Fin</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">X</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">X</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">X</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">X</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">X</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">X</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">X</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">X</td>\n")
					printf("\t\t\t\t\t\t\t<td align=\"center\">Sint.</td>\n")
					printf("\t\t\t\t\t\t</tr>\n")
				}
			}
		} else {
			# Linea de datos
			if ( $0 != "" ) {
				# Comprobar tipo de linea de datos
				if ( sint < 3 ) {
					# Linea sintonizador
					printf("\t\t\t\t\t\t<tr class=\"txtNormal\">\n")
					printf("\t\t\t\t\t\t\t<td>%s</td><td>%s</td><td align=\"center\">%i</td><td align=\"center\">%i</td><td align=\"center\">%i</td><td align=\"center\">%i</td>\n", \
						strftime("%d.%m.%y %H:%M %Z",$1), \
						strftime("%d.%m.%y %H:%M %Z",$2), \
						$3/60,$4/60,$5,$6)
					printf("\t\t\t\t\t\t</tr>\n")
				} else {
					# Linea detalle
					printf("\t\t\t\t\t\t<tr class=\"txtNormal\">\n")
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%i</td>\n",$1)
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%i</td>\n",$2)
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%s</td>\n",$3)
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%i</td>\n",$4)
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%i</td>\n",$5)
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%s</td>\n",strftime("%d.%m.%y %H:%M %Z",$6))
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%s</td>\n",strftime("%d.%m.%y %H:%M %Z",$7))
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%i</td>\n",$8/60)
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%i</td>\n",$9/60)
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%i</td>\n",$10)
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%i</td>\n",$11)
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%i</td>\n",$12)
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%i</td>\n",$13)
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%i</td>\n",$14)
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%i</td>\n",$15)
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%i</td>\n",$16)
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%i</td>\n",$17)
					printf("\t\t\t\t\t\t\t<td nowrap align=\"center\">%i</td>\n",$18+1)
					printf("\t\t\t\t\t\t</tr>\n")
				}
			}
		}
	}
}
