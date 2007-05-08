<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <link href="/sincro/img/m740.ico" rel="shortcut icon"></link>
  <title>M750T - Grabaciones Realizadas</title>
  <link href="/sincro/css/estilos.css" rel="stylesheet" type="text/css"></link>
  <script language="JavaScript" src="/sincro/js/ajax.js"></script>
  <script language="JavaScript" src="/sincro/js/navigator.js"></script>
  <script language="JavaScript" src="/sincro/js/controlenviar.js"></script>
  <script>
  function deleteRec(crid) {
    if (confirm("�Est� seguro de querer eliminar definitivamente la grabaci�n seleccionada?")) {
      if (is_ie)
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
      if (is_ie)
        eliminarMensajeProceso();
      alert("Borrado de Grabaci�n NO aceptado por el M750");
    }
  }
  </script>
  <body>
    <div align="center" class="titPag"><p>M750T EPG</p></div>
    <div align="center" class="subTitPag">Grabaciones realizadas</div>
       <p> 
        <div align="center" class="txtNormal"><a href="javascript:history.back()">Atr�s</a> | <a href="/cgi-bin/sincro/pgmactualXML">Inicio</a> | 
        <a href="/cgi-bin/crid/timerXML">Grabaciones Pendientes</a> | 
        <a href="/index.html">Salir</a><br/><br/><a href="/osd/osd2tcp.html">Control OSD</a> | <a href="/cgi-bin/box/show/var/media/USB-HDD">Editor / Explorador de Archivos</a></div> 
    </p> 
    <div align="center" class="txtNormal">Espacio en disco: <xsl:value-of select="M750/SPACE"/><br/><br/></div>
    <table width="98%" border="0" cellspacing="0" cellpadding="2" align="center" class="borderTabla2">
    <tr bgcolor="#ffb310">
      <th class="fila" align="center">E   D</th>
      <th class="fila" align="left">T�tulo</th>
      <th class="fila" align="left"><a href="/cgi-bin/crid/videoXML?time" title="Ordenar por Fecha">Inicio</a></th>
      <th class="fila" align="left">Final</th>
      <th class="fila" align="left">Duraci�n (min)</th>
    </tr>
    <xsl:for-each select="M750/RECORDINGS/RECORD">
    <xsl:sort select="SERIE_ID" order="descending" />
    <tr>
      <td class="fila" valign="middle">
        <xsl:element name="a">
	    <xsl:attribute name="href">javascript:deleteRec("<xsl:value-of select="CRID_FILE"/>")</xsl:attribute>
	    <img src="/sincro/img/red_ball.jpg" alt="Eliminar Grabaci�n" width="18" height="18" border="0" />
	    </xsl:element>
	    <xsl:text> </xsl:text>
	    <xsl:element name="a"><xsl:attribute name="href">/sincro/download.html?crid=<xsl:value-of select="CRID_FILE"/></xsl:attribute>
	    <img src="/sincro/img/icon-save.gif" alt="Descargar Grabaci�n" width="16" height="16" border="0" />
	    </xsl:element>
      </td>
      <td class="fila">
        <xsl:element name="a">
	    <xsl:attribute name="href">/cgi-bin/crid/titleXML?<xsl:value-of select="CRID_FILE"/></xsl:attribute>
	    <xsl:value-of select="TITLE"/></xsl:element>
      </td>
      <td class="fila"><xsl:value-of select="INIT_TIME"/></td>
      <td class="fila"><xsl:value-of select="END_TIME"/></td>
      <td class="fila"><xsl:value-of select="DURATION"/></td>
    </tr>
    </xsl:for-each>
    </table>
    <p>
        <div align="center" class="txtNormal"><a href="javascript:history.back()">Atr�s</a> | <a href="/cgi-bin/sincro/pgmactualXML">Inicio</a> | 
        <a href="/cgi-bin/crid/timerXML">Grabaciones Pendientes</a> | 
        <a href="/index.html">Salir</a><br/><br/><a href="/osd/osd2tcp.html">Control OSD</a> | <a href="/cgi-bin/box/show/var/media/USB-HDD">Editor / Explorador de Archivos</a></div>
    </p>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>
