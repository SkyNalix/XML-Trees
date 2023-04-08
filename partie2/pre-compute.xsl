<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output indent="yes"/>

    <xsl:variable name="max-depth">
      <xsl:for-each select="//Node">
        <xsl:sort select="count(ancestor::*)" data-type="number"/>
        <xsl:if test="position()=last()">
          <xsl:copy-of select="count(ancestor::*)"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="/ArbreDeVie">
      <ArbreDeVie>
        <xsl:attribute name="max-depth">
          <xsl:value-of select="$max-depth"/>
        </xsl:attribute>

        <xsl:apply-templates select="Node">
          <xsl:with-param name="depth" select="0"/>
        </xsl:apply-templates>
      </ArbreDeVie>
    </xsl:template>

    <xsl:template match="Node">
        <xsl:param name="depth" />

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

        <xsl:apply-templates select="Node">
          <xsl:with-param name="depth" select="$depth + 1"/>
        </xsl:apply-templates>
      </Node>

    </xsl:template>

</xsl:stylesheet>