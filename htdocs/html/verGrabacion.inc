<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
	<link rel="icon" href="/favicon.ico" type="image/x-icon"/>
	<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" href="/css/estilos.css" type="text/css"/>
	<script type="text/javascript" src="/js/html_params.js" charset="ISO-8859-1"></script>
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
			document.forms[0].cridfile.value=getparam("crid", document.location.href);
			encurso=getparam("recording", document.location.href);
			if (encurso=="yes")
				document.forms[0].encurso.selectedIndex=1;
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
				document.forms[0].mplayer.value="##MPLAYER##";
				document.forms[0].temp.value="##TEMP##";
			}
		}
	</script>
	<title>M750T - Visualizar Grabación</title>
</head>
<body bgcolor="#FFFFFF" onload="init();">
	<form name="form_m750" method="post" action="/cgi-bin/crid/ver-crid">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td align="center">
				<font class="titPag">M750T EPG</font>
				<br>
				<font class="subTitPag">Visualizar Grabación</font>
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
				<table width="100%" border="0" cellspacing="2" cellpadding="0" align="center">
					<tr>
						<td class="txtNormal" width="150">Host: </td>
						<td class="txtNormal"><input type="text" name="host" size="50" maxlength="100" class="cajaplana"></td>
					</tr>
					<tr>
						<td class="txtNormal">FTP port:</td>
						<td class="txtNormal"><input type="text" name="port" value="21" size="5" maxlength="5" class="cajaplana"></td>
					</tr>
					<tr>
						<td class="txtNormal">Cridfile: </td>
						<td class="txtNormal"><input type="text" name="cridfile" size="70" maxlength="200" class="cajaplana"></td>
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
						<td class="txtNormal"><input type="text" name="mplayer" value="##MPLAYER##" size="70" maxlength="200" class="cajaplana"></td>
					</tr>
					<tr>
						<td class="txtNormal">Directorio Temporal:</td>
						<td class="txtNormal"><input type="text" name="temp" value="##TEMP##" size="70" maxlength="200" class="cajaplana"></td>
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
					<tr>
					    <td class="txtNormal">Sistema operativo:</td>
					    <td class="txtNormal">
					        <select size="1" name="so" onchange="javascript:cambioSO();">
					            <option value="1" selected>Windows</option>
					            <option value="0">Linux/Unix</option>
					        </select>
					    </td>
					</tr>
					<tr>
					    <td class="txtNormal" valign="top">Grabación en curso:</td>
					    <td class="txtNormal">
					        <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					        <tr>
					            <td class="txtNormal"  valign="top">
					                <select size="1" name="encurso">
					                    <option value="NO" selected>No</option>
					                    <option value="SI">Sí</option>
					                </select>
					            </td>
					            <td width="4">&nbsp;<td>
					            <td class="txtInfo" valign="top">
					                Si la grabación está en curso, seleccione Sí. Podrá comenzar a verla una vez transcurridos los primeros 10 minutos de grabación.
					                (Si todavía no han transcurrido los primeros 10 minutos, la reproducción puede sufrir cortes inesperados y deberá reiniciar la reproducción.)
					            </td>
					        </tr>
					        </table>
					    </td>
					</tr>
					<tr>
						<td class="txtNormal" height="20" colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td class="txtNormal" align="center" colspan="2"><a href="javascript:enviar();"><img src="/img/aceptar.gif" alt="Visualizar Grabación" width="28" height="25" border="0"></a></td>
					</tr>
					<tr>
						<td class="txtNormal" height="30" colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td class="txtNormal" height="10" colspan="2">
							<font class="titTabla">Atención:</font><br>
							Al hacer click sobre el botón <img src="/img/aceptar.gif" alt="Visualizar Grabación" width="28" height="25" border="0">, verá una ventana como ésta:<br><br>
							<img src="/img/visualizar_cmd.jpg" alt="Visualizar Grabación" width="455" height="266" border="0"><br><br>
							Haciendo click sobre el botón "Ejecutar", descargará el fichero "visualizar_grabacion.cmd" en un directorio temporal y éste generará la lista de reproducción llamando a su vez al reproductor <a href="http://www.mplayerhq.hu/">MPlayer</a>.
						</td>
					</tr>
				</table>
				<br>
