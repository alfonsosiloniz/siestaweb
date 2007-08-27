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
	<title>M750T - Grabaciones Pendientes</title>
</head>
<body bgcolor="#FFFFFF">
	<form name="form_m750">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td align="center">
				<font class="titPag">M750T EPG</font>
				<br/>
				<font class="subTitPag">Grabaciones Pendientes</font>
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
			<td class="txtNormal" align="center">
				<br/>
				Espacio en disco: <xsl:value-of select="M750/SPACE"/>
				<br/>
				<br/>
				<a href="/cgi-bin/crid/viewRAFile">Ver RA_FILE (grabaciones pendientes)</a> | <a href="/cgi-bin/crid/viewSMFile">Ver SM_FILE (programaciones de series)</a>
				<br/>
				<br/>
				<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center" class="borderTabla2">
					<tr bgcolor="#ffb310">
						<th class="fila" align="center" width="20">C</th>
						<th class="fila" align="left">T�tulo</th>
						<th class="fila" align="left">Inicio</th>
						<th class="fila" align="left">Final</th>
						<th class="fila" align="left">Duraci�n (min)</th>
						<th class="fila" align="left">&#160;</th>
					</tr>
					<xsl:for-each select="M750/TIMER/RECORD">
						<xsl:sort select="UTC_TIME"/>
						<tr>
							<td class="fila">
								<xsl:element name="a">
									<xsl:attribute name="href">javascript:cancelarGrabacion("<xsl:value-of select="PIDCID"/>")</xsl:attribute>
									<img src="/img/red_ball.jpg" alt="Cancelar Grabaci�n Pendiente" width="18" height="18" border="0" />
								</xsl:element>
							</td>
							<td class="fila">
								<xsl:element name="a">
									<xsl:attribute name="href">javascript:detalleTimer("<xsl:value-of select="PIDCID"/>","<xsl:value-of select="CRID_FILE"/>")</xsl:attribute>
									<xsl:value-of select="TITLE"/>
								</xsl:element>
							</td>
							<td class="fila"><xsl:value-of select="INIT_TIME"/></td>
							<td class="fila"><xsl:value-of select="END_TIME"/></td>
							<td class="fila"><xsl:value-of select="DURATION"/></td>
							<td class="fila">
								<xsl:choose>
									<xsl:when test="SERIE_ID &lt; '0'">
										<img src="/img/skin/Icon_serie.png" alt="Grabaci�n en Serie" width="20" height="20" border="0" />
									</xsl:when>
									<xsl:when test="SERIE_ID &gt; '0'">
										<img src="/img/star_record.gif" alt="Grabaci�n de Lo mejor de la TV" width="20" height="20" border="0" />
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</xsl:for-each>
				</table>
				<br/>
				<a href="/cgi-bin/crid/viewRAFile">Ver RA_FILE (grabaciones pendientes)</a> | <a href="/cgi-bin/crid/viewSMFile">Ver SM_FILE (programaciones de series)</a>
			</td>
		</tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
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
	</form>
</body>
</html>
</xsl:template>
</xsl:stylesheet>
