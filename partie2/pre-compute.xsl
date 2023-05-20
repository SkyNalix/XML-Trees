<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="math">
    
    <xsl:output indent="yes"/>

    <xsl:variable name="max-depth" select="max(//Node[not(*)]/count(ancestor::*))"/>
    <xsl:variable name="nbFeuilles" select="count(.//Node[not(*)])"/>
    <xsl:variable name="degrees-per-node" select="360 div $nbFeuilles"/>
    
    <xsl:template match="/ArbreDeVie">
        <ArbreDeVie>
            <xsl:attribute name="max-depth">
                <xsl:value-of select="$max-depth"/>
            </xsl:attribute>
            <xsl:attribute name="nbFeuilles">
                <xsl:value-of select="$nbFeuilles"/>
            </xsl:attribute>

            <xsl:apply-templates select="Node">
                <xsl:with-param name="depth" select="0"/>
                <xsl:with-param name="leftLimit" select="0"/>
                <xsl:with-param name="rightLimit" select="360"/>
            </xsl:apply-templates>
        </ArbreDeVie>
    </xsl:template>

    <xsl:template match="Node">
        <xsl:param name="depth"/>
        <xsl:param name="leftLimit"/>
        <xsl:param name="rightLimit"/>

        <Node>
            <xsl:attribute name="depth">
                <xsl:value-of select="$depth"/>
            </xsl:attribute>

            <xsl:variable name="precedingDirectFeuilles" select="count (preceding-sibling::Node[not(*)])"/>
            <xsl:variable name="precedingFeuilles" select="$precedingDirectFeuilles + count (preceding-sibling::Node//Node[not(*)])"/>
            <xsl:attribute name="precedingFeuilles">
                <xsl:value-of select="$precedingFeuilles"/>
            </xsl:attribute>

            <xsl:variable name="followingDirectFeuilles" select="count (following-sibling::Node[not(*)])"/>
            <xsl:variable name="followingFeuilles" select="$followingDirectFeuilles + count (following-sibling::Node//Node[not(*)])"/>
            <xsl:attribute name="followingFeuilles">
                <xsl:value-of select="$followingFeuilles"/>
            </xsl:attribute>

            <!-- CIRCULAIRE -->
            <xsl:variable name="leftLimit" select="$leftLimit + ($precedingFeuilles * $degrees-per-node)"/>
            <xsl:variable name="rightLimit" select="$rightLimit - ($followingFeuilles * $degrees-per-node)"/>
            <xsl:if test=".[not(*)]">
                <xsl:variable name="mid-angle" select="($leftLimit + $rightLimit) div 2"/>
                <xsl:attribute name="angle">
                    <xsl:value-of select="2 * math:pi() * $mid-angle div 360"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:apply-templates select="Node">
                <xsl:with-param name="depth" select="$depth + 1"/>
                <xsl:with-param name="leftLimit" select="$leftLimit"/>
                <xsl:with-param name="rightLimit" select="$rightLimit"/>
            </xsl:apply-templates>
        </Node>
    </xsl:template>
</xsl:stylesheet>