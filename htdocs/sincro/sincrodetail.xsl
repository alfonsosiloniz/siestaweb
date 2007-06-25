<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <title>M750T - Sincroguía</title>
  <link href="/sincro/img/m740.ico" rel="shortcut icon"></link>
  <link href="/sincro/css/estilos.css" rel="stylesheet" type="text/css"></link>
  <script type="text/javascript" language="JavaScript" src="/sincro/js/ajax.js"></script>
  <script type="text/javascript" language="JavaScript" src="/sincro/js/navigator.js"></script>
  <script type="text/javascript" language="JavaScript" src="/sincro/js/controlenviar.js"></script>
  <script type="text/javascript">
  function record(id, serie) {
    if (confirm("¿Está seguro de querer grabar el programa?")) {
      //if (is_ie)
      mostrarMensajeProceso();
      makeRequest("/cgi-bin/sincro/recordXML?" + id + "-" + serie + "-" + new Date().getTime(), "mostrarXMLRespuesta");
    }
  }
  function cancel(id) {
    if (confirm("¿Está seguro de querer cancelar la grabación?")) {
      //if (is_ie)
      mostrarMensajeProceso();
      makeRequest("/cgi-bin/sincro/cancelXML?" + id, "procesarXMLRespuesta");
    }
  }
  function sincroDetail(id) {
    pid=id.substring(0, 7);
    window.open("http://www.inout.tv/SincroGuia/ficha.php?id="+pid);
  }
  function mostrarXMLRespuesta(xmldoc) {
    //if (is_ie)
    eliminarMensajeProceso();
    result = xmldoc.getElementsByTagName("RESULT");
    if (result[0].firstChild.data == "1")
      alert("Programación aceptada por el M750");
    else
      alert("Programación NO aceptada por el M750");
  }
  </script>
  <body>
    <div align="center"><p><font class="titPag">M750T EPG</font></p></div>
    <div align="center"><font class="subTitPag">Detalle de programa</font></div>
    <p>
        <div align="center" class="txtNormal"><a href="javascript:history.back()">Atrás</a> | <a href="/cgi-bin/sincro/pgmactualXML">Inicio</a> | 
        <a href="/cgi-bin/crid/timerXML">Grabaciones Pendientes</a> | <a href="/cgi-bin/crid/videoXML">Grabaciones Realizadas</a> | 
        <a href="/index.html">Salir</a><br/><br/><a href="/osd/osd2tcp.html">Control OSD</a></div>
    </p>
    <xsl:choose>
    <xsl:when test="/M750/PGMDETAIL/PROGRAMMED='1'">
        <p><table width="350" border="0" cellspacing="0" cellpadding="1" align="center">
        <tr><td width="100%" align="center" bgcolor="#ffb310" class="titTabla" height="20">Evento programado en Grabaciones Pendientes</td></tr>
        </table></p>
    </xsl:when>
    </xsl:choose>    
    <p><table width="98%" border="0" cellspacing="0" cellpadding="1" align="center">
    <tr>
      <td colspan="2" class="titChannel">
        <xsl:value-of select="/M750/PGMDETAIL/CHANNEL_ID" /> - 
        <xsl:value-of select="/M750/PGMDETAIL/DATE" />
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
        <textarea cols="100" class="cajaPlana" rows="20" name="texto"><xsl:value-of select='/M750/PGMDETAIL/TEXT' /></textarea>
      </td>
    </tr>
    </table>
    </p>
    <div align="center" class="txtNormal">
        <xsl:choose>
        <xsl:when test="/M750/PGMDETAIL/PROGRAMMED='0'">
            <xsl:element name="a">
    	    <xsl:attribute name="href">javascript:record("<xsl:value-of select="/M750/PGMDETAIL/PIDCID" />", 0)</xsl:attribute>
    	    <img src="/sincro/img/red_ball.jpg" alt="Grabar" width="18" height="18" border="0" />Grabar</xsl:element> | 
        </xsl:when>
        <xsl:otherwise>
            <xsl:element name="a">
    	    <xsl:attribute name="href">javascript:cancel("<xsl:value-of select="/M750/PGMDETAIL/PIDCID" />")</xsl:attribute>
    	    <img src="/sincro/img/red_ball.jpg" alt="Grabar" width="18" height="18" border="0" />Cancelar Grabación</xsl:element> | 
		</xsl:otherwise>
        </xsl:choose>
	    <xsl:element name="a">
	    <xsl:attribute name="href">javascript:record("<xsl:value-of select="/M750/PGMDETAIL/PIDCID" />", 1)</xsl:attribute>
	    <img src="/sincro/img/blue_ball.jpg" alt="Grabar en Serie" width="18" height="18" border="0" />Grabar en Serie</xsl:element> | 
	    <xsl:element name="a">
	    <xsl:attribute name="href">javascript:sincroDetail("<xsl:value-of select="/M750/PGMDETAIL/PIDCID" />")</xsl:attribute>
	    <img src="/sincro/img/sincro_small.gif" alt="Grabar" width="18" height="18" border="0" />Ficha Sincroguía InOut</xsl:element>
    </div>
    <br/>
    <p>
        <div align="center" class="txtNormal"><a href="javascript:history.back()">Atrás</a> | <a href="/cgi-bin/sincro/pgmactualXML">Inicio</a> | 
        <a href="/cgi-bin/crid/timerXML">Grabaciones Pendientes</a> | <a href="/cgi-bin/crid/videoXML">Grabaciones Realizadas</a> | 
        <a href="/index.html">Salir</a></div>
    </p>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>
