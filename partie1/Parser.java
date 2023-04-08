import java.io.File;
import java.util.Scanner;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.*;

public class Parser {

    public static void main(String[] args){
        Node x = parse("treeoflife_links.csv", "treeoflife_nodes.csv");
        javaToXml(x);
    }


    public static Node parse(String file,String file2){
        try {
            Scanner sc = new Scanner(new File(file));
            
            String str = "";
            sc.nextLine();
            Node racine = new Node(1);


            while(sc.hasNextLine()){
                str = sc.nextLine();
                auxiliaire(str.split(","), racine);
            }
            sc.close();

            // on parse le fichier treeoflife_nodes.csv
            Scanner sc2 = new Scanner(new File(file2));
            sc2.nextLine();

            while(sc2.hasNextLine()){
                str = sc2.nextLine();
                auxiliaireNode(parseLine(str), racine);
            }

            sc2.close();  
            return racine;
        }catch(Exception e){e.printStackTrace(); return null;}
    }

    public static String[] parseLine(String str){
        String[] tab = {"","","","","","","",""};
        
        int index = 0;
        int compteurG = 0;

        for(int i =0;i<str.length();i++){
            if(compteurG %2 ==0 && str.charAt(i) == ',' ){
                index ++; 
            } else  {
                if(str.charAt(i) == '"'){compteurG++;}
                tab[index] += str.charAt(i);
            }
        }

        return tab;
    }

    public static void auxiliaire(String[] tab,Node racine){
        Node x = new Node(Integer.parseInt(tab[0]),Integer.parseInt(tab[1]));
        x.ajout(racine, x.trg_id);
    }


    public static void auxiliaireNode(String[] tab,Node racine){
        NodeContent x = new NodeContent(Integer.parseInt(tab[0]), tab[1], Integer.parseInt(tab[2]), 
                        Integer.parseInt(tab[3]), Integer.parseInt(tab[4]), Integer.parseInt(tab[5]),
                        Integer.parseInt(tab[5]), Integer.parseInt(tab[6]));
        x.ajout(racine);           
    }


    public static void javaToXml(Node nodeRacine){

        try{
            DocumentBuilderFactory XML_Fabrique_Constructeur = DocumentBuilderFactory.newInstance();
            DocumentBuilder XML_Constructeur = XML_Fabrique_Constructeur.newDocumentBuilder();

            Document XML_Document = XML_Constructeur.newDocument();
			Element racine = XML_Document.createElement("ArbreDeVie");
			XML_Document.appendChild(racine);
            NodeToElem(nodeRacine, racine, XML_Document);
            
            
            TransformerFactory XML_Fabrique_Transformeur = TransformerFactory.newInstance();
			Transformer XML_Transformeur = XML_Fabrique_Transformeur.newTransformer();


            XML_Transformeur.setOutputProperty(OutputKeys.INDENT, "yes");
            XML_Transformeur.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");

			DOMSource source = new DOMSource(XML_Document);
			StreamResult resultat = new StreamResult(new File("xmlTree.xml"));
			XML_Transformeur.transform(source, resultat); 

        }catch(Exception e){e.printStackTrace();}
    }


    public static void NodeToElem(Node nodeRacine,Element racine,Document XML_Document){

        
            Element elem = XML_Document.createElement("Node");

            Attr atribut1 = XML_Document.createAttribute("node_id");   
            Attr atribut2 = XML_Document.createAttribute("node_name");
            Attr atribut3 = XML_Document.createAttribute("node_child");   
            Attr atribut4 = XML_Document.createAttribute("leaf_node");
            Attr atribut5 = XML_Document.createAttribute("tolorg");   
            Attr atribut6 = XML_Document.createAttribute("extinct");
            Attr atribut7 = XML_Document.createAttribute("confidence");   
            Attr atribut8 = XML_Document.createAttribute("phylesis");

            atribut1.setValue(String.valueOf(nodeRacine.content.id));
            atribut2.setValue(nodeRacine.content.name);
            atribut3.setValue(String.valueOf(nodeRacine.content.childNode) );
            atribut4.setValue(String.valueOf(nodeRacine.content.leafNode) );
            atribut5.setValue(String.valueOf(nodeRacine.content.tolorg));
            atribut6.setValue(String.valueOf(nodeRacine.content.extinct));
            atribut7.setValue(String.valueOf(nodeRacine.content.confidence));
            atribut8.setValue(String.valueOf(nodeRacine.content.phylesis));

            elem.setAttributeNode(atribut1);
            elem.setAttributeNode(atribut2);
            elem.setAttributeNode(atribut3);
            elem.setAttributeNode(atribut4);
            elem.setAttributeNode(atribut5);
            elem.setAttributeNode(atribut6);
            elem.setAttributeNode(atribut7);
            elem.setAttributeNode(atribut8);

            racine.appendChild(elem);
            for(int i =0; i < nodeRacine.fils.size();i++ ){
                NodeToElem(nodeRacine.fils.get(i), elem, XML_Document);
            }
    }

}


