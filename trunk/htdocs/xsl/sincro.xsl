<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
	<meta http-equiv="Refresh" content="600"/>
	<link rel="icon" href="/favicon.ico" type="image/x-icon"/>
	<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" href="/css/estilos.css" type="text/css"/>
	<script type="text/javascript" src="/js/ajax.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/navigator.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/controlenviar.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/fechasOp.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/botones.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/m750.js" charset="ISO-8859-1"></script>
	<title>M750T - Sincroguía</title>
</head>
<body bgcolor="#FFFFFF" onload="initFechas();">
	<form name="form_m750">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td align="center">
				<font class="titPag">M750T EPG</font>
				<br/>
				<a href="http://www.inout.tv/SincroGuia" target="_blank"><img src="/img/sincro.gif" border="0"/></a><font class="subTitPag">proporcionada por InOut TV</font>
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
				<br/>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td class="txtNormal" align="right">
							Buscar Programa: <input class="cajaplana" name="querystr" type="text" size="20" maxsize="50" value="" />
							<input class="txtNormal" type="button" value="Buscar" onclick="buscarPrograma()" /><br/>
							Búsqueda Horaria:
							Fecha: <select size="1" name="fecha"><option value="">Procesando...</option></select>
							Hora: <select size="1" name="hora">
								<option value="00:">0</option>
								<option value="01:">1</option>
								<option value="02:">2</option>
								<option value="03:">3</option>
								<option value="04:">4</option>
								<option value="05:">5</option>
								<option value="06:">6</option>
								<option value="07:">7</option>
								<option value="08:">8</option>
								<option value="09:">9</option>
								<option value="10:">10</option>
								<option value="11:">11</option>
								<option value="12:">12</option>
								<option value="13:">13</option>
								<option value="14:">14</option>
								<option value="15:">15</option>
								<option value="16:">16</option>
								<option value="17:">17</option>
								<option value="18:">18</option>
								<option value="19:">19</option>
								<option value="20:">20</option>
								<option value="21:">21</option>
								<option value="22:">22</option>
								<option value="23:">23</option>
							</select>
							<input class="txtNormal" type="button" value="Buscar" onclick="buscarProgramaFH()" />
						</td>
					</tr>
				</table>
    <xsl:for-each select="M740/SINCROGUIA/CHANNEL">
    <table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">
    <tr>
      <td class="titChannel" width="32" align="center">
        <xsl:element name="img">
        <xsl:attribute name="src">
        <xsl:text>/img/tv/</xsl:text>
        <xsl:value-of select="@id"/><xsl:text>.gif</xsl:text>
        </xsl:attribute>
        </xsl:element>
      </td>
      <td class="titChannel" valign="top" align="left">
        <xsl:element name="a">
        <xsl:attribute name="href">/cgi-bin/sincro/ver-sincro?<xsl:value-of select="@id"/>-<xsl:value-of select="PROGRAM/DATE_UTC"/></xsl:attribute>
        <xsl:value-of select="@name"/></xsl:element>
        <font class="txtNormal"><b> (<xsl:element name="a"><xsl:attribute name="href">javascript:cambioCanal(<xsl:value-of select="@numChannel"/>)</xsl:attribute>Ver Canal</xsl:element>)</b></font>
      </td>
    </tr>
    <tr>
      <td height="4"></td>
    </tr>
    </table>
    <table width="100%" border="0" cellspacing="0" cellpadding="2" align="center" class="borderTabla2">
    <tr bgcolor="#ffb310" class="fila">
      <th align="center" colspan="2" width="40" class="fila">Rec</th>
      <th align="left" width="15%" class="fila">Fecha/Hora</th>
      <th align="left" width="30%" class="fila">Título</th>
      <th align="left" width="50%" class="fila">Descripción</th>
    </tr>
    <xsl:for-each select="PROGRAM">
        <xsl:sort select="DATE_UTC"/>
        <xsl:choose>
        <xsl:when test="DATE_UTC &gt; /M740/SINCROGUIA/@actual or DATE_UTC = /M740/SINCROGUIA/@actual">
        <tr class="fila">
          <td class="fila">
            <xsl:element name="a">
	            <xsl:attribute name="href">javascript:programarGrabacion("<xsl:value-of select="@pid"/>", 0, "<xsl:value-of select="TITLE"/>")</xsl:attribute>
	            <img src="/img/red_ball.jpg" alt="Grabar" width="18" height="18" border="0" />
            </xsl:element>
          </td>
          <td class="fila">
            <xsl:element name="a">
	            <xsl:attribute name="href">javascript:programarGrabacion("<xsl:value-of select="@pid"/>", 1, "<xsl:value-of select="TITLE"/>")</xsl:attribute>
	            <img src="/img/blue_ball.jpg" alt="Grabar en Serie" width="18" height="18" border="0" />
            </xsl:element>
          </td>
          <td class="fila">
            <xsl:value-of select="DATE"/> 
            <xsl:if test="DATE_FIN!=''">
                <br/><xsl:value-of select="DATE_FIN"/>
            </xsl:if>
          </td>
          <td class="fila">
            <xsl:choose>
            <xsl:when test="/M740/SINCROGUIA/@miniatures='si'">
                <table width="100%" border="0" cellspacing="0" cellpadding="1">
                <tr>
                    <td class="txtNormal" width="80">
                        <xsl:element name="a">
                            <xsl:attribute name="href">javascript:detallePrograma("<xsl:value-of select="@pid"/>", "<xsl:value-of select="IMAGE"/>", "<xsl:value-of select="LONG"/>", "<xsl:value-of select="@chid"/>", "<xsl:value-of select="DATE_UTC"/>")</xsl:attribute>
                            <xsl:choose>
	                            <xsl:when test="/M740/SINCROGUIA/@getImgInet='si'">
	                                <xsl:choose>
		                                <xsl:when test="IMAGE!=''">
		                                    <xsl:element name="img">
			                                    <xsl:attribute name="src">http://www.inout.tv/fotos/<xsl:value-of select="IMAGE"/></xsl:attribute>
			                                    <xsl:attribute name="width">77</xsl:attribute>
			                                    <xsl:attribute name="height">52</xsl:attribute>
			                                    <xsl:attribute name="border">0</xsl:attribute>
			                                    <xsl:attribute name="alt"><xsl:value-of select="TITLE"/></xsl:attribute>
		                                    </xsl:element>
		                                </xsl:when>
		                                <xsl:otherwise>
		                                    <xsl:element name="img">
			                                    <xsl:attribute name="src">/img/epg_long_img.png</xsl:attribute>
			                                    <xsl:attribute name="width">77</xsl:attribute>
			                                    <xsl:attribute name="height">52</xsl:attribute>
			                                    <xsl:attribute name="border">0</xsl:attribute>
			                                    <xsl:attribute name="alt"><xsl:value-of select="TITLE"/></xsl:attribute>
		                                    </xsl:element>
		                                </xsl:otherwise>
	                                </xsl:choose>
	                            </xsl:when>
	                            <xsl:otherwise>
	                                <xsl:choose>
		                                <xsl:when test="/M740/SINCROGUIA/@localSincroImgAcc='si'">
			                                <xsl:element name="img">
			                                    <xsl:attribute name="src">/img/epg/<xsl:value-of select="IMAGE"/></xsl:attribute>
			                                    <xsl:attribute name="width">77</xsl:attribute>
			                                    <xsl:attribute name="height">52</xsl:attribute>
			                                    <xsl:attribute name="border">0</xsl:attribute>
			                                    <xsl:attribute name="alt"><xsl:value-of select="TITLE"/></xsl:attribute>
		                                    </xsl:element>
		                                </xsl:when>
		                                <xsl:otherwise>
		                                    <xsl:element name="img">
			                                    <xsl:attribute name="src">/img/epg_long_img.png</xsl:attribute>
			                                    <xsl:attribute name="width">77</xsl:attribute>
			                                    <xsl:attribute name="height">52</xsl:attribute>
			                                    <xsl:attribute name="border">0</xsl:attribute>
			                                    <xsl:attribute name="alt"><xsl:value-of select="TITLE"/></xsl:attribute>
		                                    </xsl:element>
		                                </xsl:otherwise>
	                                </xsl:choose>
	                            </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </td>
                    <td class="txtNormal">
                        <xsl:element name="a">
                        	<xsl:attribute name="href">javascript:detallePrograma("<xsl:value-of select="@pid"/>", "<xsl:value-of select="IMAGE"/>", "<xsl:value-of select="LONG"/>", "<xsl:value-of select="@chid"/>", "<xsl:value-of select="DATE_UTC"/>")</xsl:attribute>
                            <xsl:value-of select="TITLE"/>
                        </xsl:element>
                    </td>
                </tr>
                </table>
             </xsl:when>
             <xsl:otherwise>
                <xsl:element name="a">
                	<xsl:attribute name="href">javascript:detallePrograma("<xsl:value-of select="@pid"/>", "<xsl:value-of select="IMAGE"/>", "<xsl:value-of select="LONG"/>", "<xsl:value-of select="@chid"/>", "<xsl:value-of select="DATE_UTC"/>")</xsl:attribute>
                    <xsl:value-of select="TITLE"/>
                </xsl:element>
             </xsl:otherwise>
             </xsl:choose>
          </td>
          <td class="fila"><xsl:value-of select="SUBTITLE"/></td>
        </tr>
        </xsl:when>
        </xsl:choose>
    </xsl:for-each>
    </table>
	<br/>
    </xsl:for-each>
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
