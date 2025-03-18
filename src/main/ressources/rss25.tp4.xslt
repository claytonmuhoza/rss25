<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:p="http://univ.fr/rss25"
        version="3.0">
    <xsl:output method="html"
                omit-xml-declaration="yes"
                encoding="UTF-8"
                indent="yes"/>
    <!-- template pour l'élément root du document-->
    <xsl:template match="/">
        <xsl:element name="html">
            <xsl:attribute name="lang">
                <xsl:text>fr</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="headTemplate"/>
            <xsl:element name="body">
                <xsl:call-template name="titrePrincipaleTemplate"/>
                <xsl:call-template name="descriptionTemplate"/>
                <xsl:call-template name="sommaireTemplate"/>
                <xsl:call-template name="syntheseTableTemplate"/>
                <h2>Détail des informations</h2>
                <xsl:apply-templates select="p:feed/p:item"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- contenu de la balise head -->
    <xsl:template name="headTemplate">
        <xsl:element name="head">
            <xsl:element name="title"><xsl:text>TP4 - Flux RSS25</xsl:text>
            </xsl:element>
            <xsl:element name="link">
                <xsl:attribute name="rel">stylesheet</xsl:attribute>
                <xsl:attribute name="href">./rss25.css</xsl:attribute>
            </xsl:element>
        </xsl:element>

    </xsl:template>
    <!-- Contenu de la balise body -->
    <xsl:template name="titrePrincipaleTemplate">
        <xsl:element name="h1"><xsl:text>TP3 - Flux RSS25</xsl:text></xsl:element>
        <xsl:element name="p"><xsl:text>Le </xsl:text>  <xsl:value-of select="format-date(current-date(),'[D01]/[M]/[Y]')"/></xsl:element>
    </xsl:template>
    <!-- template pour afficher la description-->
    <xsl:template name="descriptionTemplate">
        <xsl:element name="h2">
            <xsl:text>Description</xsl:text>
        </xsl:element>
        <xsl:element name="ul">
            <xsl:element name="li">
                <xsl:text>Contenu: </xsl:text><xsl:value-of select="p:feed/p:title"/>
            </xsl:element>
            <xsl:element name="li">
                <xsl:text>Publié le </xsl:text><xsl:apply-templates select="p:feed/p:pubDate"/>
            </xsl:element>
            <xsl:element name="li">
                <xsl:text>Copyright </xsl:text><xsl:value-of select="p:feed/p:copyright"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- template pour afficher le sommaire -->
    <xsl:template name="sommaireTemplate">
        <xsl:element name="h2">
            <xsl:text>Sommaire</xsl:text>
        </xsl:element>
        <xsl:element name="ol">
            <xsl:attribute name="class">
                <xsl:text>list-sommaire</xsl:text>
            </xsl:attribute>
            <xsl:for-each select="p:feed/p:item">
                <xsl:element name="li">
                    <xsl:value-of select="p:title"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
        <xsl:element name="span">
            <xsl:value-of select="count(p:feed/p:item)"/> <xsl:text> sujets</xsl:text>
        </xsl:element>
    </xsl:template>

    <!-- template pour afficher un article-->
    <xsl:template  match="p:item">
        <xsl:element name="div">
            <xsl:attribute name="class">article</xsl:attribute>
            <xsl:element name="h3">
                <xsl:value-of select="p:title"/>
            </xsl:element>
            <xsl:element name="span">
                <xsl:attribute name="class">
                    <xsl:text>guid-item</xsl:text>
                </xsl:attribute>
                <xsl:text>(guid=</xsl:text>
                <xsl:element name="span">
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
                        <xsl:apply-templates select="p:published"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="span">
                            <xsl:text>Mis à jour le :</xsl:text>
                        </xsl:element>
                        <xsl:text>  </xsl:text>
                        <xsl:apply-templates select="p:updated"/>
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
    </xsl:template>
    <xsl:template name="tableAutheurTemplate">
        <xsl:element name="table">
            <xsl:element name="tr">
                <xsl:element name="th">
                    <xsl:text>N°</xsl:text>
                </xsl:element>
                <xsl:element name="th">
                    <xsl:text>Titre</xsl:text>
                </xsl:element>
                <xsl:element name="Date">
                    <xsl:text>Date</xsl:text>
                </xsl:element>
                <xsl:element name="th">
                    <xsl:text>Catégories</xsl:text>
                </xsl:element>
                <xsl:element name="th">
                    Autheurs
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:variable name="catTerm" select="lower-case(p:category[1]/@term)"/>
    <xsl:variable name="catClass">
        <xsl:choose>
            <xsl:when test="$catTerm = 'historique'">cat-historique</xsl:when>
            <xsl:when test="$catTerm = 'théorie' or $catTerm = 'theorie'">cat-theorie</xsl:when>
            <xsl:when test="$catTerm = 'nucléaire' or $catTerm = 'nucleaire'">cat-nucleaire</xsl:when>
            <xsl:when test="$catTerm = 'quantique'">cat-quantique</xsl:when>
            <xsl:when test="$catTerm = 'planete'">cat-planete</xsl:when>
            <xsl:when test="$catTerm = 'technique'">cat-technique</xsl:when>
            <xsl:when test="$catTerm = 'robotique'">cat-robotique</xsl:when>
            <xsl:otherwise>cat-default</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template name="syntheseTableTemplate">
        <!-- Calcul du nombre total d'articles -->
        <xsl:variable name="total" select="count(/p:feed/p:item)"/>
        <xsl:element name="h2">Synthèse des articles</xsl:element>
        <xsl:element name="table">
            <xsl:element name="tr">
                <xsl:element name="th">n°</xsl:element>
                <xsl:element name="th">Titre</xsl:element>
                <xsl:element name="th">Date</xsl:element>
                <xsl:element name="th">Catégories</xsl:element>
                <xsl:element name="th">Auteurs</xsl:element>
            </xsl:element>
            <xsl:for-each select="/p:feed/p:item">
                <xsl:sort select="if (p:published) then p:published else p:updated" order="descending"/>
                <xsl:variable name="catTerm" select="lower-case(p:category[1]/@term)"/>
                <xsl:variable name="catClass">
                    <xsl:choose>
                        <xsl:when test="$catTerm = 'historique'">cat-historique</xsl:when>
                        <xsl:when test="$catTerm = 'théorie' or $catTerm = 'theorie'">cat-theorie</xsl:when>
                        <xsl:when test="$catTerm = 'nucléaire' or $catTerm = 'nucleaire'">cat-nucleaire</xsl:when>
                        <xsl:when test="$catTerm = 'quantique'">cat-quantique</xsl:when>
                        <xsl:when test="$catTerm = 'planete'">cat-planete</xsl:when>
                        <xsl:when test="$catTerm = 'technique'">cat-technique</xsl:when>
                        <xsl:when test="$catTerm = 'robotique'">cat-robotique</xsl:when>
                        <xsl:otherwise>cat-default</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:element name="tr">
                    <xsl:attribute name="class">
                        <xsl:value-of select="$catClass"/>
                    </xsl:attribute>
                    <xsl:element name="td">
                        <xsl:value-of select="concat(position(), ' / ', $total)"/>
                    </xsl:element>
                    <xsl:element name="td">
                        <xsl:variable name="fullTitle" select="p:title"/>
                        <xsl:variable name="truncatedTitle"
                                      select="if (string-length($fullTitle) > 45)
                                        then concat(substring($fullTitle,1,45), '...')
                                        else $fullTitle"/>
                        <xsl:choose>
                            <xsl:when test="p:content/@src">
                                <xsl:element name="a">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="p:content/@src"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="$truncatedTitle"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$truncatedTitle"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    <td>
                        <xsl:choose>
                            <xsl:when test="p:published">
                                <xsl:apply-templates select="p:published"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="p:updated"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                    <td>
                        <xsl:value-of select="p:category/@term" />
                    </td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="p:author">
                                <xsl:value-of select="p:author/p:name"/>
                            </xsl:when>
                            <xsl:when test="p:contributor">
                                <xsl:attribute name="class">
                                    <xsl:text>contributor</xsl:text>
                                </xsl:attribute>
                                <xsl:value-of select="p:contributor/p:name"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Non spécifié</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template match="p:published | p:updated | p:feed/p:pubDate | datedujours">
        <!--  récupèration de la date complète -->
        <xsl:variable name="dateTime" select="."/>

        <!-- Extraction de l'année, mois et jour -->
        <xsl:variable name="year" select="substring($dateTime,1,4)"/>
        <xsl:variable name="month" select="substring($dateTime,6,2)"/>
        <xsl:variable name="day" select="substring($dateTime,9,2)"/>

        <!-- Suppression du zéro si la date est inférieur à 10  -->
        <xsl:variable name="dayNoZero" select="number($day)"/>

        <!-- Détermination du nom abrégé du mois -->
        <xsl:variable name="monthName">
            <xsl:choose>
                <xsl:when test="$month = '01'">Jan</xsl:when>
                <xsl:when test="$month = '02'">Fév</xsl:when>
                <xsl:when test="$month = '03'">Mars</xsl:when>
                <xsl:when test="$month = '04'">Avr</xsl:when>
                <xsl:when test="$month = '05'">Mai</xsl:when>
                <xsl:when test="$month = '06'">Jun</xsl:when>
                <xsl:when test="$month = '07'">Jul</xsl:when>
                <xsl:when test="$month = '08'">Aoû</xsl:when>
                <xsl:when test="$month = '09'">Sep</xsl:when>
                <xsl:when test="$month = '10'">Oct</xsl:when>
                <xsl:when test="$month = '11'">Nov</xsl:when>
                <xsl:when test="$month = '12'">Déc</xsl:when>
                <xsl:otherwise>?</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- Assemblage de la date au format "[J]J Mmm[m] AAAA" -->
        <xsl:value-of select="concat($dayNoZero, ' ', $monthName, ' ', $year)"/>
    </xsl:template>
</xsl:stylesheet>