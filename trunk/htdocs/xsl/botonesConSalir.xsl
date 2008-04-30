<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="BARRA_BOTONES">
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr height="64">
			<td class="borderBoton" align="center">
				<a href="javascript:history.back()"           title="Atrás"                         style="text-decoration:none;"><img src="/img/back.gif"         width="32" height="32" border="0"/><br/>Atrás</a>
			</td>
			<td class="borderBoton" align="center">
				<a href="/cgi-bin/sincro/pgmactual"           title="Programa Actual"               style="text-decoration:none;"><img src="/img/pgmactual.gif"    width="32" height="32" border="0"/><br/>Pr.Actual</a>
			</td>
			<td class="borderBoton" align="center">
				<a href="/cgi-bin/sincro/parrilla"            title="Parrilla de programas"         style="text-decoration:none;"><img src="/img/parrilla.gif"     width="32" height="32" border="0"/><br/>Parrilla</a>
			</td>
			<td class="borderBoton" align="center">
				<a href="/cgi-bin/crid/ver-lista-timer"       title="Grabaciones Pendientes"        style="text-decoration:none;"><img src="/img/pendientes.gif"   width="32" height="32" border="0"/><br/>Pendientes</a>
			</td>
			<td class="borderBoton" align="center">
				<a href="/cgi-bin/crid/ver-lista-grabaciones" title="Grabaciones Realizadas"        style="text-decoration:none;"><img src="/img/grabaciones.gif"  width="32" height="32" border="0"/><br/>Grabaciones</a>
			</td>
			<td class="borderBoton" align="center">
				<a href="/cgi-bin/crid/ver-lista-archivo"     title="Archivo de Grabaciones"        style="text-decoration:none;"><img src="/img/archivo.gif"      width="32" height="32" border="0"/><br/>Archivo</a>
			</td>
			<td class="borderBoton" align="center">
				<a href="/cgi-bin/box/osd2tcp"                title="Control OSD"                   style="text-decoration:none;"><img src="/img/osd.gif"          width="32" height="32" border="0"/><br/>OSD</a>
			</td>
			<td class="borderBoton" align="center">
				<a href="/cgi-bin/box/show/var/etc"           title="Editor/Explorador de Archivos" style="text-decoration:none;"><img src="/img/explorador.gif"   width="32" height="32" border="0"/><br/>Explorador</a>
			</td>
			<td class="borderBoton" align="center">
				<a href="/cgi-bin/box/cmd"                    title="Ejecución de comandos Linux"   style="text-decoration:none;"><img src="/img/comandos.gif"     width="32" height="32" border="0"/><br/>Comandos</a>
			</td>
			<td class="borderBoton" align="center">
				<a href="/cgi-bin/box/verTvLive"              title="Ver LiveTV"                    style="text-decoration:none;"><img src="/img/ver_tv.gif"       width="32" height="32" border="0"/><br/>Ver TV</a>
			</td>
			<td class="borderBoton" align="center">
				<a href="/cgi-bin/box/ctl-verTvTS"            title="Ver LiveTV-TimeShift"          style="text-decoration:none;"><img src="/img/ver_tv_ts.gif"    width="32" height="32" border="0"/><br/>Ver TV-TS</a>
			</td>
			<td class="borderBoton" align="center">
				<a href="/cgi-bin/box/ssh"                    title="Conexión SSH"                  style="text-decoration:none;"><img src="/img/ssh.gif"          width="32" height="32" border="0"/><br/>SSH</a>
			</td>
			<td class="borderBoton" align="center">
				<a href="/cgi-bin/box/autores"                title="Autores"                       style="text-decoration:none;"><img src="/img/autores.gif"      width="32" height="32" border="0"/><br/>Autores</a>
			</td>
			<td class="borderBoton" align="center">
				<a href="/cgi-bin/box/configLCK"              title="Configuración LCK"             style="text-decoration:none;"><img src="/img/configLCK.gif"    width="32" height="32" border="0"/><br/>LCK</a>
			</td>
			<td class="borderBoton" align="center">
				<a href="/cgi-bin/box/configSIESTA"           title="Configuración SIESTA"          style="text-decoration:none;"><img src="/img/configSIESTA.gif" width="32" height="32" border="0"/><br/>SIESTA</a>
			</td>
			<td class="borderBoton" align="center">
				<a href="/cgi-bin/box/estado"                 title="Ver Estado"                    style="text-decoration:none;"><img src="/img/estado.gif"       width="32" height="32" border="0"/><br/>Estado</a>
			</td>
			<td class="borderBotonFinal" align="center">
				<a href="/index.html"                         title="Salir"                         style="text-decoration:none;"><img src="/img/salir.gif"        width="32" height="32" border="0"/><br/>Salir</a>
			</td>
		</tr>
	</table>
</xsl:template>

</xsl:stylesheet>
