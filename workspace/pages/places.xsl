<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:atom="http://www.w3.org/2005/Atom" extension-element-prefixes="atom">
	<xsl:import href="../utilities/places.xsl" />
	
	<xsl:template match="/">
		<xsl:apply-templates select="data/read-places/entry" mode="place" />
	</xsl:template>

</xsl:stylesheet>