package geneticAlgorithm;
public class Edge{

    private Vertex one;
    private Vertex two;
    private float cost;
    private String name;
    private String type;


    // Constructors -------------------------------------------------------------------
    public Edge(){

    }

    public Edge(Vertex one, Vertex two){
        this.one = one;
        this.two = two;
    }

    public Edge(Vertex one, Vertex two, float cost){
        this.one = one;
        this.two = two;
        this.cost = cost;
    }

    public Edge(Vertex one, Vertex two, float cost, int name){
        this.name = Integer.toString(name);
        this.one = one;
        this.two = two;
        this.cost = cost;
    }

    public Edge(Vertex one, Vertex two, float cost, String name){
        this.name = name;
        this.one = one;
        this.two = two;
        this.cost = cost;
    }

    public Edge(Vertex one, Vertex two, float cost, String name, String type){
        this.name = name;
        this.one = one;
        this.two = two;
        this.cost = cost;
        this.type = type;
    }

    //---------------------------------------------------------------------------------

    // Verifies if Edge contains a vertex
    public boolean contains(Vertex v){
        if(v == one || v == two)
            return true;
        return false;
    }

    // Return the other vertex of the edge
    public Vertex other(Vertex v){
        if(v == one)
            return two;
        else if (v == two)
            return one;
        else
            return null;
    }

    // Return the actual vertex of edge
    public Vertex actual(Vertex v){
        if(v == one)
            return one;
        else if (v == two)
            return two;
        else
            return null;
    }

    // Set's and Get's  ---------------------------------
    public void setOne(Vertex one){
        this.one = one;
    }

    public Vertex getOne(){
        return one;
    }

    public void setTwo(Vertex two){
        this.two = two;
    }

    public Vertex getTwo(){
        return two;
    }

    public void setCost(float cost){
        this.cost = cost;
    }

    public float getCost(){
        return cost;
    }

    public void setName(String n){
        name = n;
    }

    public String getName(){
        return name;
    }

    public void setType(String n){
        type = n;
    }

    public String getType(){
        return type;
    }
    //-----------------------------------------------------

    @Override
    public String toString(){
        return "("+name+": {"+one.getX()+", "+one.getY()+"}, {"+two.getX()+", "+two.getY()+"}, C: "+ cost +" -- T: "+ type +")";
    }
}
