<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <title>M750T - Detalle de Grabación Pendiente</title>
  <link href="/sincro/img/m740.ico" rel="shortcut icon"></link>
  <link href="/sincro/css/estilos.css" rel="stylesheet" type="text/css"></link>
  <body>
    <div align="center"><p><font class="titPag">M750T EPG</font></p></div>
    <div align="center"><font class="subTitPag">Detalle de Grabación Pendiente</font></div>
    <xsl:copy-of select='document("/sincro/botones.xsl")'/>
    <p><table width="500" border="0" cellspacing="0" cellpadding="1" align="center">
    <tr>
      <td class="titTabla" bgcolor="#ffb310" height="18">#</td>
      <td class="titTabla" bgcolor="#ffb310" align="center">Guarda inicial</td>
      <td class="titTabla" bgcolor="#ffb310" align="center">Guarda final</td>
      <td class="titTabla" bgcolor="#ffb310" align="center">Sintonizador</td>
      <td class="titTabla" bgcolor="#ffb310" align="center">Frecuencia</td>
    </tr>
    <tr>
      <td class="txtNormal"><xsl:value-of select="/M750/RECORDING_DETAIL/NUM_REC" /></td>
      <td class="txtNormal" align="center"><xsl:value-of select="/M750/RECORDING_DETAIL/GUARDA_INI" /></td>
      <td class="txtNormal" align="center"><xsl:value-of select="/M750/RECORDING_DETAIL/GUARDA_FIN" /></td>
      <td class="txtNormal" align="center"><xsl:value-of select="/M750/RECORDING_DETAIL/SINT" /></td>
      <td class="txtNormal" align="center">
        <xsl:choose>
            <xsl:when test="/M750/RECORDING_DETAIL/SERIE='      0'">
            1x
            </xsl:when>
            <xsl:otherwise>
    			Serie
    		</xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
    </table>
    </p>
    <p>
    <table width="98%" border="0" cellspacing="0" cellpadding="1" align="center">
    <tr>
      <td class="titChannel">
        <xsl:value-of select="/M750/RECORDING_DETAIL/CHANNEL_NAME" /><br/>
        <xsl:value-of select="/M750/RECORDING_DETAIL/INIT_TIME" /> - <xsl:value-of select="/M750/RECORDING_DETAIL/END_TIME" />
      </td>
    </tr>
    <tr>
      <td class="titChannel" height="4"></td>
    </tr>
    <tr>
      <td class="txtNormal" align="left" valign="top">
        <p class="titChannel"><xsl:value-of select='/M750/RECORDING_DETAIL/TITLE' /></p>
        <p class="titTabla"><xsl:value-of select='/M750/RECORDING_DETAIL/EPG_SHORT' /></p>
        <p><textarea cols="120" class="cajaPlana" rows="20" name="texto"><xsl:value-of select='/M750/RECORDING_DETAIL/EPG_LONG' /></textarea></p>
      </td>
    </tr>
    </table>
    <xsl:copy-of select='document("/sincro/botones.xsl")'/>
    </p>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>
