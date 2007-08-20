// Funcion que muestra el menu de botones
var botones = '<br/><table width="98%" border="0" cellspacing="0" cellpadding="0" align="center"><tr height="64">';
botones += '<td class="borderBotones" align="center"><a href="javascript:history.back()" style="text-decoration:none;"><img src="/sincro/img/back.gif" width="32" height="32" border="0" alt="Atr&aacute;s"/><br/>Atr&aacute;s</a></td>';
botones += '<td class="borderBotones" align="center"><a href="/cgi-bin/sincro/pgmactualXML" style="text-decoration:none;"><img src="/sincro/img/inicio.gif" width="32" height="32" border="0" alt="Ir a la p&aacute;gina de inicio"/><br/>Inicio</a></td>';
botones += '<td class="borderBotones" align="center"><a href="/cgi-bin/sincro/parrilla" style="text-decoration:none;"><img src="/sincro/img/parrilla.gif" width="32" height="32" border="0" alt="Parrilla de programas"/><br/>Parrilla</a></td>';
botones += '<td class="borderBotones" align="center"><a href="/cgi-bin/crid/timerXML" style="text-decoration:none;"><img src="/sincro/img/grabaciones_pendientes.gif" width="32" height="32" border="0" alt="Grabaciones Pendientes"/><br/>Pendientes</a> </td>';
botones += '<td class="borderBotones" align="center"><a href="/cgi-bin/crid/videoXML" style="text-decoration:none;"><img src="/sincro/img/grabaciones.gif" width="32" height="32" border="0" alt="Grabaciones Realizadas"/><br/>Grabaciones</a></td>';
botones += '<td class="borderBotones" align="center"><a href="/osd/osd2tcp.html" style="text-decoration:none;"><img src="/sincro/img/osd.gif" width="32" height="32" border="0" alt="Control OSD"/><br/>OSD</a></td>';
botones += '<td class="borderBotones" align="center"><a href="/cgi-bin/box/show/var/etc" style="text-decoration:none;"><img src="/sincro/img/explorador.gif" width="32" height="32" border="0" alt="Editor/Explorador de Archivos"/><br/>Explorador</a></td>';
botones += '<td class="borderBotones" align="center"><a href="/utils/cmdInput.html" style="text-decoration:none;"><img src="/sincro/img/comandos.gif" width="32" height="32" border="0" alt="Ejecuci&oacute;n de comandos Linux"/><br/>Comandos</a></td>';
botones += '<td class="borderBotones" align="center"><a href="/cgi-bin/box/selectLiveTv" style="text-decoration:none;"><img src="/sincro/img/ver_tv.gif" width="32" height="32" border="0" alt="Ver LiveTV"/><br/>Ver TV</a></td>';
botones += '<td class="borderBotones" align="center"><a href="/sincro/visualizarts.html" style="text-decoration:none;"><img src="/sincro/img/ver_tv_ts.gif" width="32" height="32" border="0" alt="Ver LiveTV-TimeShift"/><br/>Ver TV-TS</a></td>';
botones += '<td class="borderBotones" align="center"><a href="/ssh/sshconn.html" style="text-decoration:none;"><img src="/sincro/img/ssh.gif" width="32" height="32" border="0" alt="Conexi&oacute;n SSH"/><br/>SSH</a></td>';
botones += '<td class="borderBotones" align="center"><a href="/autores.html" style="text-decoration:none;"><img src="/sincro/img/autores.gif" width="32" height="32" border="0" alt="Autores"/><br/>Autores</a></td>';
botones += '<td class="borderBotones" align="center"><a href="/cgi-bin/sincro/verlog" style="text-decoration:none;"><img src="/sincro/img/log.gif" width="32" height="32" border="0" alt="Ver Log"/><br/>Log</a></td>';
botones += '<td class="borderBotones" align="center"><a href="/cgi-bin/box/estado" style="text-decoration:none;"><img src="/sincro/img/estado.gif" width="32" height="32" border="0" alt="Ver Estado"/><br/>Estado</a></td>';
botones += '<td class="borderBotones2" align="center"><a href="/index.html" style="text-decoration:none;"><img src="/sincro/img/salir.gif" width="32" height="32" border="0" alt="Salir"/><br/>Salir</a></td>';
botones += '</tr></table><br/>';

function barra_botones() {
	document.write(botones);
}
