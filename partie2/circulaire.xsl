<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                xmlns="http://www.w3.org/2000/svg"
          		xmlns:fun="foobar" exclude-result-prefixes="fun xsd">
  
    <xsl:output encoding="UTF-8" indent="yes"/>

    <xsl:variable name="svgSize" select="100000"/>
    <xsl:variable name="mult" select="$svgSize div 2 div /ArbreDeVie/@max-depth"/>

    <xsl:function name="fun:normCoord" as="xsd:double">
        <xsl:param name="n" as="xsd:double"/>
        <xsl:param name="depth" as="xsd:double"/>
        <xsl:sequence select="$n * ($mult * $depth) + ($svgSize div 2)"/>
    </xsl:function>

    <xsl:function name="fun:generateArcPath">
            <xsl:param name="x1"/>
            <xsl:param name="y1"/>
            <xsl:param name="x2"/>
            <xsl:param name="y2"/>
        <xsl:variable name="centerX" select="$svgSize div 2"/>
        <xsl:variable name="centerY" select="$svgSize div 2"/>
        <xsl:variable name="radius" select="math:sqrt(($centerX - $x1) * ($centerX - $x1) + ($centerY - $y1) * ($centerY - $y1))"/>
        <xsl:variable name="startAngle" select="math:atan2($y1 - $centerY, $x1 - $centerX) * 180 div math:pi()"/>
        <xsl:variable name="endAngle" select="math:atan2($y2 - $centerY, $x2 - $centerX) * 180 div math:pi()"/>
        <xsl:variable name="largeArc" select="if ($endAngle - $startAngle > 180) then 1 else 0"/>
        <xsl:variable name="x1Coord" select="$centerX + $radius * math:cos($startAngle * math:pi() div 180)"/>
        <xsl:variable name="y1Coord" select="$centerY + $radius * math:sin($startAngle * math:pi() div 180)"/>
        <xsl:variable name="x2Coord" select="$centerX + $radius * math:cos($endAngle * math:pi() div 180)"/>
        <xsl:variable name="y2Coord" select="$centerY + $radius * math:sin($endAngle * math:pi() div 180)"/>
        <xsl:variable name="d">
            <xsl:text>M</xsl:text>
            <xsl:value-of select="$x1Coord"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="$y1Coord"/>
            <xsl:text> A</xsl:text>
            <xsl:value-of select="$radius"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="$radius"/>
            <xsl:text> 0 </xsl:text>
            <xsl:value-of select="$largeArc"/>
            <xsl:text>, 1, </xsl:text>
            <xsl:value-of select="$x2Coord"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="$y2Coord"/>
        </xsl:variable>
        <xsl:sequence>
            <xsl:text>&lt;path d="</xsl:text>
            <xsl:value-of select="$d"/>
            <xsl:text>" fill="none" stroke="black" stroke-width="4"/&gt;</xsl:text>
        </xsl:sequence>
    </xsl:function>


    <xsl:function name="fun:getMid" as="xsd:double">
                <xsl:param name="n" as="element()"/>

        <xsl:choose>
            <xsl:when test="$n[not(*)]">
                <xsl:value-of select="$n/@angle"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="angles" as="xsd:string*">
                    <xsl:for-each select="$n/Node">
                        <xsl:value-of select="fun:getMid(.)"/>
                    </xsl:for-each>
                </xsl:variable>

                <xsl:variable name="angle" as="xsd:double">
                    <xsl:choose>
                        <xsl:when test="count($angles) = 1">
                            <xsl:value-of select="number($angles[1])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="left" select="number($angles[1])"/>
                            <xsl:variable name="right" select="number($angles[last()])"/>
                            <xsl:value-of select="($left + $right) div 2"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="$angle"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>


    <!-- Define the main template -->
    <xsl:template match="/">
        <svg width="{$svgSize}" height="{$svgSize}" >
        <rect x="0" y="0" width="{$svgSize}" height="{$svgSize}" fill="white"/>
        <xsl:variable name="child-results">
            <xsl:apply-templates select="/ArbreDeVie/Node" />
        </xsl:variable>
        <xsl:value-of select="substring-after($child-results, '[!]')" disable-output-escaping="yes"/>
        </svg>
    </xsl:template>

    <xsl:template match="Node" >

        <xsl:variable name="child-results" as="xsd:string*">
            <xsl:choose>
                <xsl:when test=".[not(*)]">
                    <xsl:value-of select="concat(@angle, '[!]')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="Node"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="angles" as="xsd:string*">
            <xsl:for-each select="$child-results">
                <xsl:variable name="angle" select="normalize-space(substring-before(., '[!]'))"/>
                <xsl:if test="string-length($angle) &gt; 0">
                    <xsl:sequence select="$angle" />
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="tags" as="xsd:string">
            <xsl:variable name="tags" as="xsd:string*">
                <xsl:for-each select="$child-results">
                    <xsl:variable name="tag" select="substring-after(., '[!]')"/>
                    <xsl:value-of select="$tag"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="$tags" separator=""/>
        </xsl:variable>

        <xsl:variable name="angle">
            <xsl:choose>
                <xsl:when test="count($angles) = 1">
                    <xsl:value-of select="$angles[1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="left" select="number($angles[1])"/>
                    <xsl:variable name="right" select="number($angles[last()])"/>
                    <xsl:value-of select="($left + $right) div 2"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="this-tag">
            <xsl:variable name="connectX" select="math:cos($angle)"/>
            <xsl:variable name="connectY" select="math:sin($angle)"/>

            <xsl:text>&lt;line x1="</xsl:text>
            <xsl:value-of select="fun:normCoord($connectX, @depth + 1)"/>
            <xsl:text>" y1="</xsl:text>
            <xsl:value-of select="fun:normCoord($connectY, @depth + 1)"/>
            <xsl:text>" x2="</xsl:text>
            <xsl:value-of select="fun:normCoord($connectX, @depth)"/>
            <xsl:text>" y2="</xsl:text>
            <xsl:value-of select="fun:normCoord($connectY, @depth)"/>
            <xsl:text>" stroke="red" stroke-width="4"/&gt;</xsl:text>

            <xsl:if test="not(following-sibling::Node) and preceding-sibling::Node">
                <xsl:variable name="mid" select="fun:getMid(preceding-sibling::Node[last()])"/>
                <xsl:variable name="siblingConnectX" select="math:cos($mid)"/>
                <xsl:variable name="siblingConnectY" select="math:sin($mid)"/>
                <xsl:value-of select="fun:generateArcPath(
                fun:normCoord($siblingConnectX, @depth), fun:normCoord($siblingConnectY, @depth),
                fun:normCoord($connectX, @depth), fun:normCoord($connectY, @depth))"/>
            </xsl:if>
            
            <!-- ajoute les lignes grises jusqu'a la profondeur maximale -->
<!-- 
            <xsl:if test=".[not(*)]">
                    <xsl:text>&lt;line x1="</xsl:text>
                    <xsl:value-of select="fun:normCoord($connectX, @depth + 1)"/>
                    <xsl:text>" y1="</xsl:text>
                    <xsl:value-of select="fun:normCoord($connectY, @depth + 1)"/>
                    <xsl:text>" x2="</xsl:text>
                    <xsl:value-of select="fun:normCoord($connectX, /ArbreDeVie/@max-depth)"/>
                    <xsl:text>" y2="</xsl:text>
                    <xsl:value-of select="fun:normCoord($connectY, /ArbreDeVie/@max-depth)"/>
                    <xsl:text>" stroke="#999999" stroke-width="4"/&gt;</xsl:text>
            </xsl:if> 
-->
        </xsl:variable>

        <xsl:variable name="res">
            <xsl:value-of select="$angle"/>
            <xsl:value-of select="'[!]'"/>
            <xsl:value-of select="$this-tag"/>
            <xsl:value-of select="$tags"/>
        </xsl:variable>
        <xsl:value-of select="$res"/>
    </xsl:template>

</xsl:stylesheet>
