.SILENT:

all: 
	make -C partie1 --no-print-directory
	cp partie1/xmlTree.xml ./
	echo ""
	make -C partie2 --no-print-directory
	cp partie2/rectangulaire.svg ./
	cp partie2/circulaire.svg ./

clean:
	make -C partie1 clean --no-print-directory
	make -C partie2 clean --no-print-directory
	rm -f *.svg xmlTree.xml