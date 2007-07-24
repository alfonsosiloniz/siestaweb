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
    <xsl:copy-of select='document("/sincro/botones.xsl")'/>
    <table width="98%" border="0" cellspacing="0" cellpadding="2" align="center" class="borderTabla2">
    <tr bgcolor="#ffb310">
      <th class="titTabla" align="left"></th>
      <th class="titTabla" align="left">Título</th>
      <th class="titTabla" align="left">Inicio</th>
      <th class="titTabla" align="left">Final</th>
      <th class="titTabla" align="left">Duración (min)</th>
    </tr>
    <xsl:for-each select="M750/RECORDINGS/RECORD">
    <!--<xsl:sort select="UTC_TIME" order="descending" />-->
    <xsl:sort select="SERIE_ID" order="descending" />
    <tr>
        <td class="txtNormal" colspan="5" height="1" bgcolor="black"></td>
    </tr>
    <tr>
      <td class="txtNormal">
        <xsl:element name="a">
	    <xsl:attribute name="href">javascript:deleteRec("<xsl:value-of select="CRID_FILE"/>")</xsl:attribute>
	    <img src="/sincro/img/red_ball.jpg" alt="Eliminar Grabación" width="18" height="18" border="0" />
	    </xsl:element>
      </td>
      <td class="txtNormal">
        <xsl:element name="a">
	    <xsl:attribute name="href">/cgi-bin/crid/titleXML?<xsl:value-of select="CRID_FILE"/></xsl:attribute>
	    <xsl:value-of select="TITLE"/></xsl:element>
      </td>
      <td class="txtNormal"><xsl:value-of select="INIT_TIME"/></td>
      <td class="txtNormal"><xsl:value-of select="END_TIME"/></td>
      <td class="txtNormal"><xsl:value-of select="DURATION"/></td>
    </tr>
    </xsl:for-each>
    </table>
    <xsl:copy-of select='document("/sincro/botones.xsl")'/>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>
