<?xml version="1.0"?>
<xsl:transform version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		            xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/2000/svg">
   
    <xsl:output indent="yes"/>

    <xsl:variable name="spacing_x" select="1"/>
    <xsl:variable name="spacing_y" select="5"/>
    <xsl:variable name="x_line_thick" select="0.2"/>
    <xsl:variable name="y_line_thick" select="0.2"/>

    <xsl:variable name="width" select="$spacing_x * ArbreDeVie/Node/@nbFeuilles"/>
    <xsl:variable name="height" select="$spacing_y * ArbreDeVie/@max-depth"/>
    
    <xsl:template match="/">
      <svg version="1.0" width="{$width}" height="{$height}">
        <rect width="{$width}" height="{$height}" style="fill:rgb(255,255,255)" />
        <xsl:apply-templates select="/ArbreDeVie/Node">
          <xsl:with-param name="rightLimit" select="$width"/>
          <xsl:with-param name="leftLimit" select="0"/>
          <xsl:with-param name="parentX" select="$width div 2"/>
        </xsl:apply-templates>
      </svg>
    </xsl:template>

    <xsl:template match="Node">
        <xsl:param name="rightLimit" />
        <xsl:param name="leftLimit" />
        <xsl:param name="parentX" />

        <xsl:variable name="leftLimit" select="$leftLimit + (@precedingFeuilles * $spacing_x)"/>
        <xsl:variable name="rightLimit" select="$rightLimit - (@followingFeuilles * $spacing_x)"/>
        <xsl:variable name="mid" select="$leftLimit + ($rightLimit - $leftLimit) div 2"/>
        <xsl:variable name="ypos" select="@depth * $spacing_y"/>

        <xsl:if test="$parentX != $mid and (not(following-sibling::Node) or not(preceding-sibling::Node))">
          <line x1="{$mid}"
            y1="{$ypos}"
            x2="{$parentX}"
            y2="{$ypos}"
            stroke="black"
            stroke-width="{$x_line_thick}"/>
        </xsl:if>

        <line x1="{$mid}"
          y1="{$ypos}"
          x2="{$mid}"
          y2="{$ypos + $spacing_y}"
          stroke="black"
          stroke-width="{$y_line_thick}"/>

        <!-- <xsl:if test=".[not(*)] and (($ypos + $spacing_y) &lt; ($height - 5))">
          <line x1="{$mid}"
            y1="{$ypos + $spacing_y}"
            x2="{$mid}"
            y2="{$height - 5}"
            stroke="#999999" stroke-width="{$y_line_thick}" stroke-linecap="round" stroke-dasharray="1, 3"/>
        </xsl:if> -->

        <xsl:apply-templates select="Node">
          <xsl:with-param name="leftLimit" select="$leftLimit"/>
          <xsl:with-param name="rightLimit" select="$rightLimit"/>
          <xsl:with-param name="parentX" select="$mid"/>
        </xsl:apply-templates>
    </xsl:template>

</xsl:transform>