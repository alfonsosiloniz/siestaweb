<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
	<link rel="icon" href="/favicon.ico" type="image/x-icon"/>
	<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" href="/css/estilos.css" type="text/css"/>
	<script type="text/javascript" src="/js/botones.js" charset="ISO-8859-1"></script>
	<script type="text/javascript">
function editar() {
	alert("Edicion temporalmente desactivada.");
//    document.location.href="/cgi-bin/crid/edittitleXML?<xsl:value-of select="/M750/RECORD_DETAIL/CRIDFILE" />";
}
	</script>
	<title>M750T - Detalle de Grabación</title>
</head>
<body bgcolor="#FFFFFF">
	<form name="form_m750" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td align="center">
				<font class="titPag">M750T EPG</font>
				<br/>
				<font class="subTitPag">Detalle de Grabación</font>
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
					<xsl:when test="/M750/RECORD_DETAIL/ERROR != ''">
						<br/>
						<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
							<tr>
								<td class="titChannel" align="center">
									<font class="txtAvisos">
									<xsl:value-of select="/M750/RECORD_DETAIL/ERROR" />
									</font>
								</td>
							</tr>
						</table>
					</xsl:when>
					<xsl:otherwise>
						<br/>
						<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">
							<tr>
								<td class="titChannel">
									<xsl:value-of select="/M750/RECORD_DETAIL/CHANNEL_NAME" />
									/ 
									<xsl:value-of select="/M750/RECORD_DETAIL/INIT_TIME" /> - <xsl:value-of select="/M750/RECORD_DETAIL/END_TIME" />
								</td>
							</tr>
							<tr>
								<td class="titChannel" height="4"></td>
							</tr>
							<tr>
								<td class="txtNormal" align="left">
									<font class="titChannel"><xsl:value-of select='/M750/RECORD_DETAIL/TITLE' /></font>
									<br/>
									<font class="titTabla"><xsl:value-of select='/M750/RECORD_DETAIL/EPG_SHORT' /></font>
									<br/>
									<br/>
									<textarea class="cajaEPG" cols="120" rows="24" name="texto" readonly="1">
										<xsl:value-of select='/M750/RECORD_DETAIL/EPG_LONG' />
									</textarea>
									<!--<br/><input class="txtNormal" type="button" value="Editar" onclick="editar()" />-->
								</td>
							</tr>
						</table>
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
