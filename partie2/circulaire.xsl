<?xml version="1.0"?>
<xsl:transform version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		            xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/2000/svg">
   
    <xsl:output indent="yes"/>

    <xsl:variable name="width" select="100"/>
    <xsl:variable name="height" select="100"/>
    
    <xsl:template match="/">
      <svg version="1.0" width="{$width}" height="{$height}">
        <rect width="{$width}" height="{$height}" style="fill:rgb(255,255,255)" />
        <!-- 
        <xsl:apply-templates select="/ArbreDeVie/Node"/>
        -->
      </svg>
    </xsl:template>

    <xsl:template match="Node">
        <!-- 
        <xsl:apply-templates select="Node"/>
        -->
    </xsl:template>

</xsl:transform>