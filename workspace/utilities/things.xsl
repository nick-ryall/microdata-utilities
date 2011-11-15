<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:date="http://exslt.org/dates-and-times"
	extension-element-prefixes="date">
	
	
<!--
	Place - http://www.schema.org/Place
-->	
	<xsl:template match='entry' mode='place'>
			
		<!-- 
			Pass in a param here for more specific types of places. See: http://www.schema.org/Place 
		-->
			<xsl:param name="type" select="'Place'" />
			
		<!-- 
			Context - Modify behaviour depending  on what is calling this utility. 
		-->
			<xsl:param name="context" select="'default'" />	
			
		<!-- 
			Map Display - Control how the Google Map link is displayed. 
			
			Options: 
				* map (Map Image)
				* text ('Get Directions')
				* street (Street View Image) 
		-->
			<xsl:param name="map-display" select="'map'" />
			
			<article itemscope="itemscope" itemtype="http://schema.org/{$type}">

				<xsl:choose>
					<xsl:when test="$context = 'event'">
						<h2>Venue</h2>
					</xsl:when>
					<xsl:otherwise>
						<!-- Default Thing Properties -->
						<xsl:call-template name="thing">
							<xsl:with-param name="type" select="'place'" />
							<xsl:with-param name="entry" select="." />
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				
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
				
				<xsl:apply-templates select="." mode="geocoordinates" />
				
				<xsl:apply-templates select="." mode="map">
					<xsl:with-param name="display" select="'map'" />
				</xsl:apply-templates>
	
			</article>
	
	</xsl:template>
	
	
<!--
	Event - http://www.schema.org/Event
-->
	<xsl:template match='entry' mode='event'>
	
	<!-- 
		Pass in a param here for more specific types of events. See: http://www.schema.org/Event
	-->
		<xsl:param name="type" select="'Event'" />
		
	<!-- 
		Context - Modify behaviour depending  on what is calling this utility. 
	-->
		<xsl:param name="context" select="'default'" />	
		
	<!-- 
		Display - Control how the Google Map link is displayed.
		Note: This is passed to the Place utility 
		
		Options: 
			* map (Map Image)
			* text ('Get Directions')
			* street ('Street View Image') 
	-->
		<xsl:param name="map-display" select="'text'" />
		
		<article itemscope="itemscope" itemtype="http://schema.org/{$type}">
		
			<meta itemprop="duration" content="{date:difference(concat(start-date, 'T', start-date/@time, ':00'), concat(end-date, 'T', end-date/@time, ':00'))}" />
			<meta itemprop="startDate" content="{concat(start-date, 'T', start-date/@time, ':00')}" />
			<meta itemprop="endDate" content="{concat(end-date, 'T', end-date/@time, ':00')}" />
			
			<!-- Default Thing Properties -->
			<xsl:if test="$context = 'default'">
				<xsl:call-template name="thing">
					<xsl:with-param name="type" select="'event'" />
					<xsl:with-param name="entry" select="." />
				</xsl:call-template>
			</xsl:if>
			
			<xsl:apply-templates select="." mode="place">	
				<xsl:with-param name="context" select="'event'" />
				<xsl:with-param name="map-display" select="$map-display" />
			</xsl:apply-templates>
			
			<!-- Price -->
			<xsl:if test="price !=''">
				<dl class="price">
					<dt>Price</dt>
					<dd itemprop="offer">
						<xsl:value-of select="price" />	
					</dd>
				</dl>
			</xsl:if>	
			
		</article>
		
	</xsl:template>
	
	
<!--
	Thing - http://www.schema.org/Thing
-->	
	<xsl:template name="thing">
		<xsl:param name="type" />
		<xsl:param name="entry" />
		
		<!-- Image -->
		<xsl:if test="$entry/image">
			<img itemprop="image" src="{$workspace}/{$entry/image/@path}/{$entry/image/filename}" alt="{$entry/name}" />
		</xsl:if>	
		
		<header>
			<!-- Wrap the name in URL if it's been specified -->
			<xsl:choose>	
				<xsl:when test="$entry/url">
					<h1>
						<a itemprop="url" href="{$entry/url}">
							<span itemprop="name">
								<xsl:value-of select="$entry/name" />
							</span>
						</a>
					</h1>	
				</xsl:when>
				<xsl:otherwise>
					<h1>
						<span itemprop="name">
							<xsl:value-of select="$entry/name" />
						</span>
					</h1>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:choose>
				<xsl:when test="$type = 'event'">
					<!-- Date/Times -->
					<dl>	
						<dt>Start date:</dt>
						<dd>
							<time itemprop="startDate" datetime="{concat($entry/start-date, 'T', $entry/start-date/@time, ':00')}">
								<xsl:value-of select="$entry/start-date" />
							</time>
						</dd>
						
						<xsl:if test="$entry/end-date != ''">
							<dt>End date:</dt>
							<dd>
								<time itemprop="endDate" datetime="{concat($entry/end-date, 'T', $entry/end-date/@time, ':00')}">
									<xsl:value-of select="$entry/end-date" />
								</time>
							</dd>
						</xsl:if>
	
					</dl>
				</xsl:when>
			</xsl:choose>
		</header>
		
		<!-- Description -->
		<xsl:if test="$entry/description">
			<span itemprop="description">
				<xsl:apply-templates select="$entry/description" mode="output" />
			</span>
		</xsl:if>
	</xsl:template>
	
	
