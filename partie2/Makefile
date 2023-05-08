.SILENT:

XSLT_COMP = java -jar saxon-he-10.3.jar

all: start clean pre-compute svg_rect svg_circ
.SILENT:

XSLT_COMP = java -jar saxon-he-10.3.jar

all: start clean pre-compute svg_rect svg_circ

start:
	echo "------ Making SVGs ------"

svg_rect:
	echo "Generating rectangulaire.svg"
	${XSLT_COMP} -s:pre-compute.xml -xsl:rectangulaire.xsl > rectangulaire.svg

svg_circ:
	echo "Generating circulaire.svg"
	${XSLT_COMP} -s:pre-compute.xml -xsl:circulaire.xsl > circulaire.svg

pre-compute:
	echo "Pre computing"
	${XSLT_COMP} -s:../xmlTree.xml -xsl:pre-compute.xsl > pre-compute.xml

clean:
	echo "Cleaning"
	rm -f *.svg pre-compute.xml

test: pre-compute testCirc

testCirc:
	${XSLT_COMP} -s:pre-compute.xml -xsl:circulaire.xsl > circulaire.svg

start:
	echo "------ Making SVGs ------"

svg_rect:
	echo "Generating rectangulaire.svg"
	${XSLT_COMP} -s:pre-compute.xml -xsl:rectangulaire.xsl > rectangulaire.svg

svg_circ:
	echo "Generating circulaire.svg"
	${XSLT_COMP} -s:pre-compute.xml -xsl:circulaire.xsl > circulaire.svg

pre-compute:
	echo "Pre computing"
	${XSLT_COMP} -s:../xmlTree.xml -xsl:pre-compute.xsl > pre-compute.xml

clean:
	echo "Cleaning"
	rm -f *.svg pre-compute.xml
