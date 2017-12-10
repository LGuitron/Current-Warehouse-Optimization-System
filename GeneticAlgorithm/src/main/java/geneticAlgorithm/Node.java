package geneticAlgorithm;
class Node {
    
    private Edge previous;
    private Edge current;
    private boolean visited;
    private float cost;

    Node(){}

    Node(Edge p, Edge c, float cost, boolean v){
        previous = p;
        current = c;
        this.cost = cost;
        visited = v;
    }

    Node(Edge p, Edge c, float cost){
        previous = p;
        current = c;
        this.cost = cost;
        visited = false;
    }

    Node(Edge p, Edge c){
        previous = p;
        current = c;
    }

    public void setPrevious(Edge v){
        previous = v;
    }

    public Edge getPrevious(){
        return previous;
    }

    public void setCurrent(Edge v){
        current = v;
    }

    public Edge getCurrent(){
        return current;
    }

    public void setVisited(boolean v){
        visited = v;
    }

    public boolean getVisited(){
        return visited;
    }

    public void setCost(float v){
        cost = v;
    }

    public float getCost(){
        return cost;
    }

    public String toString(){
        return "Prev: "+previous+" Curr: "+current+" Cost: "+cost+" Vis: "+visited+"";
    }
}
