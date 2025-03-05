<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:p="http://univ.fr/rss25"
    version="1.0">
<xsl:output method="html"
 doctype-public="html"
 omit-xml-declaration="yes"
 encoding="UTF-8"
 indent="yes"
/>
	<xsl:template match="/">
	 	<xsl:element name="html">
	 		<xsl:element name="head">
		 		<xsl:element name="title"><xsl:text>TP3 - Flux RSS25</xsl:text>
				</xsl:element>

			</xsl:element>
			<xsl:element name="body">
				<xsl:element name="h1">TP3 - Flux RSS25</xsl:element>
				<xsl:element name="p">Le 5 mars 2025</xsl:element>
				<xsl:call-template name="descriptionTemplate"/>
			</xsl:element>
			<h2>Détail des informations</h2>
			<xsl:apply-templates select="p:feed/p:item"/>
		</xsl:element>
</xsl:template>
	 <xsl:template name="descriptionTemplate">
		 <xsl:element name="h3">
			 Description
		 </xsl:element>
	 	<xsl:element name="ul">
			<xsl:element name="li">
				<xsl:value-of select="p:feed/p:title"/>
			</xsl:element>
			<xsl:element name="li">
				<xsl:value-of select="p:feed/p:title"/>
			</xsl:element>
			<xsl:element name="li">
				<xsl:value-of select="p:feed/p:copyright"/>
			</xsl:element>
	 	</xsl:element>
	 </xsl:template>
	<!-- Template pour chaque item -->
	<xsl:template match="p:item">
		<xsl:element name="div">
			<xsl:attribute name="class">item</xsl:attribute>
			<xsl:element name="h2">
				<xsl:value-of select="p:title"/>
			</xsl:element>
			<xsl:element name="p">
				<xsl:text>(guid=</xsl:text>
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:value-of select="p:guid"/>
					</xsl:attribute>
					<xsl:value-of select="p:guid"/>
				</xsl:element>
				<xsl:text>)</xsl:text>
			</xsl:element>
			<!-- Affichage de l'image s'il y en a une -->
			<xsl:if test="p:image">
				<xsl:element name="div">
					<xsl:element name="img">
						<xsl:attribute name="src">
							<xsl:value-of select="p:image/@href"/>
						</xsl:attribute>
						<xsl:attribute name="alt">
							<xsl:value-of select="p:image/@alt"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:element name="p">
				<xsl:element name="span">
					<xsl:text>Catégorie :</xsl:text>
				</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:value-of select="p:category/@term"/>
			</xsl:element>
			<xsl:element name="p">
				<xsl:choose>
					<xsl:when test="p:published">
						<xsl:element name="span">
							<xsl:text>Publié le :</xsl:text>
						</xsl:element>
						<xsl:text> </xsl:text>
						<xsl:value-of select="p:published"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="span">
							<xsl:text>Mis à jour le :</xsl:text>
						</xsl:element>
						<xsl:text> </xsl:text>
						<xsl:value-of select="p:updated"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>

			<!-- Contenu de l'article -->
			<xsl:element name="div">
				<xsl:element name="p">
					<xsl:value-of select="p:content"/>
				</xsl:element>
			</xsl:element>

			<!-- Informations sur l'auteur ou le contributeur -->
			<xsl:element name="div">
				<xsl:choose>
					<xsl:when test="p:author">
						<xsl:element name="p">
							<xsl:element name="span">
								<xsl:text>Auteur :</xsl:text>
							</xsl:element>
							<xsl:text> </xsl:text>
							<xsl:value-of select="p:author/p:name"/>
						</xsl:element>
						<xsl:if test="p:author/p:uri">
							<xsl:element name="p">
								<xsl:element name="span">
									<xsl:text>Site :</xsl:text>
								</xsl:element>
								<xsl:text> </xsl:text>
								<xsl:element name="a">
									<xsl:attribute name="href">
										<xsl:value-of select="p:author/p:uri"/>
									</xsl:attribute>
									<xsl:value-of select="p:author/p:uri"/>
								</xsl:element>
							</xsl:element>
						</xsl:if>
						<xsl:if test="p:author/p:email">
							<xsl:element name="p">
								<xsl:element name="span">
									<xsl:text>Email :</xsl:text>
								</xsl:element>
								<xsl:text> </xsl:text>
								<xsl:value-of select="p:author/p:email"/>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="p:contributor">
						<xsl:element name="p">
							<xsl:element name="span">
								<xsl:text>Contributeur :</xsl:text>
							</xsl:element>
							<xsl:text> </xsl:text>
							<xsl:value-of select="p:contributor/p:name"/>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:element>
		</xsl:element>
		<xsl:element name="hr"/>
	</xsl:template>
 </xsl:stylesheet>