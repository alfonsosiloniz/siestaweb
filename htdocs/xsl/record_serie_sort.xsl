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
	<script type="text/javascript" src="/js/blink.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/navigator.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/controlenviar.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/botones.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/m750.js" charset="ISO-8859-1"></script>
	<title>M750T - Grabaciones Realizadas</title>
</head>
<body bgcolor="#FFFFFF">
	<form name="form_m750">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td align="center">
				<font class="titPag">M750T EPG</font>
				<br/>
				<font class="subTitPag">Grabaciones Realizadas</font>
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
				<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center" class="borderTabla2">
					<tr bgcolor="#ffb310">
						<th class="fila" align="right">B&#160;&#160;&#160;A&#160;&#160;&#160;C&#160;&#160;&#160;M&#160;&#160;&#160;D&#160;&#160;&#160;V&#160;</th>
						<th class="fila" align="left">Título</th>
						<th class="fila" align="left"><a href="/cgi-bin/crid/ver-lista-grabaciones?time" title="Ordenar por Fecha">Inicio</a></th>
						<th class="fila" align="left">Final</th>
						<th class="fila" align="left">Duración (min)</th>
						<th class="fila" align="right">&#160;</th>
						<th class="fila" align="right">Tamaño</th>
						<th class="fila" align="left">&#160;</th>
						<th class="fila" align="left">&#160;</th>
						<th class="fila" align="left">&#160;</th>
						<th class="fila" align="left">&#160;</th>
					</tr>
					<xsl:for-each select="M750/RECORDINGS/RECORD">
						<!--<xsl:sort select="SERIE_ID" order="descending" />-->
						<xsl:choose>
							<xsl:when test="CAMBIO_SERIE='1'">
								<tr><td colspan="11" bgcolor="black" style="height: 1px;"></td></tr>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="CAMBIO_SERIE='1' and SERIE_ID &lt; '0'">
								<tr><td class="titChannel" height="20"></td><td colspan="10" class="titChannel"><xsl:value-of select="TITLE"/></td></tr>
							</xsl:when>
						</xsl:choose>
						<tr>
							<td class="fila" align="right" width="120">
								<xsl:choose>
									<xsl:when test="REC_STATE!='2'">
										<xsl:element name="a">
											<xsl:attribute name="title">Eliminar Grabación</xsl:attribute>
											<xsl:attribute name="href">javascript:borrarGrabacion("<xsl:value-of select="CRID_FILE"/>")</xsl:attribute>
											<img src="/img/red_ball.jpg" alt="Eliminar Grabación" width="18" height="18" border="0" />
										</xsl:element>
										<xsl:text> </xsl:text>
										<xsl:element name="a">
											<xsl:attribute name="title">Archivar Grabación</xsl:attribute>
											<xsl:attribute name="href">javascript:archivarGrabacion("<xsl:value-of select="CRID_FILE"/>")</xsl:attribute>
											<img src="/img/rec2arch.gif" alt="Archivar Grabación" width="16" height="16" border="0" />
										</xsl:element>
										<xsl:text> </xsl:text>
										<xsl:element name="a">
											<xsl:attribute name="title">Copiar Grabación</xsl:attribute>
											<xsl:attribute name="href">javascript:copiarGrabacion("<xsl:value-of select="CRID_FILE"/>")</xsl:attribute>
											<img src="/img/copy-icon.gif" alt="Copiar Grabación" width="16" height="16" border="0" />
										</xsl:element>
										<xsl:text> </xsl:text>
										<xsl:element name="a">
											<xsl:attribute name="title">Mover Grabación</xsl:attribute>
											<xsl:attribute name="href">javascript:moverGrabacion("<xsl:value-of select="CRID_FILE"/>")</xsl:attribute>
											<img src="/img/cut-icon.gif" alt="Mover Grabación" width="16" height="16" border="0" />
										</xsl:element>
										<xsl:text> </xsl:text>
										<xsl:element name="a">
											<xsl:attribute name="title">Descargar Grabación</xsl:attribute>
											<xsl:attribute name="href">/html/descargar-grabacion.html?crid=<xsl:value-of select="CRID_FILE"/></xsl:attribute>
											<img src="/img/icon-save.gif" alt="Descargar Grabación" width="16" height="16" border="0" />
										</xsl:element>
										<xsl:text> </xsl:text>
										<xsl:element name="a">
											<xsl:attribute name="title">Visualizar Grabación</xsl:attribute>
											<xsl:attribute name="href">/cgi-bin/box/verCrid?crid=<xsl:value-of select="CRID_FILE"/>&#x26;recording=no</xsl:attribute>
											<img src="/img/muangelo.gif" alt="Visualizar Grabación" width="18" height="18" border="0" />
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:element name="a">
											<xsl:attribute name="title">Visualizar Grabación</xsl:attribute>
											<xsl:attribute name="href">/cgi-bin/box/verCrid?crid=<xsl:value-of select="CRID_FILE"/>&#x26;recording=yes</xsl:attribute>
											<img src="/img/muangelo.gif" alt="Visualizar Grabación" width="18" height="18" border="0" />
										</xsl:element>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td class="fila">
								<xsl:element name="a">
									<xsl:attribute name="href">javascript:detalleCrid("<xsl:value-of select="CRID_FILE"/>")</xsl:attribute>
									<xsl:value-of select="TITLE"/>
								</xsl:element>
								<xsl:choose>
									<xsl:when test="REC_STATE='2'">
										<blink><font class="txtInfo">(en curso)</font></blink>
									</xsl:when>
								</xsl:choose>
							</td>
							<td class="fila"><xsl:value-of select="INIT_TIME"/></td>
							<td class="fila"><xsl:value-of select="END_TIME"/></td>
							<td class="fila"><xsl:value-of select="DURATION"/></td>
							<td class="fila" align="right" title="Numero de fragmentos de grabación">
								<xsl:choose>
									<xsl:when test="NUM_FMPG &gt; '1'">
										( <xsl:value-of select="NUM_FMPG"/> )
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
							<td class="fila" align="right"><xsl:value-of select="SPACE"/></td>
							<td class="fila">&#160;</td>
							<td class="fila">
								<xsl:choose>
									<xsl:when test="REC_STATE='2'">
										<img src="/img/skin/Record_rot.png" alt="En grabación" width="20" height="20" border="0" />
									</xsl:when>
									<xsl:when test="REC_STATE='3'">
										<xsl:choose>
											<xsl:when test="PLAYBACK_TS='0'">
												<img src="/img/skin/Icon_record_OK.png" alt="Grabación correcta" width="20" height="20" border="0" />
											</xsl:when>
											<xsl:otherwise>
												<img src="/img/skin/Icon_record_OK_played.png" alt="Grabación correcta con visionado" width="20" height="20" border="0" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="REC_STATE='4'">
										<xsl:choose>
											<xsl:when test="PLAYBACK_TS='0'">
												<img src="/img/skin/failed_icon.png" alt="Grabación erronea" width="20" height="20" border="0" />
											</xsl:when>
											<xsl:otherwise>
												<img src="/img/skin/failed_icon_played.png" alt="Grabación erronea con visionado" width="20" height="20" border="0" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
							<td class="fila">
								<xsl:choose>
									<xsl:when test="SERIE_ID &lt; '0'">
										<img src="/img/skin/Icon_serie.png" alt="Grabación en Serie" width="20" height="20" border="0" />
									</xsl:when>
									<xsl:when test="SERIE_ID &gt; '0'">
										<img src="/img/star_record.gif" alt="Grabación de Lo mejor de la TV" width="20" height="20" border="0" />
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
							<td class="fila">
								<xsl:choose>
									<xsl:when test="IMPORTANT='1'">
										<img src="/img/skin/important_icon.png" alt="Grabación protegida" width="20" height="20" border="0" />
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</xsl:for-each>
				</table>
				<br/><br/>
				Ver grabaciones del directorio <input type="text" value="/var/media/PC1/Video" size="50" name="alt_dir" />&#160;
				<input type="button" value="Ver" onclick="document.location.href='/cgi-bin/crid/ver-lista-grabaciones?serie&amp;' + document.forms[0].alt_dir.value" />
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
