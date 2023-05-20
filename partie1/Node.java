import java.util.ArrayList;

public class Node {
    
    final int src_id; // id de ce Node
    int trg_id; // pere
    final ArrayList<Node> fils = new ArrayList<>();
    NodeContent content;

    public Node(int trg_id, int src_id){
        this.src_id = src_id;
        this.trg_id = trg_id;
        this.content = null;
    }

    public Node(int src_id){ // racine
        this.src_id = src_id;
    }

}
