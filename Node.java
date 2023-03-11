import java.util.ArrayList;

public class Node {
    
    int src_id;
    int trg_id;
    ArrayList<Node> fils = new ArrayList<>();
    Node parent;
    NodeContent content;

    public Node(int trg_id, int src_id){
        this.src_id = src_id;
        this.trg_id = trg_id;
        this.content = null;
    }

    public Node(int src_id){ // racine
        this.src_id = src_id;
    }

    public void ajout(Node racine,int id){
        //System.out.println(racine.src_id + "|" + id);
        if(racine.src_id == id ){
            racine.fils.add(this);
        }else{ 
            for(int i =0; i < racine.fils.size();i++){
                this.ajout(racine.fils.get(i), id);
            } 
        }
    } 


    public void printNode(){
        System.out.println(this.trg_id + ","  + this.src_id);
    }

    public void printAll(){
        this.printNode();
        for(int i =0; i < this.fils.size();i++){
            this.fils.get(i).printAll();
        }
    }


    public void ajoutNodeContent(NodeContent content){
        if(this.src_id == content.id ){
            this.content = content;
        }else{ 
            for(int i =0; i < this.fils.size();i++){
                this.ajout(this.fils.get(i), content.id);
            } 
        }
    }


    public void printAllContent(){
        if(!(this.content == null)){
            this.content.print();
            for(int i =0; i < this.fils.size();i++){
                this.fils.get(i).printAllContent();
            }
        }
    }
}
