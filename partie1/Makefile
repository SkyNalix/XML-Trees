.SILENT:

all: start clean compile run check

start:
	echo "------ Making xmlTree ------"

compile: Node.java NodeContent.java Parser.java
	echo "Compiling"
	javac *.java

run:
	echo "Generating xmlTree"
	java Parser

check:
	echo "Checking validation"
	xmllint --noout --schema verification.xsd xmlTree.xml

clean:
	echo "Cleaning"
	rm -f xmlTree.xml *.class
