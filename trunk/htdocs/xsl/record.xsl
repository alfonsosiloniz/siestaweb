<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
	<link rel="icon" href="/favicon.ico" type="image/x-icon"/>
	<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" href="/css/estilos.css" type="text/css"/>
	<script type="text/javascript" src="/js/ajax.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/blink.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/navigator.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/controlenviar.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/botones.js" charset="ISO-8859-1"></script>
	<script type="text/javascript" src="/js/m750.js" charset="ISO-8859-1"></script>
	<xsl:choose>
		<xsl:when test="/M750/CARPETA_REALPATH=/M750/CARPETA_ARCHIVO_REALPATH">
			<title>M750T - Archivo de Grabaciones</title>
		</xsl:when>
		<xsl:otherwise>
			<title>M750T - Grabaciones Realizadas</title>
		</xsl:otherwise>
	</xsl:choose>
</head>
<body bgcolor="#FFFFFF">
	<form name="form_m750">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td align="center">
				<font class="titPag">M750T EPG</font>
				<br/>
				<xsl:choose>
					<xsl:when test="/M750/CARPETA_REALPATH=/M750/CARPETA_GRABACIONES_REALPATH">
						<font class="subTitPag">Grabaciones Realizadas</font>
					</xsl:when>
					<xsl:when test="/M750/CARPETA_REALPATH=/M750/CARPETA_ARCHIVO_REALPATH">
						<font class="subTitPag">Archivo de Grabaciones</font>
					</xsl:when>
					<xsl:otherwise>
						<font class="subTitPag">Grabaciones Realizadas - <xsl:value-of select="/M750/CARPETA"/></font>
					</xsl:otherwise>
				</xsl:choose>
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
			<td class="txtNormal" align="center">
				<br/>
				Espacio en disco: <xsl:value-of select="/M750/SPACE"/>
				<br/>
				<br/>
				<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center" class="borderTabla_sup">
					<tr class="filaTitulo">
						<th width="18" align="center">&#160;</th>
						<th width="18" align="center">B</th>
						<xsl:choose>
							<xsl:when test="/M750/CARPETA_REALPATH=/M750/CARPETA_GRABACIONES_REALPATH">
								<th width="18" align="center">A</th>
							</xsl:when>
							<xsl:when test="/M750/CARPETA_REALPATH=/M750/CARPETA_ARCHIVO_REALPATH">
								<th width="18" align="center">R</th>
							</xsl:when>
						</xsl:choose>
						<th width="18" align="center">C</th>
						<th width="18" align="center">M</th>
						<th width="18" align="center">D</th>
						<th width="18" align="center">E</th>
						<th width="18" align="center">V</th>
						<th align="center">TV</th>
						<xsl:choose>
							<xsl:when test="/M750/@orden='serie'">
								<th align="left">Título</th>
								<th align="left">
									<xsl:element name="a">
										<xsl:attribute name="title">Ordenar por Fecha</xsl:attribute>
										<xsl:choose>
											<xsl:when test="/M750/CARPETA_REALPATH=/M750/CARPETA_ARCHIVO_REALPATH">
												<xsl:attribute name="href">/cgi-bin/crid/ver-lista-archivo?time</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="href">/cgi-bin/crid/ver-lista-grabaciones?time&amp;<xsl:value-of select="/M750/CARPETA"/></xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
										Inicio
									</xsl:element>
								</th>
							</xsl:when>
							<xsl:otherwise>
								<th align="left">
									<xsl:element name="a">
										<xsl:attribute name="title">Ordenar por Series</xsl:attribute>
										<xsl:choose>
											<xsl:when test="/M750/CARPETA_REALPATH=/M750/CARPETA_ARCHIVO_REALPATH">
												<xsl:attribute name="href">/cgi-bin/crid/ver-lista-archivo?serie</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="href">/cgi-bin/crid/ver-lista-grabaciones?serie&amp;<xsl:value-of select="/M750/CARPETA"/></xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
										Título
									</xsl:element>
								</th>
								<th align="left">Inicio</th>
							</xsl:otherwise>
						</xsl:choose>
						<th align="left">Final</th>
						<th align="center">Duración (min)</th>
						<th align="right">Tamaño</th>
						<th align="center">&#160;</th>
						<th width="22" align="center">&#160;</th>
						<th width="22" align="center">&#160;</th>
						<th width="22" align="center">&#160;</th>
						<th width="22" align="center">&#160;</th>
					</tr>
					<xsl:for-each select="/M750/RECORD/CRID">
					<xsl:sort select="ORDEN" order="descending" />
						<xsl:choose>
							<xsl:when test="/M750/@orden='serie'">
								<xsl:choose>
									<xsl:when test="CAMBIO_SERIE='1'">
										<tr><td colspan="19" bgcolor="black" style="height: 1px;"></td></tr>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="CAMBIO_SERIE='1' and SERIE_ID &lt; '0'">
										<tr>
											<td class="txtGrande" style="border-bottom: solid Black 1px;" colspan="9" height="20">&#160;</td>
											<td class="txtGrande" style="border-bottom: solid Black 1px;" colspan="10"><xsl:value-of select="TITLE"/></td>
										</tr>
									</xsl:when>
									<xsl:when test="CAMBIO_SERIE='1' and SERIE_ID &gt; '0'">
										<tr>
											<td class="txtGrande" style="border-bottom: solid Black 1px;" colspan="9" height="20">&#160;</td>
											<td class="txtGrande" style="border-bottom: solid Black 1px;" colspan="10">Lo mejor de ...</td>
										</tr>
									</xsl:when>
								</xsl:choose>
							</xsl:when>
						</xsl:choose>
						<tr class="filaResalte">
							<xsl:choose>
								<xsl:when test="REC_STATE!='2'">
									<td align="center">
										<xsl:element name="input">
											<xsl:attribute name="type">checkbox</xsl:attribute>
											<xsl:attribute name="name">CRID_<xsl:value-of select="CRID_FILE"/></xsl:attribute>
											<xsl:attribute name="value"><xsl:value-of select="CRID_FILE"/></xsl:attribute>
										</xsl:element>
									</td>
									<td align="center">
										<xsl:element name="a">
											<xsl:attribute name="title">Eliminar Grabación</xsl:attribute>
												<xsl:choose>
													<xsl:when test="/M750/CARPETA_REALPATH=/M750/CARPETA_GRABACIONES_REALPATH">
														<xsl:attribute name="href">javascript:borrarGrabacion("<xsl:value-of select="CRID_FILE"/>","<xsl:value-of select="TITLE"/>")</xsl:attribute>
													</xsl:when>
													<xsl:otherwise>
														<xsl:attribute name="href">javascript:borrarGrabacionCompleta("<xsl:value-of select="CRID_FILE"/>","<xsl:value-of select="TITLE"/>")</xsl:attribute>
													</xsl:otherwise>
												</xsl:choose>
											<img src="/img/icon-borrar.png" width="16" height="16" border="0" />
										</xsl:element>
									</td>
									<xsl:choose>
										<xsl:when test="/M750/CARPETA_REALPATH=/M750/CARPETA_GRABACIONES_REALPATH">
											<td align="center">
												<xsl:element name="a">
													<xsl:attribute name="title">Archivar Grabación</xsl:attribute>
													<xsl:attribute name="href">javascript:archivarGrabacion("<xsl:value-of select="CRID_FILE"/>","<xsl:value-of select="TITLE"/>")</xsl:attribute>
													<img src="/img/icon-rec2arch.png" width="16" height="16" border="0" />
												</xsl:element>
											</td>
										</xsl:when>
										<xsl:when test="/M750/CARPETA_REALPATH=/M750/CARPETA_ARCHIVO_REALPATH">
											<td align="center">
												<xsl:element name="a">
													<xsl:attribute name="title">Restaurar Grabación</xsl:attribute>
													<xsl:attribute name="href">javascript:restaurarGrabacion("<xsl:value-of select="CRID_FILE"/>","<xsl:value-of select="TITLE"/>")</xsl:attribute>
													<img src="/img/icon-arch2rec.png" width="16" height="16" border="0" />
												</xsl:element>
											</td>
										</xsl:when>
									</xsl:choose>
									<td align="center">
										<xsl:element name="a">
											<xsl:attribute name="title">Copiar Grabación</xsl:attribute>
											<xsl:attribute name="href">javascript:copiarGrabacion('<xsl:value-of select="CRID_FILE"/>','<xsl:value-of select="TITLE"/>','<xsl:value-of select="/M750/CARPETA_CPMV"/>')</xsl:attribute>
											<img src="/img/icon-copy.png" width="16" height="16" border="0" />
										</xsl:element>
									</td>
									<td align="center">
										<xsl:element name="a">
											<xsl:attribute name="title">Mover Grabación</xsl:attribute>
											<xsl:attribute name="href">javascript:moverGrabacion('<xsl:value-of select="CRID_FILE"/>','<xsl:value-of select="TITLE"/>','<xsl:value-of select="/M750/CARPETA_CPMV"/>')</xsl:attribute>
											<img src="/img/icon-cut.png" width="16" height="16" border="0" />
										</xsl:element>
									</td>
									<td align="center">
										<xsl:element name="a">
											<xsl:attribute name="title">Descargar Grabación</xsl:attribute>
											<xsl:attribute name="href">javascript:descargarGrabacion('<xsl:value-of select="CRID_FILE"/>')</xsl:attribute>
											<img src="/img/icon-save.png" width="16" height="16" border="0" />
										</xsl:element>
									</td>
									<td align="center">
										<xsl:element name="a">
											<xsl:attribute name="title">Editar Grabación</xsl:attribute>
											<xsl:attribute name="href">javascript:editCrid('<xsl:value-of select="CRID_FILE"/>')</xsl:attribute>
											<img src="/img/icon-edit.png" width="16" height="16" border="0" />
										</xsl:element>
									</td>
									<td align="center">
										<xsl:element name="a">
											<xsl:attribute name="title">Visualizar Grabación</xsl:attribute>
											<xsl:attribute name="href">/cgi-bin/box/ctl-verCrid?CRIDFILE=<xsl:value-of select="CRID_FILE"/>&#x26;RECORDING=NO</xsl:attribute>
											<img src="/img/icon-ver.png" width="16" height="16" border="0" />
										</xsl:element>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td align="center">&#160;</td>
									<td align="center">&#160;</td>
									<td align="center">&#160;</td>
									<td align="center">&#160;</td>
									<td align="center">&#160;</td>
									<td align="center">&#160;</td>
									<td align="center">&#160;</td>
									<td align="center">
										<xsl:element name="a">
											<xsl:attribute name="title">Visualizar Grabación</xsl:attribute>
											<xsl:attribute name="href">/cgi-bin/box/ctl-verCrid?CRIDFILE=<xsl:value-of select="CRID_FILE"/>&#x26;RECORDING=SI</xsl:attribute>
											<img src="/img/icon-ver.png" width="16" height="16" border="0" />
										</xsl:element>
									</td>
								</xsl:otherwise>
							</xsl:choose>
							<td align="center"><xsl:value-of select="CH_ID"/></td>
							<td>
								<xsl:element name="a">
									<xsl:attribute name="href">javascript:detalleCrid('<xsl:value-of select="CRID_FILE"/>')</xsl:attribute>
									<xsl:value-of select="TITLE"/>
								</xsl:element>
								<xsl:choose>
									<xsl:when test="REC_STATE='2'">
										<blink><font class="txtInfo"> (en curso)</font></blink>
									</xsl:when>
								</xsl:choose>
							</td>
							<td><xsl:value-of select="INIT_TIME"/></td>
							<td><xsl:value-of select="END_TIME"/></td>
							<td align="center"><xsl:value-of select="DURATION"/></td>
							<td align="right">
								<xsl:choose>
									<xsl:when test="NUM_FMPG &gt; '1'">
										<font title="Número de fragmentos de grabación">( <xsl:value-of select="NUM_FMPG"/> )</font>&#160;
									</xsl:when>
								</xsl:choose>
								<xsl:value-of select="SPACE"/>
							</td>
							<td align="center">&#160;</td>
							<td align="center">
								<xsl:choose>
									<xsl:when test="REC_STATE='2'">
										<img src="/img/skin/Record_rot.png" title="En grabación" width="20" height="20" border="0" />
									</xsl:when>
									<xsl:when test="REC_STATE='3'">
										<xsl:choose>
											<xsl:when test="PLAYBACK_TS='0'">
												<img src="/img/skin/Icon_record_OK.png" title="Grabación correcta" width="20" height="20" border="0" />
											</xsl:when>
											<xsl:otherwise>
												<img src="/img/skin/Icon_record_OK_played.png" title="Grabación correcta con visionado" width="20" height="20" border="0" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="REC_STATE='4'">
										<xsl:choose>
											<xsl:when test="PLAYBACK_TS='0'">
												<img src="/img/skin/failed_icon.png" title="Grabación erronea" width="20" height="20" border="0" />
											</xsl:when>
											<xsl:otherwise>
												<img src="/img/skin/failed_icon_played.png" title="Grabación erronea con visionado" width="20" height="20" border="0" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
							<td align="center">
								<xsl:choose>
									<xsl:when test="SERIE_ID &lt; '0'">
										<img src="/img/skin/Icon_serie.png" title="Grabación en Serie" width="20" height="20" border="0" />
									</xsl:when>
									<xsl:when test="SERIE_ID &gt; '0'">
										<img src="/img/star_record.png" title="Grabación de Lo mejor de la TV" width="20" height="20" border="0" />
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
							<td align="center">
								<xsl:choose>
									<xsl:when test="IMPORTANT='1'">
										<img src="/img/skin/important_icon.png" title="Grabación protegida" width="20" height="20" border="0" />
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
							<td align="center">
								<xsl:choose>
									<xsl:when test="REC_STATE!='2' and ERROR_END_TIMESTAMP='1'">
										<img src="/img/error_end_timestamp.png" title="Detectado error end_timestamp" width="16" height="16" border="0" />
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</td>
		</tr>
	</table>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td>
				<table border="0" cellspacing="0" cellpadding="2" align="left">
					<tr>
						<td width="40" align="center" valign="center">
							<img src="/img/arrow_ltr.png" width="38" height="22" border="0" />
						</td>
						<td class="txtPeq" valign="center">
							<a title="Marcar todos" href="javascript:MarcarTodos('CRID_',true);">Marcar todos</a>
							/
							<a title="Desmarcar todos" href="javascript:MarcarTodos('CRID_',false);">Desmarcar todos</a>
							Para los elementos que están marcados:&#160;
						</td>
						<td align="center" valign="bottom">
							<xsl:element name="a">
								<xsl:attribute name="title">Eliminar grabaciones marcadas</xsl:attribute>
									<xsl:choose>
										<xsl:when test="/M750/CARPETA_REALPATH=/M750/CARPETA_GRABACIONES_REALPATH">
											<xsl:attribute name="href">javascript:borrarGrabacionMarcada('CRID_')</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="href">javascript:borrarGrabacionCompletaMarcada('CRID_')</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								<img src="/img/icon-borrar.png" width="16" height="16" border="0" />
							</xsl:element>
						</td>
						<xsl:choose>
							<xsl:when test="/M750/CARPETA_REALPATH=/M750/CARPETA_GRABACIONES_REALPATH">
								<td align="center" valign="bottom">
									<xsl:element name="a">
										<xsl:attribute name="title">Archivar grabaciones marcadas</xsl:attribute>
										<xsl:attribute name="href">javascript:archivarGrabacionMarcada('CRID_')</xsl:attribute>
										<img src="/img/icon-rec2arch.png" width="16" height="16" border="0" />
									</xsl:element>
								</td>
							</xsl:when>
							<xsl:when test="/M750/CARPETA_REALPATH=/M750/CARPETA_ARCHIVO_REALPATH">
								<td align="center" valign="bottom">
									<xsl:element name="a">
										<xsl:attribute name="title">Restaurar grabaciones marcadas</xsl:attribute>
										<xsl:attribute name="href">javascript:restaurarGrabacionMarcada('CRID_')</xsl:attribute>
										<img src="/img/icon-arch2rec.png" width="16" height="16" border="0" />
									</xsl:element>
								</td>
							</xsl:when>
						</xsl:choose>
						<td align="center" valign="bottom">
							<xsl:element name="a">
								<xsl:attribute name="title">Copiar grabaciones marcadas</xsl:attribute>
								<xsl:attribute name="href">javascript:copiarGrabacionMarcada('CRID_','<xsl:value-of select="/M750/CARPETA_CPMV"/>')</xsl:attribute>
								<img src="/img/icon-copy.png" width="16" height="16" border="0" />
							</xsl:element>
						</td>
						<td align="center" valign="bottom">
							<xsl:element name="a">
								<xsl:attribute name="title">Mover grabaciones marcadas</xsl:attribute>
								<xsl:attribute name="href">javascript:moverGrabacionMarcada('CRID_','<xsl:value-of select="/M750/CARPETA_CPMV"/>')</xsl:attribute>
								<img src="/img/icon-cut.png" width="16" height="16" border="0" />
							</xsl:element>
						</td>
						<td align="center" valign="bottom">
							<a title="Descargar grabaciones marcadas" href="javascript:descargarGrabacionMarcada('CRID_')">
								<img src="/img/icon-save.png" width="16" height="16" border="0" />
							</a>
						</td>
						<xsl:choose>
							<xsl:when test="/M750/@orden='serie'">
								<td align="center" valign="center">
									<select name="IDserie" id="IDserie" class="cajaParam">
										<option value="0">Sin agrupar</option>
										<option value="-1">Nueva serie</option>
										<xsl:for-each select="/M750/INFO_SERIES/SERIE">
											<xsl:choose>
												<xsl:when test="ID_SERIE &gt; '0'">
													<xsl:element name="option">
														<xsl:attribute name="value"><xsl:value-of select="ID_SERIE"/></xsl:attribute>
														Lo mejor de ...
													</xsl:element>
												</xsl:when>
												<xsl:when test="ID_SERIE &lt; '0'">
													<xsl:element name="option">
														<xsl:attribute name="value"><xsl:value-of select="ID_SERIE"/></xsl:attribute>
														<xsl:value-of select="NOMBRE_SERIE"/>
													</xsl:element>
												</xsl:when>
											</xsl:choose>
										</xsl:for-each>
									</select>
								</td>
								<td align="center" valign="bottom">
									<a title="Agrupar grabaciones marcadas" href="javascript:agruparGrabacionMarcada('CRID_')">
										<img src="/img/skin/Icon_serie.png" width="16" height="16" border="0" />
									</a>
								</td>
							</xsl:when>
						</xsl:choose>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td colspan="3" height="10"></td></tr>
		<tr>
			<td width="30%" class="txtNormal" align="center">
				Modo Transferencia:&#160;
				<select name="ModoForce" id="ModoForce" class="txtNormal">
					<option value="0">Normal</option>
					<option value="1">Forzado</option>
				</select>
			</td>
			<td width="15%" class="txtNormal" align="center">
				<xsl:element name="input">
					<xsl:attribute name="type">button</xsl:attribute>
					<xsl:attribute name="value">BorrarHuerfanos</xsl:attribute>
					<xsl:attribute name="onclick">borrarHuerfanos('<xsl:value-of select="/M750/CARPETA"/>')</xsl:attribute>
				</xsl:element>
			</td>
			<td class="txtNormal" align="center">
				Ver grabaciones del directorio&#160;
				<xsl:element name="input">
					<xsl:attribute name="type">text</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="/M750/CARPETA_VER"/></xsl:attribute>
					<xsl:attribute name="size">35</xsl:attribute>
					<xsl:attribute name="name">alt_dir</xsl:attribute>
				</xsl:element>
				&#160;
				<xsl:element name="input">
					<xsl:attribute name="type">button</xsl:attribute>
					<xsl:attribute name="value">Ver</xsl:attribute>
					<xsl:attribute name="onclick">document.location.href='/cgi-bin/crid/ver-lista-grabaciones?<xsl:value-of select="/M750/@orden"/>&amp;' + document.forms[0].alt_dir.value</xsl:attribute>
				</xsl:element>
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
