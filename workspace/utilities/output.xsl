<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Block Elements -->
	<xsl:template match="*" mode="output">
		<xsl:param name="handle" />

		<xsl:element name="{name()}">
			<xsl:apply-templates select="* | @*" mode="output">
				<xsl:with-param name="handle" select="$handle" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<!-- Block Attributes -->
	<xsl:template match="@*" mode="output">
		<xsl:param name="handle" />

		<xsl:attribute name="{name()}">
			<xsl:value-of select="." />
		</xsl:attribute>
	</xsl:template>

	<!-- Inline Parents -->
	<xsl:template match="h1|h2|h3|h4|h5|h6" mode="output" priority="1">
		<xsl:param name="handle" />

		<xsl:variable name="name">
			<xsl:choose>
				<xsl:when test="name() = 'h1'">h1</xsl:when>
				<xsl:when test="name() = 'h2'">h2</xsl:when>
				<xsl:when test="name() = 'h3'">h3</xsl:when>
				<xsl:when test="name() = 'h4'">h4</xsl:when>
				<xsl:when test="name() = 'h5'">h5</xsl:when>
				<xsl:when test="name() = 'h6'">h6</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:element name="{$name}">
			<xsl:attribute name="id">
				<xsl:variable name="position">
					<xsl:number count="h1|h2|h3|h4|h5|h6" />
				</xsl:variable>

				<xsl:value-of select="concat($current-page, '-', $handle, '-header-', $position)" />
			</xsl:attribute>

			<xsl:apply-templates select="* | @* | text()" mode="output-inline">
				<xsl:with-param name="handle" select="$handle" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<xsl:template match="dt|dd|li|p" mode="output" priority="1">
		<xsl:param name="handle" />

		<xsl:variable name="name">
			<xsl:value-of select="name()" />
		</xsl:variable>

		<xsl:element name="{$name}">
			<xsl:apply-templates select="* | @* | text()" mode="output-inline">
				<xsl:with-param name="handle" select="$handle" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<!-- Inline Elements -->
	<xsl:template match="*" mode="output-inline">
		<xsl:param name="handle" />

		<xsl:element name="{name()}">
			<xsl:apply-templates select="* | @* | text()" mode="output-inline">
				<xsl:with-param name="handle" select="$handle" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<!-- Inline Attributes -->
	<xsl:template match="@*" mode="output-inline">
		<xsl:param name="handle" />

		<xsl:attribute name="{name()}">
			<xsl:value-of select="." />
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="@href" mode="output-inline">
		<xsl:param name="handle" />

		<xsl:if test="starts-with(., 'http://')">
			<xsl:attribute name='rel'>external</xsl:attribute>
		</xsl:if>

		<xsl:attribute name="{name()}">
			<xsl:if test="starts-with(., '/')">
				<xsl:value-of select="$root" />
			</xsl:if>

			<xsl:value-of select="." />
		</xsl:attribute>
	</xsl:template>

	<!-- Inline Text -->
	<xsl:template match="text()" mode="output-inline">
		<xsl:param name="handle" />

		<xsl:value-of select="." />
	</xsl:template>
</xsl:stylesheet>