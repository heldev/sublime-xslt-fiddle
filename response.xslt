<xsl:stylesheet
		version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output indent="yes"/>

	<xsl:template match="/entry_list">
		<response>
			<xsl:if test="entry">
				<entries>
					<xsl:apply-templates select="entry"/>
				</entries>
			</xsl:if>

			<xsl:if test="suggestion">
				<suggestions>
					<xsl:apply-templates select="suggestion"/>
				</suggestions>
			</xsl:if>
		</response>
	</xsl:template>

	<xsl:template match="entry">
		<entry>
			<headword><xsl:value-of select="hw"/></headword>

			<xsl:if test="sound/wav">
				<audioFilenames>
					<xsl:for-each select="sound/wav">
						<audioFilename><xsl:value-of select="."/></audioFilename>
					</xsl:for-each>
				</audioFilenames>
			</xsl:if>

			<xsl:if test="pr">
				<pronunciation>
					<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
					<xsl:copy-of select="pr/node()"/>
					<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
				</pronunciation>
			</xsl:if>

			<functionalLabel><xsl:value-of select="fl"/></functionalLabel>

			<xsl:if test="et">
				<etymology>
					<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
					<xsl:copy-of select="et/node()"/>
					<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
				</etymology>
			</xsl:if>

			<xsl:if test="in">
				<inflictions>
					<xsl:for-each select="in">
						<infliction>
							<form><xsl:value-of select="if"/></form>

							<xsl:if test="pr">
								<pronounciation>
									<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
									<xsl:copy-of select="pr/node()"/>
									<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
								</pronounciation>
							</xsl:if>

						</infliction>
					</xsl:for-each>
				</inflictions>
			</xsl:if>

			<xsl:apply-templates select="def"/>

			<xsl:if test="dro">
				<runOnEntriesDefined>
					<xsl:for-each select="dro">
						<spelling><xsl:value-of select="drp"/></spelling>
						<pronunciation><xsl:value-of select="pr"/></pronunciation>
						<xsl:apply-templates select="def"/>
						<variants>
							<xsl:for-each select="vr">
								<varian>
									<label><xsl:value-of select="vl"/></label>
									<form><xsl:value-of select="vf"/></form>
									<pronunciation><xsl:value-of select="pr"/></pronunciation>
								</varian>
							</xsl:for-each>
						</variants>
					</xsl:for-each>
				</runOnEntriesDefined>
			</xsl:if>

			<xsl:if test="uro">
				<runOnEntriesUndefined>
					<xsl:for-each select="uro">
						<runOnEntryUndefined>
							<syllables><xsl:value-of select="ure"/></syllables>
							<audioFilenames>
								<xsl:for-each select="sound/wav">
									<audioFilename><xsl:value-of select="."/></audioFilename>
								</xsl:for-each>
							</audioFilenames>
							<transcription><xsl:value-of select="pr"/></transcription>
							<functionalLabel><xsl:value-of select="fl"/></functionalLabel>
						</runOnEntryUndefined>
					</xsl:for-each>
				</runOnEntriesUndefined>
			</xsl:if>
		</entry>
	</xsl:template>


	<xsl:template match="def">
		<senseGroups >
			<xsl:for-each-group select="*" group-starting-with="vt">
				<senseGroup>
					<xsl:if test="current-group()[self::vt]">
						<label><xsl:value-of select="current-group()[self::vt]"/></label>
					</xsl:if>

					<xsl:if test="current-group()[self::date]">
						<firstUse><xsl:value-of select="current-group()[self::date]"/></firstUse>
					</xsl:if>

					<senses>
						<xsl:for-each-group select="current-group()" group-starting-with="sn[matches(.,'^\d+')]">
							<xsl:if test="current-group()[self::dt]">
								<sense>
								    <xsl:if test="current-group()[self::sn]">
    									<number>
    										<xsl:value-of select="number(replace(current-group()[self::sn][1]/text()[1], '[^\d+]', ''))"/>
    									</number>
									</xsl:if>
									<xsl:if test="current-group()[self::sn][1][matches(.,'^\d+$')]"> <!-- is sense -->
										<definition>
											<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
											<xsl:copy-of select="current-group()[self::dt][1]/node()"/>
											<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
										</definition>
									</xsl:if>

									<xsl:if test="current-group()[self::sn][matches(.,'[^\d]')]">
										<subSenses>
											<xsl:for-each-group select="current-group()" group-starting-with="sn[matches(.,'[^\d]')][1]">
												<xsl:if test="current-group()[self::sn][matches(.,'[^\d]')][1]">
													<subSense>
														<number>
															<xsl:value-of select="replace(current-group()[self::sn][1]/text()[1], '^\d+ ', '')"/>
														</number>

														<xsl:if test="current-group()[self::sn][1][not(snp)]">
															<definiton>
																<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
																<xsl:copy-of select="current-group()[self::dt][1]/node()"/>
																<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
															</definiton>
														</xsl:if>

														<xsl:if test="current-group()[self::sn]/snp">
															<subSubSenses>
																<xsl:for-each-group select="current-group()" group-starting-with="sn[snp]">
																	<xsl:if test="current-group()[self::sn][1]/snp">
																		<subSubSense>
    																		<number>
    																			<xsl:value-of select="current-group()[self::sn][1]/snp"/>
    																		</number>
    																		<definition>
    																			<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
																		        <xsl:copy-of select="current-group()[self::dt][1]/node()"/>
																		    	<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
																	    	</definition>
																		</subSubSense>
																	</xsl:if>
																</xsl:for-each-group>
															</subSubSenses>
														</xsl:if>
													</subSense>
												</xsl:if>
											</xsl:for-each-group>
										</subSenses>
									</xsl:if>
								</sense>
							</xsl:if>
						</xsl:for-each-group>
					</senses>
				</senseGroup>
			</xsl:for-each-group>
		</senseGroups>
	</xsl:template>

	<!--<xsl:template match="def">-->
		<!--<senseGroups>-->
			<!--<xsl:for-each-group select="*" group-starting-with="vt">-->
				<!--<senseGroup>-->
					<!--<xsl:if test="current-group()[self::vt]">-->
						<!--<label><xsl:value-of select="current-group()[self::vt]"/></label>-->
					<!--</xsl:if>-->

					<!--<xsl:if test="current-group()[self::date]">-->
						<!--<firstUse><xsl:value-of select="current-group()[self::date]"/></firstUse>-->
					<!--</xsl:if>-->

					<!--<senses>-->
						<!--<xsl:for-each-group select="current-group()" group-starting-with="sn">-->
							<!--<xsl:if test="current-group()[self::dt]">-->
								<!--<sense>-->
									<!--<xsl:if test="current-group()[self::sn][matches(., '\d+')]">-->
										<!--<number><xsl:value-of select="current-group()[self::sn]"/></number>-->
									<!--</xsl:if>-->

									<!--&lt;!&ndash;<xsl:if test="current-group()[self::ssl]">&ndash;&gt;-->
									<!--&lt;!&ndash;<label><xsl:value-of select="current-group()[self::ssl]"/></label>&ndash;&gt;-->
									<!--&lt;!&ndash;</xsl:if>&ndash;&gt;-->

									<!--&lt;!&ndash;<xsl:value-of select="current-group()[self::sn]/text()"/>&ndash;&gt;-->

									<!--&lt;!&ndash;<xsl:if test="preceding-sibling::sd[1]">&ndash;&gt;-->
									<!--&lt;!&ndash;<divider><xsl:value-of select="preceding-sibling::sd[1]"/></divider>&ndash;&gt;-->
									<!--&lt;!&ndash;</xsl:if>&ndash;&gt;-->

									<!--<definition>-->
										<!--<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>-->
										<!--<xsl:copy-of select="current-group()[self::dt][1]"/>-->
										<!--<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>-->
									<!--</definition>-->

									<!--<xsl:if test="current-group()[self::sd]">-->
										<!--<meaning>-->
											<!--<senseDivider><xsl:value-of select="current-group()[self::sd]"/></senseDivider>-->
											<!--<definition>-->
												<!--<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>-->
												<!--<xsl:copy-of select="current-group()[self::sd]/following-sibling::dt"/>-->
												<!--<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>-->
											<!--</definition>-->
										<!--</meaning>-->
									<!--</xsl:if>-->

									<!--&lt;!&ndash;<xsl:if test="un">&ndash;&gt;-->
									<!--&lt;!&ndash;<usageLabel><xsl:value-of select="un/node()"/></usageLabel>&ndash;&gt;-->
									<!--&lt;!&ndash;</xsl:if>&ndash;&gt;-->

									<!--&lt;!&ndash;<xsl:if test="vi">&ndash;&gt;-->
									<!--&lt;!&ndash;<verbalIllustrations>&ndash;&gt;-->
									<!--&lt;!&ndash;<xsl:for-each select="vi">&ndash;&gt;-->
									<!--&lt;!&ndash;<verbalIllustration>&ndash;&gt;-->
									<!--&lt;!&ndash;<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>&ndash;&gt;-->
									<!--&lt;!&ndash;<xsl:copy-of select="node()"/>&ndash;&gt;-->
									<!--&lt;!&ndash;<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>&ndash;&gt;-->
									<!--&lt;!&ndash;</verbalIllustration>&ndash;&gt;-->
									<!--&lt;!&ndash;</xsl:for-each>&ndash;&gt;-->
									<!--&lt;!&ndash;</verbalIllustrations>&ndash;&gt;-->
									<!--&lt;!&ndash;</xsl:if>&ndash;&gt;-->
								<!--</sense>-->
							<!--</xsl:if>-->
						<!--</xsl:for-each-group>-->
					<!--</senses>-->
				<!--</senseGroup>-->
			<!--</xsl:for-each-group>-->
		<!--</senseGroups>-->
	<!--</xsl:template>-->

</xsl:stylesheet>
