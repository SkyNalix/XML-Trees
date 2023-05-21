<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                xmlns="http://www.w3.org/2000/svg"
          		xmlns:fun="foobar" exclude-result-prefixes="fun xsd">
  
    <xsl:output encoding="UTF-8" indent="yes"/>

    <xsl:variable name="svgSize" select="100000"/>
    <xsl:variable name="spacing" select="$svgSize div 2 div /ArbreDeVie/@max-depth"/>

    <xsl:function name="fun:normCoord" as="xsd:double">
        <xsl:param name="n" as="xsd:double"/>
        <xsl:param name="depth" as="xsd:double"/>
        <xsl:sequence select="$n * ($spacing * $depth) + ($svgSize div 2)"/>
    </xsl:function>

    <xsl:function name="fun:getMid" as="xsd:double">
                <xsl:param name="n" as="element()"/>
        <xsl:choose>
            <xsl:when test="$n[not(*)]">
                <xsl:value-of select="$n/@angle"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="angles" as="xsd:double*">
                    <xsl:for-each select="$n/Node">
                        <xsl:value-of select="fun:getMid(.)"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="angle" as="xsd:double">
                    <xsl:variable name="left" select="$angles[1]"/>
                    <xsl:variable name="right" select="$angles[last()]"/>
                    <xsl:value-of select="($left + $right) div 2"/>
                </xsl:variable>
                <xsl:value-of select="$angle"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="fun:makePath" as="xsd:string">
                <xsl:param name="start" as="xsd:double"/>
                <xsl:param name="end" as="xsd:double"/>
                <xsl:param name="depth" as="xsd:double"/>
        <xsl:variable name="x1" select="fun:normCoord(math:cos($start), $depth)"/>
        <xsl:variable name="y1" select="fun:normCoord(math:sin($start), $depth)"/>

        <xsl:variable name="centerX" select="$svgSize div 2"/>
        <xsl:variable name="centerY" select="$svgSize div 2"/>
        <xsl:variable name="radius" select="math:sqrt(($centerX - $x1) * ($centerX - $x1) + ($centerY - $y1) * ($centerY - $y1))"/>
        <xsl:variable name="largeArc" select="if (($end * 180 div math:pi()) - ($start * 180 div math:pi()) > 180) then 1 else 0"/>
        <xsl:variable name="x1Coord" select="fun:normCoord(math:cos($start), $depth)"/>
        <xsl:variable name="y1Coord" select="fun:normCoord(math:sin($start), $depth)"/>
        <xsl:variable name="x2Coord" select="fun:normCoord(math:cos($end), $depth)"/>
        <xsl:variable name="y2Coord" select="fun:normCoord(math:sin($end), $depth)"/>
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
            <xsl:text>, 0, </xsl:text>
            <xsl:value-of select="$x2Coord"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="$y2Coord"/>
        </xsl:variable>
        <xsl:variable name="res">
            <xsl:sequence>
                <xsl:text>&lt;path d="</xsl:text>
                <xsl:value-of select="$d"/>
                <xsl:text>" fill="none" stroke="black" stroke-width="4"/&gt;</xsl:text>
            </xsl:sequence>
        </xsl:variable>
        <xsl:value-of select="$res"/>
    </xsl:function>


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
            <xsl:variable name="left" select="number($angles[1])"/>
            <xsl:variable name="right" select="number($angles[last()])"/>
            <xsl:value-of select="($left + $right) div 2"/>
        </xsl:variable>

        <xsl:variable name="this-tag">
            <xsl:variable name="x" select="math:cos($angle)"/>
            <xsl:variable name="y" select="math:sin($angle)"/>

            <xsl:text>&lt;line x1="</xsl:text>
            <xsl:value-of select="fun:normCoord($x, @depth + 1)"/>
            <xsl:text>" y1="</xsl:text>
            <xsl:value-of select="fun:normCoord($y, @depth + 1)"/>
            <xsl:text>" x2="</xsl:text>
            <xsl:value-of select="fun:normCoord($x, @depth)"/>
            <xsl:text>" y2="</xsl:text>
            <xsl:value-of select="fun:normCoord($y, @depth)"/>
            <xsl:text>" stroke="red" stroke-width="4"/&gt;</xsl:text>


            <xsl:if test="preceding-sibling::Node">
                <xsl:variable name="parAngle" select="fun:getMid(..)"/>
                <xsl:variable name="siblingAngle" select="fun:getMid(preceding-sibling::Node[1])"/>
                <xsl:choose>
                    <xsl:when test="abs($angle - $parAngle) gt abs($angle - $siblingAngle)">
                        <xsl:value-of select="fun:makePath($angle, $siblingAngle, @depth)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="fun:makePath($angle, $parAngle, @depth)"/>
                        <xsl:value-of select="fun:makePath($parAngle, $siblingAngle, @depth)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            
            <!-- ajoute les lignes grises jusqu'a la profondeur maximale -->
<!-- 
            <xsl:if test=".[not(*)]">
                    <xsl:text>&lt;line x1="</xsl:text>
                    <xsl:value-of select="fun:normCoord($x, @depth + 1)"/>
                    <xsl:text>" y1="</xsl:text>
                    <xsl:value-of select="fun:normCoord($y, @depth + 1)"/>
                    <xsl:text>" x2="</xsl:text>
                    <xsl:value-of select="fun:normCoord($x, /ArbreDeVie/@max-depth)"/>
                    <xsl:text>" y2="</xsl:text>
                    <xsl:value-of select="fun:normCoord($y, /ArbreDeVie/@max-depth)"/>
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
