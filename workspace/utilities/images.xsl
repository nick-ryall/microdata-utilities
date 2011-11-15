<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
	Image
-->
	<xsl:template match="related-images" mode="image">
		<xsl:param name="filter" />
		<xsl:param name="class" />
		<xsl:param name="caption" />

		<xsl:apply-templates select="entry | item" mode="images-single">
			<xsl:with-param name="filter" select="$filter" />
			<xsl:with-param name="class" select="$class" />
			<xsl:with-param name="caption" select="$caption" />
		</xsl:apply-templates>

	</xsl:template>

<!--
	Default Image, everything calls this in the end
-->
	<xsl:template match="entry | item | homepage-feature-image | file | logo | icon | thumbnail | related-thumbnail | youtube-rosette" mode="images-single">
		<xsl:param name="jit" />
		<xsl:param name="class" />
		<xsl:param name="style" />
		<xsl:param name="caption" select="false()" />
		<xsl:param name="alt"  />

		<xsl:variable name='image-path'>
			<xsl:apply-templates select='.' mode='image-path-select' />
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$caption">
				<figure>
					<img src='{$root}/image/{$jit}{$image-path}' alt='{$alt}' style='{$style}'>
						<xsl:if test='$class'>
							<xsl:attribute name='class'>
								<xsl:value-of select='$class' />
							</xsl:attribute>
						</xsl:if>
					</img>
					<figcaption>
						<xsl:value-of select="caption" />
					</figcaption>
				</figure>
			</xsl:when>
			<xsl:otherwise>
				<img src='{$root}/image/{$jit}{$image-path}' alt='{$alt}' style='{$style}'>
					<xsl:if test='$class'>
						<xsl:attribute name='class'>
							<xsl:value-of select='$class' />
						</xsl:attribute>
					</xsl:if>
				</img>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

<!--
	Path Select Building
-->
	<xsl:template match='*' mode='image-path-select'>
		<xsl:choose>
			<xsl:when test='image/file'>
				<xsl:value-of select="concat(image/path,'/',image/file)" />
			</xsl:when>
			<xsl:when test='file'>
				<xsl:value-of select="concat(path,'/',file)" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>