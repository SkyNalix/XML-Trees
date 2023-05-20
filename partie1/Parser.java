import java.io.File;
import java.util.Scanner;
import java.util.Map;
import java.util.HashMap;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.*;

public class Parser {
    private static final Map<Integer,Node> nodesMap = new HashMap<>();

    public static void main(String[] args){
        Node x = parse();
        if(x != null)
            javaToXml(x);
    }

    public static Node parse(){
        try {
            Scanner sc = new Scanner(new File("treeoflife_links.csv"));
            
            String str;
            sc.nextLine();
            Node racine = new Node(1);
            nodesMap.put(racine.src_id, racine);

            while(sc.hasNextLine()){
                str = sc.nextLine();
                String[] split = str.split(",");
                Node x = new Node(Integer.parseInt(split[0]),Integer.parseInt(split[1]));
                nodesMap.put(x.src_id, x);
                nodesMap.get(x.trg_id).fils.add(x);
            }
            sc.close();

            Scanner sc2 = new Scanner(new File("treeoflife_nodes.csv"));
            sc2.nextLine();
            while(sc2.hasNextLine()){
                String[] tab = parseLine(sc2.nextLine());
                NodeContent content = new NodeContent(Integer.parseInt(tab[0]), tab[1], Integer.parseInt(tab[2]),
                        Integer.parseInt(tab[3]), Integer.parseInt(tab[4]), Integer.parseInt(tab[5]),
                        Integer.parseInt(tab[5]), Integer.parseInt(tab[6]));
                nodesMap.get(content.id()).content = content;
            }
            sc2.close();

            return racine;
        } catch(Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String[] parseLine(String str){
        String[] tab = {"","","","","","","",""};

        int index = 0;
        int counterG = 0;

        for(int i =0;i<str.length();i++){
            if(counterG %2 ==0 && str.charAt(i) == ',' ){
                index ++;
            } else  {
                if(str.charAt(i) == '"'){counterG++;}
                tab[index] += str.charAt(i);
            }
        }

        return tab;
    }


    public static void javaToXml(Node nodeRacine){
        try{
            DocumentBuilderFactory XML_fabrique_constructor = DocumentBuilderFactory.newInstance();
            DocumentBuilder XML_constructor = XML_fabrique_constructor.newDocumentBuilder();

            Document XML_Document = XML_constructor.newDocument();
			Element racine = XML_Document.createElement("ArbreDeVie");
			XML_Document.appendChild(racine);
            NodeToElem(nodeRacine, racine, XML_Document);
            
            
            TransformerFactory XML_fabric_transformer = TransformerFactory.newInstance();
			Transformer XML_transformer = XML_fabric_transformer.newTransformer();


            XML_transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            XML_transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");

			DOMSource source = new DOMSource(XML_Document);
			StreamResult result = new StreamResult(new File("xmlTree.xml"));
			XML_transformer.transform(source, result);

        }catch(Exception e){e.printStackTrace();}
    }


    public static void NodeToElem(Node nodeRacine,Element racine,Document XML_Document){
            Element elem = XML_Document.createElement("Node");

            Attr attribute1 = XML_Document.createAttribute("node_id");
            Attr attribute2 = XML_Document.createAttribute("node_name");
            Attr attribute3 = XML_Document.createAttribute("node_child");
            Attr attribute4 = XML_Document.createAttribute("leaf_node");
            Attr attribute5 = XML_Document.createAttribute("tolorg");
            Attr attribute6 = XML_Document.createAttribute("extinct");
            Attr attribute7 = XML_Document.createAttribute("confidence");
            Attr attribute8 = XML_Document.createAttribute("phylesis");

            attribute1.setValue(String.valueOf(nodeRacine.content.id()));
            attribute2.setValue(nodeRacine.content.name());
            attribute3.setValue(String.valueOf(nodeRacine.content.childNode()) );
            attribute4.setValue(String.valueOf(nodeRacine.content.leafNode()) );
            attribute5.setValue(String.valueOf(nodeRacine.content.tolorg()));
            attribute6.setValue(String.valueOf(nodeRacine.content.extinct()));
            attribute7.setValue(String.valueOf(nodeRacine.content.confidence()));
            attribute8.setValue(String.valueOf(nodeRacine.content.phylesis()));

            elem.setAttributeNode(attribute1);
            elem.setAttributeNode(attribute2);
            elem.setAttributeNode(attribute3);
            elem.setAttributeNode(attribute4);
            elem.setAttributeNode(attribute5);
            elem.setAttributeNode(attribute6);
            elem.setAttributeNode(attribute7);
            elem.setAttributeNode(attribute8);

            racine.appendChild(elem);
            for(int i =0; i < nodeRacine.fils.size();i++ ){
                NodeToElem(nodeRacine.fils.get(i), elem, XML_Document);
            }
    }

}


