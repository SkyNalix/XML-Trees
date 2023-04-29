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

    public boolean ajout(Node children,int id){
        if(this.src_id == id ){
            this.fils.add(children);
            return true;
        } else{
            for(int i =0; i < this.fils.size();i++){
                if(this.fils.get(i).ajout(children, id)) {
                    return true;
                }
            } 
        }
        return false;
    } 

    public boolean ajoutNodeContent(NodeContent content){
        if(this.src_id == content.id ){
            this.content = content;
            return true;
        } else{
            for(int i =0; i < this.fils.size();i++){
                if(this.fils.get(i).ajoutNodeContent(content)) {
                    return true;
                }
            } 
        }
        return false;
    }

}