<!--
	Maps - http://www.schema.org/Place
-->		
	<xsl:template match="entry" mode="map">
			
		<xsl:param name="map-display" />
		
		<xsl:if test="map-location">
			<a itemprop="maps" href="http://maps.google.com/maps?q={map-location/map/@centre}+&amp;ie=UTF8" rel="external">
				<xsl:choose>
					<xsl:when test="$map-display = 'street'">
						<img itemprop="image" src="http://cbk0.google.com/cbk?output=thumbnail&amp;cb_client=maps_sv&amp;thumb=2&amp;thumbfov=60&amp;ll={map-location/@latitude},{map-location/@longitude}&amp;cbll={map-location/@latitude},{map-location/@longitude}&amp;thumbpegman=1&amp;w=100&amp;h=100" />
					</xsl:when>
					<xsl:when test="$map-display = 'map'">
						<img src="http://maps.google.com/maps/api/staticmap?center={map-location/map/@centre}&amp;markers=color:green|label:P|size:small|{map-location/map/@centre}&amp;zoom=15&amp;size=380x220&amp;sensor=false" alt="{name} Location" /> 
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Get Directions</xsl:text>
					</xsl:otherwise>
				</xsl:choose> 	
			</a>
		</xsl:if>

	</xsl:template>		

<!--
	GeoCoordinates - http://www.schema.org/GeoCoordinates
-->		
	<xsl:template match="entry" mode="geocoordinates">
		<xsl:if test="map-location">
			<div itemprop="geo" itemscope="itemscope" itemtype="http://schema.org/GeoCoordinates">
			    <meta itemprop="latitude" content="{map-location/@latitude}" />
			    <meta itemprop="longitude" content="{map-location/@longitude}" />
			 </div>
		</xsl:if>
	</xsl:template>	
	
<!--
	Postal Address
-->
	<xsl:template match='entry' mode='postal-address'>
		
		<dl itemprop="address" itemscope="itemscope" itemtype="http://schema.org/PostalAddress">
		
			<!-- Post Box Number -->
			<xsl:if test="post-office-box != ''">
				<dt class="post-office-box">PO Box</dt>
				<dd itemprop="postOfficeBoxNumber">
					<xsl:value-of select="post-office-box" />
				</dd>
			</xsl:if>
	
			<!-- Street Address -->
			<xsl:if test="street-address != ''">
				<dt class="street-address">Street Address</dt>
				
				<dd itemprop="streetAddress" class="street-address">
					<xsl:value-of select="street-address" />
				</dd>
			</xsl:if>
			
			<!-- Suburb -->
			<xsl:if test="suburb != ''">
				<dt class="suburb">Suburb</dt>
	
				<dd itemprop="addressLocality" class="suburb">
					<xsl:value-of select="suburb" />
				</dd>
			</xsl:if>
			
			<!-- Region -->
			<xsl:if test="region != ''">
				<dt class="region">Region</dt>
				
				<dd itemprop="addressRegion">
					<xsl:value-of select="region" />
				</dd>
			</xsl:if>
			
			<!-- Postcode -->
			<xsl:if test="postcode != ''">
				<dt class="postcode">Postcode</dt>
			
				<dd itemprop="postalCode" class="postcode">
					<xsl:value-of select="postcode" />
				</dd>
			</xsl:if>

			<!-- Country -->
			<xsl:if test="country != ''">
				<dt class="country">Country</dt>
				
				<dd itemprop="addressCountry" class="country">
					<xsl:value-of select='country' />
				</dd>
			</xsl:if>
			
		</dl>

	</xsl:template>
	

</xsl:stylesheet>