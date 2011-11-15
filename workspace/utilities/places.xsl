<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
	Place
-->
	<xsl:template match='entry' mode='place'>
	
		<xsl:param name="type" select="'Place'" />
	
		<section itemscope="itemscope" itemtype="http://schema.org/{$type}">
			
			<!-- Wrap the name in URL if it's been specified -->
			<xsl:choose>	
				<xsl:when test="url">
					<h1>
						<a itemprop="url" href="http://www.randb.com.au">
							<span itemprop="name">
								<xsl:value-of select="name" />
							</span>
						</a>
					</h1>	
				</xsl:when>
				<xsl:otherwise>
					<h1>
						<span itemprop="name">
							<xsl:value-of select="name" />
						</span>
					</h1>
				</xsl:otherwise>
			</xsl:choose>
			
			<!-- Optional Description -->
			<xsl:if test="description">
				<span itemprop="description">
					<xsl:apply-templates select="description" mode="output" />
				</span>
			</xsl:if>
			
			<!-- Postal Address -->
			<xsl:apply-templates select="." mode="postal-address" />
		
			
			<!-- Optional Phone -->
			<xsl:if test="phone != ''">
				<dl class="phone">
					<dt>Phone</dt>
					<dd itemprop="telephone">
						<xsl:value-of select="phone" />
					</dd>
				</dl>
			</xsl:if>
			
			<!-- Optional Fax -->
			<xsl:if test="fax != ''">
				<dl class="fax">
					<dt>Fax</dt>
					<dd itemprop="faxNumber">
						<xsl:value-of select="fax" />
					</dd>
				</dl>
			</xsl:if>
			
			<!-- Optional Geo Coordinates and Map -->
			<xsl:if test="map-location">		
				<div itemprop="geo" itemscope="itemscope" itemtype="http://schema.org/GeoCoordinates">
				    <meta itemprop="latitude" content="{map-location/@latitude}" />
				    <meta itemprop="longitude" content="{map-location/@longitude}" />
				 </div>
	
				 <a itemprop="maps" href="http://maps.google.com/maps?q=to:{name}@{map-location/map/@centre}+&amp;ie=UTF8" rel="external">
				 	<img itemprop="image" src="http://maps.google.com/maps/api/staticmap?center={map-location/map/@centre}&amp;markers=color:green|label:P|size:small|{map-location/map/@centre}&amp;zoom=15&amp;size=380x220&amp;sensor=false" alt="{name} Location" /> 
				 </a>
			</xsl:if>	

		</section>

	</xsl:template>
	

<!--
	Postal Address
-->
	<xsl:template match='entry' mode='postal-address'>
		
		<dl itemprop="address" itemscope="itemscope" itemtype="http://schema.org/PostalAddress">
		
			<!-- Optional Post Box Number -->
			<xsl:if test="post-office-box != ''">
				<dt class="post-office-box">PO Box</dt>
				<dd itemprop="postOfficeBoxNumber">
					<xsl:value-of select="post-office-box" />
				</dd>
			</xsl:if>
	
			<!-- Optional Street Address -->
			<xsl:if test="street-address != ''">
				<dt class="street-address">Street Address</dt>
				
				<dd itemprop="streetAddress" class="street-address">
					<xsl:value-of select="street-address" />
				</dd>
			</xsl:if>
			
			
			<!-- Suburb -->
			<dt class="suburb">Suburb</dt>

			<dd itemprop="addressLocality" class="suburb">
				<xsl:value-of select="suburb" />
			</dd>
			
			<!-- Region -->
			<dt class="region">Region</dt>
			
			<dd itemprop="addressRegion">
				<xsl:value-of select="region" />
			</dd>
			
			<!-- Postcode -->
			<dt class="postcode">Postcode</dt>
		
			<dd itemprop="postalCode" class="postcode">
				<xsl:value-of select="postcode" />
			</dd>

			<!-- Country -->
			<dt class="country">Country</dt>
			
			<dd itemprop="addressCountry" class="country">
				<xsl:value-of select='country' />
			</dd>
			
		</dl>

	</xsl:template>
	

</xsl:stylesheet>