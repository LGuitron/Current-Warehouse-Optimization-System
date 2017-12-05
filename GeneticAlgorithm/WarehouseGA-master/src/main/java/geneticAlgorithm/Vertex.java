package geneticAlgorithm;
import java.util.ArrayList;

public class Vertex {
   
    private float x;
    private float y;
    private ArrayList<Vertex> neighbors = new ArrayList<>();

    public Vertex(){
    
    }

    public Vertex(float x, float y){
        this.x = x;
        this.y = y;
    }

    public void setX(float x){
        this.x = x;
    }

    public float getX(){
        return x;
    }

    public void setY(float y){
        this.y = y;
    }

    public float getY(){
        return y;
    }

    public void addNeighbor(Vertex n){
        if(!neighbors.contains(n)){
            neighbors.add(n);
            n.addNeighbor(this);
        }
    }

    public boolean removeNeighbor(Vertex n){
        if(neighbors.contains(n)){
            neighbors.remove(n);
            return true;
        }
        return false;
    }

    public ArrayList<Vertex> getNeighbors(){
        //for(int i = 0;i<neighbors.size();i++){
        //    System.out.println("N: "+neighbors.get(i));
        //}
        return neighbors;
    }

    public int getNeighborsSize(){
        return neighbors.size();
    }

    public Vertex getNeighbor(int i){
        return neighbors.get(i);
    }

    @Override
    public String toString(){
        return "{"+x+", "+y+"}";
    }
} 
