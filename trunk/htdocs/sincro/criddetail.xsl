<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <head>
  <title>M750T - Detalle de grabación</title>
  <link href="/sincro/img/m740.ico" rel="shortcut icon"></link>
  <link href="/sincro/css/estilos.css" rel="stylesheet" type="text/css"></link>
  <script language="JavaScript" src="/sincro/js/botones.js"></script>
  <script>
    function editar() {
        document.location.href="/cgi-bin/crid/edittitleXML?<xsl:value-of select="/M750/RECORD_DETAIL/CRIDFILE" />";
    }
  </script>
  </head>
  <body>
  <form name="formulario" method="post">
    <div align="center"><p><font class="titPag">M750T EPG</font></p></div>
    <div align="center"><font class="subTitPag">Detalle de Grabación</font></div>
    <script language="JavaScript">barra_botones();</script>
    <p>
    <table width="98%" border="0" cellspacing="0" cellpadding="1" align="center">
    <tr>
      <td class="titChannel">
        <xsl:value-of select="/M750/RECORD_DETAIL/CHANNEL_NAME" /><br/>
        <xsl:value-of select="/M750/RECORD_DETAIL/INIT_TIME" /> - <xsl:value-of select="/M750/RECORD_DETAIL/END_TIME" />
      </td>
    </tr>
    <tr>
      <td class="titChannel" height="4"></td>
    </tr>
    <tr>
      <td class="txtNormal" align="left" valign="top">
        <p class="titChannel"><xsl:value-of select='/M750/RECORD_DETAIL/TITLE' /></p>
        <p class="titTabla"><xsl:value-of select='/M750/RECORD_DETAIL/EPG_SHORT' /></p>
        <p><textarea cols="120" class="cajaPlana" rows="20" name="texto"><xsl:value-of select='/M750/RECORD_DETAIL/EPG_LONG' /></textarea></p>
        <input class="txtNormal" type="button" value="Editar" onclick="editar()" /><br/>
      </td>
    </tr>
    </table>
    <script language="JavaScript">barra_botones();</script>
    </p>
  </form>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>
