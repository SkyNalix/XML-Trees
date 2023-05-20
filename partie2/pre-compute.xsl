<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="math">
    
    <xsl:output indent="yes"/>

    <xsl:variable name="max-depth">
      <xsl:for-each select="//Node">
        <xsl:sort select="count(ancestor::*)" data-type="number"/>
        <xsl:if test="position()=last()">
          <xsl:copy-of select="count(ancestor::*)"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

  
    <xsl:variable name="nbFeuillesFromRoot" select="count(.//Node[not(*)])"/>
    <xsl:variable name="degrees-per-node" select="360 div $nbFeuillesFromRoot"/>
    
    <xsl:template match="/ArbreDeVie">
      <ArbreDeVie>
        <xsl:attribute name="max-depth">
          <xsl:value-of select="$max-depth"/>
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

        <xsl:attribute name="nbFeuilles">
          <xsl:value-of select="count(.//Node[not(*)])"/>
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
        <xsl:variable name="index" select="position()"/>
        <xsl:variable name="leftLimit" select="$leftLimit + ($precedingFeuilles * $degrees-per-node)"/>
        <xsl:variable name="rightLimit" select="$rightLimit - ($followingFeuilles * $degrees-per-node)"/>

        <xsl:variable name="mid-angle" select="($leftLimit + $rightLimit) div 2"/>
        <xsl:variable name="angle" select="2 * math:pi() * $mid-angle div 360"/>
        <xsl:variable name="x" select="math:cos($angle)"/>
        <xsl:variable name="y" select="math:sin($angle)"/>

        <xsl:attribute name="angle">
          <xsl:value-of select="$angle"/>
        </xsl:attribute>
        <xsl:attribute name="x">
          <xsl:value-of select="$x"/>
        </xsl:attribute>
        <xsl:attribute name="y">
          <xsl:value-of select="$y"/>
        </xsl:attribute>

        <xsl:apply-templates select="Node">
          <xsl:with-param name="depth" select="$depth + 1"/>
          <xsl:with-param name="leftLimit" select="$leftLimit"/>
          <xsl:with-param name="rightLimit" select="$rightLimit"/>
        </xsl:apply-templates>
      </Node>

    </xsl:template>

</xsl:stylesheet>