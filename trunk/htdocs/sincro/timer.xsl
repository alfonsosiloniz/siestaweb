<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <title>M750T - Grabaciones Pendientes</title>
  <link href="/sincro/img/m740.ico" rel="shortcut icon"></link>
  <link href="/sincro/css/estilos.css" rel="stylesheet" type="text/css"></link>
  <script language="JavaScript" src="/sincro/js/ajax.js"></script>
  <script language="JavaScript" src="/sincro/js/navigator.js"></script>
  <script language="JavaScript" src="/sincro/js/controlenviar.js"></script>
  <script>
  function cancel(id) {
    if (confirm("¿Está seguro de querer cancelar la grabación seleccionada?")) {
      if (is_ie)
        mostrarMensajeProceso();
      makeRequest("/cgi-bin/sincro/cancelXML?" + parseInt(id, 16), "procesarXMLRespuesta");
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
      alert("Cancelación NO aceptada por el M750");
    }
  }
  function abreVentanaCentradaPopUp(URL,ancho,alto) {
    LeftPosition = (screen.width) ? (screen.width-ancho)/2 : 0;
    TopPosition = (screen.height) ? (screen.height-alto)/2 : 0; 
    nuevo = window.open(URL,'pa','width='+ancho+',height='+alto+',top='+TopPosition+',left='+LeftPosition+',resizable=yes,statusbar=no,scrollbars=yes,help=no,center=yes,location=no');
  }
  </script>
  <body>
    <div align="center" class="titPag"><p>M750T EPG</p></div>
    <div align="center" class="subTitPag">Grabaciones pendientes</div>
       <p> 
        <div align="center" class="txtNormal"><a href="javascript:history.back()">Atrás</a> | <a href="/cgi-bin/sincro/pgmactualXML">Inicio</a> | 
        <a href="/cgi-bin/crid/videoXML">Grabaciones Realizadas</a> | 
        <a href="/index.html">Salir</a><br/><br/>
        <a href="/osd/osd2tcp.html">Control OSD</a> | <a href="/cgi-bin/box/show/var/etc">Editor / Explorador de Archivos</a> |
        <a href="/cgi-bin/box/selectLiveTv">Ver LiveTV</a> | <a href="/sincro/visualizarts.html">Ver LiveTV+10</a> | <a href="/ssh/sshconn.html">SSH/Telnet</a></div> 
    </p> 
    <div align="center" class="txtNormal">Espacio en disco: <xsl:value-of select="M750/SPACE"/><br/><br/></div> 
    <table width="98%" border="0" cellspacing="0" cellpadding="2" align="center" class="borderTabla2">
    <tr bgcolor="#ffb310">
      <th class="fila" align="center" width="20">C</th>
      <th class="fila" align="left">Título</th>
      <th class="fila" align="left">Inicio</th>
      <th class="fila" align="left">Final</th>
      <th class="fila" align="left">Duración (min)</th>
    </tr>
    <xsl:for-each select="M750/TIMER/RECORD">
    <xsl:sort select="UTC_TIME"/>
    <tr>
      <td class="fila">
        <xsl:element name="a">
	    <xsl:attribute name="href">javascript:cancel("<xsl:value-of select="PIDCID"/>")</xsl:attribute>
	    <img src="/sincro/img/red_ball.jpg" alt="Cancelar Grabación Pendiente" width="18" height="18" border="0" />
	    </xsl:element>
      </td>
      <td class="fila">
        <xsl:element name="a">
	    <xsl:attribute name="href">javascript:detail("<xsl:value-of select="PIDCID"/>","<xsl:value-of select="CRID_FILE"/>")</xsl:attribute>
	        <xsl:value-of select="TITLE"/>
	    </xsl:element>
      </td>
      <td class="fila"><xsl:value-of select="INIT_TIME"/></td>
      <td class="fila"><xsl:value-of select="END_TIME"/></td>
      <td class="fila"><xsl:value-of select="DURATION"/></td>
    </tr>
    </xsl:for-each>
    </table>
    <p>
        <div align="center" class="txtNormal"><a href="javascript:history.back()">Atrás</a> | <a href="/cgi-bin/sincro/pgmactualXML">Inicio</a> | 
        <a href="/cgi-bin/crid/videoXML">Grabaciones Realizadas</a> | 
        <a href="/index.html">Salir</a><br/><br/>
        <a href="/osd/osd2tcp.html">Control OSD</a> | <a href="/cgi-bin/box/show/var/etc">Editor / Explorador de Archivos</a> |
        <a href="/cgi-bin/box/selectLiveTv">Ver LiveTV</a> | <a href="/sincro/visualizarts.html">Ver LiveTV+10</a> | <a href="/ssh/sshconn.html">SSH/Telnet</a><br/><br/>
        <a href="/cgi-bin/sincro/verlog">Ver Log</a> | <a href="/cgi-bin/box/estado">Ver Estado</a></div>
    </p>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>
