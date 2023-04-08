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

}
