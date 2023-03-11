public class NodeContent {
    int id;
    String name;
    int childNode;
    int leafNode;
    int tolorg;
    int extinct;
    int confidence;
    int phylesis;

    //leaf_node,tolorg_link,extinct,confidence,phylesis
    public NodeContent(){}

    public NodeContent(int id,String name,int childNode,int leafNode,int tolorg,int extinct,int confidence,int phylesis){
        this.id = id;
        this.name = name;
        this.childNode = childNode;
        this.leafNode = leafNode;
        this.tolorg = tolorg;
        this.extinct = extinct;
        this.confidence = confidence;
        this.phylesis = phylesis;
    }

    public void print(){
        System.out.println(this.id +", " + this.name  +", " + this.childNode + ", " + this.leafNode + ", " + this.tolorg
         + ", " + this.extinct + ", " + this.extinct + ", " + this.confidence + ", " + this.phylesis
        );
    }

    public void ajout(Node n){
        if(this.id != n.src_id){
            for(int i =0; i < n.fils.size();i++){
              this.ajout(n.fils.get(i));
            }
        }else{  n.content = this;}

    }

}
