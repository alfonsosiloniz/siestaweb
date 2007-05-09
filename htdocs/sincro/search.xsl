<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <title>M750T - Sincroguía</title>
  <link href="/sincro/img/m740.ico" rel="shortcut icon"></link>
  <link href="/sincro/css/estilos.css" rel="stylesheet" type="text/css"></link>
  <script language="JavaScript" src="/sincro/js/ajax.js"></script>
  <script language="JavaScript" src="/sincro/js/navigator.js"></script>
  <script language="JavaScript" src="/sincro/js/controlenviar.js"></script>
  <script language="JavaScript" src="/sincro/js/fechasOp.js"></script>
  <script>
  function record(id, serie, titulo) {
    enserie="";
    if (serie == 1)
        enserie="en serie ";
    if (confirm("¿Está seguro de querer grabar " + enserie + "el programa \"" + titulo + "\"?")) {
      if (is_ie)
        mostrarMensajeProceso();
      makeRequest("/cgi-bin/sincro/recordXML?" + parseInt(id, 16) + "-" + serie + "-" + new Date().getTime(), "mostrarXMLRespuesta");
    }
  }
  function mostrarXMLRespuesta(xmldoc) {
    if (is_ie)
      eliminarMensajeProceso();
    result = xmldoc.getElementsByTagName("RESULT");
    if (result[0].firstChild.data == "1")
      alert("Programación aceptada por el M750");
    else
      alert("Programación NO aceptada por el M750");
  }
  function detail(pid, img, long, channel, utc) {
    document.location.href="/cgi-bin/sincro/pgmdetailXML?"+parseInt(pid, 16)+"-"+img+"-"+long+"-"+channel+"-"+utc;
  }
  function noReply() {}
  function buscar() {
    if (is_ie)
      mostrarMensajeProceso();
    document.location.href="/cgi-bin/sincro/searchXML?" + document.forms['formulario'].querystr.value;
  }
  function buscarFH() {
    f=document.forms['formulario'];
    if (is_ie)
      mostrarMensajeProceso();
    document.location.href="/cgi-bin/sincro/searchXML?" + f.fecha.value + " " + f.hora.value;
  }
  function initFechas(fecha) {
    f=document.forms[0];
    var d = new Date();    
    dia=(""+d.getDate()).length == 1 ? "0" + d.getDate() : d.getDate();
    mes=(""+(d.getMonth()+1)).length == 1 ? "0" + (d.getMonth()+1) : (d.getMonth()+1);
    fullYear=""+d.getFullYear();
    year=fullYear.substring(2);
    f.fecha.length=7;
    f.fecha.options[0].text=dia+"."+mes+"."+fullYear;
    f.fecha.options[0].value=dia+"."+mes+"."+year;
    for(i=1; i &lt; 7; ++i) {
      f.fecha.options[i].text=incDate(f.fecha.options[i-1].text);
      f.fecha.options[i].value=f.fecha.options[i].text.substring(0,6)+f.fecha.options[i].text.substring(8);
    }
  }
  </script>
  <body bgcolor="#FFFFFF" onload="initFechas();">
  <form name="formulario">
    <div align="center"><p><font class="titPag">M750T EPG</font></p></div>
    <div align="center"><font class="subTitPag">Resultado de búsqueda</font></div>
    <p>
        <div align="center" class="txtNormal"><a href="javascript:history.back()">Atrás</a> | <a href="/cgi-bin/sincro/pgmactualXML">Inicio</a> | 
        <a href="/cgi-bin/crid/timerXML">Grabaciones Pendientes</a> | <a href="/cgi-bin/crid/videoXML">Grabaciones Realizadas</a> | 
        <a href="/index.html">Salir</a><br/><br/>
        <a href="/osd/osd2tcp.html">Control OSD</a> | <a href="/cgi-bin/box/show/var/etc">Editor / Explorador de Archivos</a></div>
    </p>
    <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td class="txtNormal" align="right">
        Buscar Programa: <input class="cajaplana" name="querystr" type="text" size="20" maxsize="50" value="" /> <input class="txtNormal" type="button" value="Buscar" onclick="buscar()" /><br/>
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
            <input class="txtNormal" type="button" value="Buscar" onclick="buscarFH()" />
      </td>
    </tr>
    </table>
    <xsl:for-each select="M740/SINCROGUIA/CHANNEL">
    <table width="98%" border="0" cellspacing="0" cellpadding="1" align="center">
    <tr>
      <td class="titChannel" align="left">
        <!--<xsl:element name="img">
        <xsl:attribute name="src">
        <xsl:text>/sincro/img/img</xsl:text>
        <xsl:value-of select="@id"/><xsl:text>.gif</xsl:text>
        </xsl:attribute>
        </xsl:element>-->
        <xsl:element name="a">
	    <xsl:attribute name="href">/cgi-bin/sincro/sincrochannelXML?<xsl:value-of select="@id"/>-0</xsl:attribute>
	    <xsl:value-of select="@name"/></xsl:element>
      </td>
    </tr>
    <tr>
      <td height="4"></td>
    </tr>
    </table>
    <table width="98%" border="0" cellspacing="0" cellpadding="2" align="center" class="borderTabla2">
    <tr bgcolor="#ffb310" class="fila">
      <th align="center" colspan="2" width="40" class="fila">Rec</th>
      <th align="left" width="15%" class="fila">Fecha/Hora</th>
      <th align="left" width="30%" class="fila">Título</th>
      <th align="left" width="50%" class="fila">Descripción</th>
    </tr>
    <xsl:for-each select="PROGRAM">
    <xsl:sort select="DATE_UTC"/>
    <tr>
      <td class="fila">
        <xsl:element name="a">
	    <xsl:attribute name="href">javascript:record("<xsl:value-of select="@pid"/>", 0, "<xsl:value-of select="TITLE"/>")</xsl:attribute>
	    <img src="/sincro/img/red_ball.jpg" alt="Grabar" width="18" height="18" border="0" />
	    </xsl:element>
      </td>
      <td class="fila">
        <xsl:element name="a">
	    <xsl:attribute name="href">javascript:record("<xsl:value-of select="@pid"/>", 1, "<xsl:value-of select="TITLE"/>")</xsl:attribute>
	    <img src="/sincro/img/blue_ball.jpg" alt="Grabar en Serie" width="18" height="18" border="0" />
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
                	    <xsl:attribute name="href">javascript:detail("<xsl:value-of select="@pid"/>", "<xsl:value-of select="IMAGE"/>", "<xsl:value-of select="LONG"/>", "<xsl:value-of select="@chid"/>", "<xsl:value-of select="DATE_UTC"/>")</xsl:attribute>
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
                        		<xsl:attribute name="src">/sincro/img/epg_long_img.png</xsl:attribute>
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
                                <xsl:attribute name="src">/sincro/epg/<xsl:value-of select="IMAGE"/></xsl:attribute>
                                <xsl:attribute name="width">77</xsl:attribute>
                                <xsl:attribute name="height">52</xsl:attribute>
                                <xsl:attribute name="border">0</xsl:attribute>
                                <xsl:attribute name="alt"><xsl:value-of select="TITLE"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="img">
                        		<xsl:attribute name="src">/sincro/img/epg_long_img.png</xsl:attribute>
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
            	    <xsl:attribute name="href">javascript:detail("<xsl:value-of select="@pid"/>", "<xsl:value-of select="IMAGE"/>", "<xsl:value-of select="LONG"/>", "<xsl:value-of select="@chid"/>", "<xsl:value-of select="DATE_UTC"/>")</xsl:attribute>
            	        <xsl:value-of select="TITLE"/>
            	    </xsl:element>
                </td>
            </tr>
            </table>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="a">
    	    <xsl:attribute name="href">javascript:detail("<xsl:value-of select="@pid"/>", "<xsl:value-of select="IMAGE"/>", "<xsl:value-of select="LONG"/>", "<xsl:value-of select="@chid"/>", "<xsl:value-of select="DATE_UTC"/>")</xsl:attribute>
    	        <xsl:value-of select="TITLE"/>
    	    </xsl:element>
         </xsl:otherwise>
         </xsl:choose>
      </td>
      <td class="fila"><xsl:value-of select="SUBTITLE"/></td>
    </tr>
    </xsl:for-each>
    </table><br/>
    </xsl:for-each>
    <p>
        <div align="center" class="txtNormal"><a href="javascript:history.back()">Atrás</a> | <a href="/cgi-bin/sincro/pgmactualXML">Inicio</a> | 
        <a href="/cgi-bin/crid/timerXML">Grabaciones Pendientes</a> | <a href="/cgi-bin/crid/videoXML">Grabaciones Realizadas</a> | <a href="/index.html">Salir</a><br/><br/>
        <a href="/osd/osd2tcp.html">Control OSD</a> | <a href="/cgi-bin/box/show/var/etc">Editor / Explorador de Archivos</a><br/><br/>
        <a href="/autores.html">Autores</a> | <a href="/cgi-bin/sincro/verlog">Ver Log</a> | <a href="/cgi-bin/box/estado">Ver Estado</a></div>
    </p>
    </form>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>
