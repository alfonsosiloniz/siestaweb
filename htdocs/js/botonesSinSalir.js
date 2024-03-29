// Gestion de barra de botones
// jotabe, (c) Grupo SIESTA, 25-07-2007

//-------------------------------------------------
// Funcion para colocar 1 boton
//-------------------------------------------------
function poner_boton(sNombre, sImagen, sToolTip, sLink, sBotonFinal) {
	if ( sBotonFinal == "si" )
		document.write('<td class="borderBotonFinal" align="center">');
	else
		document.write('<td class="borderBoton" align="center">');
	document.write('<a href="' + sLink + '" title="' + sToolTip + '" style="text-decoration:none;">');
	document.write('<img src="' + sImagen + '" width="32" height="32" border="0">');
	document.write('<br>' + sNombre + '</a></td>');
}

//-------------------------------------------------
// Funcion que muestra el menu de botones
//-------------------------------------------------
function barra_botones() {
	document.write('<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center"><tr height="64">');
	poner_boton("Atr�s",      "/img/back.gif",        "Atr�s",                        "javascript:history.back()"          );
	poner_boton("Pr.Actual",  "/img/pgmactual.gif",   "Programa Actual",              "/cgi-bin/sincro/pgmactual"          );
	poner_boton("Parrilla",   "/img/parrilla.gif",    "Parrilla de programas",        "/cgi-bin/sincro/parrilla"           );
	poner_boton("Pendientes", "/img/pendientes.gif",  "Grabaciones Pendientes",       "/cgi-bin/crid/ver-lista-timer"      );
	poner_boton("Grabaciones","/img/grabaciones.gif", "Grabaciones Realizadas",       "/cgi-bin/crid/ver-lista-grabaciones");
	poner_boton("Archivo",    "/img/archivo.gif",     "Archivo de Grabaciones",       "/cgi-bin/crid/ver-lista-archivo"    );
	poner_boton("OSD",        "/img/osd.gif",         "Control OSD",                  "/cgi-bin/box/osd2tcp"               );
	poner_boton("Explorador", "/img/explorador.gif",  "Editor/Explorador de Archivos","/cgi-bin/box/show/var/etc"          );
	poner_boton("Comandos",   "/img/comandos.gif",    "Ejecuci�n de comandos Linux",  "/cgi-bin/box/cmd"                   );
	poner_boton("Ver TV",     "/img/ver_tv.gif",      "Ver LiveTV",                   "/cgi-bin/box/verTvLive"             );
	poner_boton("Ver TV-TS",  "/img/ver_tv_ts.gif",   "Ver LiveTV-TimeShift",         "/cgi-bin/box/ctl-verTvTS"           );
	poner_boton("SSH",        "/img/ssh.gif",         "Conexi�n SSH",                 "/cgi-bin/box/ssh"                   );
	poner_boton("Autores",    "/img/autores.gif",     "Autores",                      "/cgi-bin/box/autores"               );
	poner_boton("LCK",        "/img/configLCK.gif",   "Configuraci�n LCK",            "/cgi-bin/box/configLCK"             );
	poner_boton("SIESTA",     "/img/configSIESTA.gif","Configuraci�n SIESTA",         "/cgi-bin/box/configSIESTA"          );
	poner_boton("Estado",     "/img/estado.gif",      "Ver Estado",                   "/cgi-bin/box/estado"           ,"si");
	document.write('</tr></table>');
}

//-------------------------------------------------
