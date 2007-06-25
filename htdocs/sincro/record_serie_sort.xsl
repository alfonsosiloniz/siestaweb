<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <link href="/sincro/img/m740.ico" rel="shortcut icon"></link>
  <title>M750T - Grabaciones Realizadas</title>
  <link href="/sincro/css/estilos.css" rel="stylesheet" type="text/css"></link>
  <script language="JavaScript" src="/sincro/js/ajax.js"></script>
  <script language="JavaScript" src="/sincro/js/blink.js"></script>
  <script language="JavaScript" src="/sincro/js/navigator.js"></script>
  <script language="JavaScript" src="/sincro/js/controlenviar.js"></script>
  <script>
  function deleteRec(crid) {
    if (confirm("¿Está seguro de querer eliminar definitivamente la grabación seleccionada?")) {
      //if (is_ie)
      mostrarMensajeProceso();
      makeRequest("/cgi-bin/crid/deleteRecording?" + crid, "procesarXMLRespuesta");
    }
  }
  function detail(id, crid) {
    document.location.href="/cgi-bin/crid/pendetailXML?" + parseInt(id, 16) + "-" + crid;
  }
  function procesarXMLRespuesta(xmldoc) {
    result = xmldoc.getElementsByTagName("RESULT");
    if (result[0].firstChild.data == "1") {
      document.location.reload();
    }
    else {
      //if (is_ie)
      eliminarMensajeProceso();
      alert("Borrado de Grabación NO aceptado por el M750");
    }
  }
  </script>
  <body>
    <div align="center" class="titPag"><p>M750T EPG</p></div>
    <div align="center" class="subTitPag">Grabaciones realizadas</div>
       <p> 
        <div align="center" class="txtNormal"><a href="javascript:history.back()">Atrás</a> | <a href="/cgi-bin/sincro/pgmactualXML">Inicio</a> | 
        <a href="/cgi-bin/crid/timerXML">Grabaciones Pendientes</a> | 
        <a href="/index.html">Salir</a><br/><br/>
        <a href="/osd/osd2tcp.html">Control OSD</a> | <a href="/cgi-bin/box/show/var/etc">Editor / Explorador de Archivos</a> |
        <a href="/cgi-bin/box/selectLiveTv">Ver LiveTV</a> | <a href="/sincro/visualizarts.html">Ver LiveTV-TS</a> | <a href="/ssh/sshconn.html">SSH</a></div>
    </p> 
    <div align="center" class="txtNormal">Espacio en disco: <xsl:value-of select="M750/SPACE"/><br/><br/></div>
    <table width="98%" border="0" cellspacing="0" cellpadding="2" align="center" class="borderTabla2">
    <tr bgcolor="#ffb310">
      <th class="fila" align="center">E   D   V</th>
      <th class="fila" align="left">Título</th>
      <th class="fila" align="left"><a href="/cgi-bin/crid/videoXML?time" title="Ordenar por Fecha">Inicio</a></th>
      <th class="fila" align="left">Final</th>
      <th class="fila" align="left">Duración (min)</th>
      <th class="fila" align="left">Tamaño</th>
    </tr>
    <xsl:for-each select="M750/RECORDINGS/RECORD">
    <xsl:sort select="SERIE_ID" order="descending" />
    <tr>
    <td class="fila" align="right" width="65">
        <xsl:choose>
        <xsl:when test="UTC_END_TIME &lt; /M750/RECORDINGS/@now">
            <xsl:element name="a">
    	    <xsl:attribute name="href">javascript:deleteRec("<xsl:value-of select="CRID_FILE"/>")</xsl:attribute>
    	    <img src="/sincro/img/red_ball.jpg" alt="Eliminar Grabación" width="18" height="18" border="0" />
    	    </xsl:element>
    	    <xsl:text> </xsl:text>
    	    <xsl:element name="a"><xsl:attribute name="href">/sincro/download.html?crid=<xsl:value-of select="CRID_FILE"/></xsl:attribute>
    	    <img src="/sincro/img/icon-save.gif" alt="Descargar Grabación" width="16" height="16" border="0" />
    	    </xsl:element>
    	    <xsl:text> </xsl:text>
    	    <xsl:element name="a"><xsl:attribute name="href">/sincro/visualizar.html?crid=<xsl:value-of select="CRID_FILE"/>&#x26;recording=no</xsl:attribute>
	        <img src="/sincro/img/muangelo.gif" alt="Visualizar Grabación" width="18" height="18" border="0" />
	        </xsl:element>
        </xsl:when>
        <xsl:otherwise>
            <xsl:element name="a"><xsl:attribute name="href">/sincro/visualizar.html?crid=<xsl:value-of select="CRID_FILE"/>&#x26;recording=yes</xsl:attribute>
	        <img src="/sincro/img/muangelo.gif" alt="Visualizar Grabación" width="18" height="18" border="0" />
	        </xsl:element>
        </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="fila">
        <xsl:element name="a">
	    <xsl:attribute name="href">/cgi-bin/crid/titleXML?<xsl:value-of select="CRID_FILE"/></xsl:attribute>
	    <xsl:value-of select="TITLE"/></xsl:element>
	    <xsl:choose>
	    <xsl:when test="UTC_END_TIME &gt; /M750/RECORDINGS/@now">
            <blink><font class="txtInfo">(en curso)</font></blink>
        </xsl:when>
        </xsl:choose>
      </td>
      <td class="fila"><xsl:value-of select="INIT_TIME"/></td>
      <td class="fila"><xsl:value-of select="END_TIME"/></td>
      <td class="fila"><xsl:value-of select="DURATION"/></td>
      <td class="fila"><xsl:value-of select="SPACE"/></td>
    </tr>
    </xsl:for-each>
    </table>
    <p>
        <div align="center" class="txtNormal"><a href="javascript:history.back()">Atrás</a> | <a href="/cgi-bin/sincro/pgmactualXML">Inicio</a> | 
        <a href="/cgi-bin/crid/timerXML">Grabaciones Pendientes</a> | 
        <a href="/index.html">Salir</a><br/><br/>
        <a href="/osd/osd2tcp.html">Control OSD</a> | <a href="/cgi-bin/box/show/var/etc">Editor / Explorador de Archivos</a> |
        <a href="/cgi-bin/box/selectLiveTv">Ver LiveTV</a> | <a href="/sincro/visualizarts.html">Ver LiveTV-TS</a> | <a href="/ssh/sshconn.html">SSH</a><br/><br/>
        <a href="/cgi-bin/sincro/verlog">Ver Log</a> | <a href="/cgi-bin/box/estado">Ver Estado</a></div>
    </p>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>
