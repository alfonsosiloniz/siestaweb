<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
	<link rel="icon" href="/favicon.ico" type="image/x-icon"/>
	<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" href="/css/estilos.css" type="text/css"/>
	<script type="text/javascript" src="/js/navigator.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/controlenviar.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/botones.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/m750.js" charset="ISO-8859-1"></script>
	<script type="text/javascript">
		function init() {
			index=document.location.href.indexOf("://");
			host=document.location.href.substring(index+3);
			index=host.indexOf("/");
			host=host.substring(0, index);
			document.forms[0].host.value=host;
		}
		function enviar() {
			document.forms[0].submit();
		}
		function cambioSO() {
			if (document.forms[0].so.value==0) {
				document.forms[0].mplayer.value="\/usr\/bin\/mplayer";
				document.forms[0].temp.value="\/tmp";
			}
			else {
				document.forms[0].mplayer.value="C:\\Archivos de programa\\mplayer\\mplayer.exe";
				document.forms[0].temp.value="C:\\Temp";
			}
		}
	</script>
	<title>M750T - Ver LiveTV-TimeShift</title>
</head>
<body bgcolor="#FFFFFF" onload="init();">
	<form name="form_m750" method="post" action="/cgi-bin/crid/ver-timeshift">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td align="center">
				<font class="titPag">M750T EPG</font>
				<br>
				<font class="subTitPag">Ver LiveTV-TimeShift</font>
			</td>
		</tr>
		<tr>
			<td><br><script type="text/javascript">barra_botones();</script></td>
		</tr>
	</table>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td>
				<br>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td class="txtInfo" colspan="2">Mediante esta opción podrás ver la TV en directo, utilizando la grabación del TimeShift
							que realiza el gigaset. Obviamente necesitas tener el TimeShift activado para utilizarlo.<br>
							La ventaja de este método es que no necesita matar los procesos del gigaset, y por lo tanto no se necesita reiniar después de la finalización de la reproducción.<br>
							Consejo: no intentes ir al último minuto del vídeo para ver la TV lo más en directo posible, ya que puede que llegues al final del buffer y se corte la reproducción. Cuando avances
							ten cuidado de que la barra de progreso de mplayer no llegue al final.<br><br>
						</td>
					</tr>
					<tr>
						<td class="txtNormal">Host: </td>
						<td class="txtNormal"><input type="text" name="host" size="50" maxlength="100" class="cajaplana"></td>
					</tr>
					<tr>
						<td class="txtNormal">FTP port:</td>
						<td class="txtNormal"><input type="text" name="port" value="21" size="5" maxlength="5" class="cajaplana"></td>
					</tr>
					<tr>
						<td class="txtNormal">FTP User:</td>
						<td class="txtNormal"><input type="text" name="user" value="root" size="10" maxlength="25" class="cajaplana"></td>
					</tr>
					<tr>
						<td class="txtNormal">FTP Password:</td>
						<td class="txtNormal"><input type="text" name="pwd" value="root" size="10" maxlength="25" class="cajaplana"></td>
					</tr>
					<tr>
						<td class="txtNormal">Path de MPlayer:</td>
						<td class="txtNormal"><input type="text" name="mplayer" value="C:\Archivos de programa\mplayer\mplayer.exe" size="70" maxlength="200" class="cajaplana"></td>
					</tr>
					<tr>
						<td class="txtNormal">Directorio Temporal:</td>
						<td class="txtNormal"><input type="text" name="temp" value="C:\Temp" size="70" maxlength="200" class="cajaplana"></td>
					</tr>
					<tr>
						<td class="txtNormal">Relación de Aspecto:</td>
						<td class="txtNormal">
							<select size="1" name="aspect">
								<option value="1.33" selected>4:3</option>
								<option value="1.7777">16:9</option>
								<option value="1.25">1.25</option>
							</select>
						</td>
					</tr>
					<!--
					<tr>
						<td class="txtNormal">Sistema operativo:</td>
						<td class="txtNormal">
						<select size="1" name="so" onchange="javascript:cambioSO();">
							<option value="1" selected>Windows</option>
							<option value="0">Linux/Unix</option>
						</select>
						<b><font color="#ff0000">Seleccione esto lo primero</font></b>
						</td>
					</tr>
					-->
					<tr>
						<td class="txtNormal" height="20" colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td class="txtNormal" align="center" colspan="2"><a href="javascript:enviar();"><img src="/img/aceptar.gif" alt="Visualizar LiveTV-TimeShift" width="28" height="25" border="0" /></a></td>
					</tr>
					<tr>
						<td class="txtNormal" height="30" colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td class="txtNormal" colspan="2">
							Para el funcionamiento de esta opción, necesitas tener instalado el reproductor <a href="http://www.mplayerhq.hu/">MPlayer</a>, la aplicación <a href="http://isidorocr.googlepages.com/wget.zip">wget</a> y este <a href="http://isidorocr.googlepages.com/utilities.zip">pack de utilidades</a>.<br>
							El pack de utilidades está compuesto por varios ejecutables, que al igual que wget, deben están en un directorio que esté en el path (por ejemplo c:\windows).
						</td>
					</tr>
					<tr>
						<td class="txtNormal" height="10" colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td class="txtNormal" height="10" colspan="2">
						    <font class="titTabla">Atención:</font><br>
						    Al hacer click sobre el botón <img src="/img/aceptar.gif" alt="Visualizar LiveTV-TimeShift" width="28" height="25" border="0" />, verá una ventana como ésta:<br><br>
						    <img src="/img/visualizar_cmd.jpg" alt="Visualizar LiveTV-TimeShift" width="455" height="266" border="0" /><br><br>
						    Haciendo click sobre el botón "Ejecutar", descargará el fichero "verts.cmd" en un directorio temporal y éste generará la lista de reproducción llamando a su vez al reproductor <a href="http://www.mplayerhq.hu/">MPlayer</a>.
						</td>
					</tr>
				</table>
				<br>
