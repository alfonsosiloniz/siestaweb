<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
	<link rel="icon" href="/favicon.ico" type="image/x-icon"/>
	<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" href="/css/estilos.css" type="text/css"/>
	<script type="text/javascript" src="/js/ajax.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/navigator.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/controlenviar.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/botones.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/m750.js" charset="ISO-8859-1"></script>
	<title>M750T - Sincroguía</title>
</head>
<body bgcolor="#FFFFFF">
	<form name="form_m750">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td align="center">
				<font class="titPag">M750T EPG</font>
				<br/>
				<font class="subTitPag">Detalle de programa</font>
			</td>
		</tr>
		<tr>
			<td>
				<br/>
				<xsl:choose>
					<xsl:when test="system-property('xsl:vendor') = 'Microsoft'">
						<script language="JavaScript">barra_botones();</script>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select='document("/xsl/botones.xsl")'/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</table>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="/M750/PGMDETAIL/PROGRAMMED='1'">
						<br/>
						<table width="350" border="0" cellspacing="0" cellpadding="1" align="center">
							<tr>
								<td width="100%" align="center" bgcolor="#ffb310" class="titTabla" height="20">Evento programado en Grabaciones Pendientes</td>
							</tr>
						</table>
					</xsl:when>
				</xsl:choose>
				<br/>
				<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">
					<tr>
						<td colspan="2" class="titChannel">
							<xsl:value-of select="/M750/PGMDETAIL/CHANNEL_ID" /> - <xsl:value-of select="/M750/PGMDETAIL/DATE" />
						</td>
					</tr>
					<tr>
						<td colspan="2" class="titChannel" height="6"></td>
					</tr>
					<tr>
						<td width="230" class="txtNormal" align="center" valign="top">
							<xsl:element name="img">
								<xsl:attribute name="src"><xsl:value-of select="/M750/PGMDETAIL/IMG" /></xsl:attribute>
								<xsl:attribute name="width">221</xsl:attribute>
								<xsl:attribute name="height">149</xsl:attribute>
								<xsl:attribute name="border">2</xsl:attribute>
							</xsl:element>
						</td>
						<td class="txtNormal" align="left" valign="top">
							<textarea class="cajaEPG" cols="120" rows="24" name="texto" readonly="1"><xsl:value-of select='/M750/PGMDETAIL/TEXT' /></textarea>
						</td>
					</tr>
					<tr>
						<td>&#160;</td>
						<td class="txtNormal" align="center">
							<xsl:choose>
								<xsl:when test="/M750/PGMDETAIL/PROGRAMMED='0'">
									<xsl:element name="a">
										<xsl:attribute name="href">javascript:programarGrabacionPID("<xsl:value-of select="/M750/PGMDETAIL/PIDCID" />", 0)</xsl:attribute>
										<img src="/img/red_ball.jpg" alt="Grabar" width="18" height="18" border="0" />Grabar
									</xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="a">
										<xsl:attribute name="href">javascript:cancelarGrabacionPID("<xsl:value-of select="/M750/PGMDETAIL/PIDCID" />")</xsl:attribute>
										<img src="/img/red_ball.jpg" alt="Cancelar" width="18" height="18" border="0" />Cancelar Grabación
									</xsl:element>
								</xsl:otherwise>
							</xsl:choose>
							&#160;|&#160;
							<xsl:element name="a">
								<xsl:attribute name="href">javascript:programarGrabacionPID("<xsl:value-of select="/M750/PGMDETAIL/PIDCID" />", 1)</xsl:attribute>
								<img src="/img/blue_ball.jpg" alt="Grabar en Serie" width="18" height="18" border="0" />Grabar en Serie
							</xsl:element>
							&#160;|&#160;
							<xsl:element name="a">
								<xsl:attribute name="href">javascript:detalleProgramaInOut("<xsl:value-of select="/M750/PGMDETAIL/PIDCID" />")</xsl:attribute>
								<img src="/img/sincro_small.gif" alt="Sincroguía InOut" width="18" height="18" border="0" />Ficha Sincroguía InOut
							</xsl:element>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>
</xsl:template>
</xsl:stylesheet>
