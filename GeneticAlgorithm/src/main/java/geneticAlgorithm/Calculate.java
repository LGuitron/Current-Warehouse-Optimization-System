package geneticAlgorithm;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

public class Calculate{

    private static ArrayList<Edge> edges;
    private static ArrayList<Vertex> vertexes;

    //Function used for getting sections information from input file//
    public void read(String file)
    {
      String line;
      String[] words;
      Vertex[] vertices;

      try (BufferedReader br = new BufferedReader(new FileReader(file))) {

        Vertex one;
        Vertex two;
        Edge e;
        line = br.readLine();
        vertices = new Vertex[Integer.parseInt(line)];

        for(int i = 0; i < vertices.length; i++){
            line = br.readLine();
            words = line.split(" ");
            one = findOrCreate(Float.parseFloat(words[0]), Float.parseFloat(words[1]));
            two = findOrCreate(Float.parseFloat(words[2]), Float.parseFloat(words[3]));
            one.addNeighbor(two);

            e = new Edge(one, two);
            edges.add(e);
        }

      } catch (IOException e) {
             e.printStackTrace();
      }

    }

    //Function for obtaining information for the warehouse sections from the database//
    public static void getData(){

        edges = new ArrayList<>();
        vertexes = new ArrayList<>();
        String result = "";
        String id, initial_x, initial_y, final_x, final_y, type, cost;
        Vertex one;
        Vertex two;
        Edge e;

        try {
            JsonData http = new JsonData();
            String json = "[{\"s\":\"sections\"}]";
            result = http.getData(json,Main.webServiceURL + "/index.php");
            JSONArray array = new JSONArray(result);

            JSONObject jsonObject;

            for(int i = 0;i<array.length();i++){
                jsonObject = array.getJSONObject(i);
                id = (String) jsonObject.get("id");
                initial_x = (String) jsonObject.get("initial_x");
                initial_y = (String) jsonObject.get("initial_y");
                final_x = (String) jsonObject.get("final_x");
                final_y = (String) jsonObject.get("final_y");
                type = (String) jsonObject.get("type");
                cost = (String) jsonObject.get("cost");
                one = findOrCreate(Float.parseFloat(initial_x), Float.parseFloat(initial_y));
                two = findOrCreate(Float.parseFloat(final_x), Float.parseFloat(final_y));
                one.addNeighbor(two);

                e = new Edge(one, two, Float.parseFloat(cost), id, type);
                edges.add(e);
            }

        } catch (JSONException je){
            je.printStackTrace();
        }
    }

    //Calculate the distance between section "start" and section "last"//
    public static float run(Edge start, Edge last){

        ArrayList<Node> nodes = new ArrayList<>();
        int count = 1;
        Edge actual = start;
        nodes.add(new Node(start, start, 0, true));

        try{
            //Sections that have the same vertices are located in the same Beacon Section
            //so their vertical cost is equal to 0//
            while(last.getOne() != actual.getOne() || last.getTwo() != actual.getTwo())
            {
                if(addNeighbors(nodes, actual, last)){
                    actual = nodes.get(nodes.size()-1).getCurrent();
                    nodes.get(nodes.size()-1).setVisited(true);
                } else {
                    actual = nodes.get(count).getCurrent();
                    nodes.get(count).setVisited(true);
                    count++;
                }
            }
        } catch (NullPointerException e){
            System.out.println("Error: Devuelve NULL");
        }

        //Set the cost equal to the sum of costs of the sections visited between
        //the start section and the end section
        float costo = 0;
        while(start != actual){
            for(int i=0;i<nodes.size();i++){
                if(nodes.get(i).getCurrent() == actual){
                    costo += nodes.get(i).getCost();
                    actual = nodes.get(i).getPrevious();
                    break;
                }
            }
        }

        return costo;
    }

    // Function to add neighbors form the actual Edge to list, only neighbors that hasen't been visited
    private static boolean addNeighbors(ArrayList<Node> nodes, Edge v, Edge l){

        ArrayList<Edge> neighbors = findNeighbors(v);
        boolean tmp;

        for(int i=0;i<neighbors.size();i++){
            if(neighbors.get(i) == l){
                nodes.add(new Node(v, neighbors.get(i), (v.getCost() / 2) + (neighbors.get(i).getCost() / 2)));
                return true;
            }
            tmp = false;
            for(int j=0;j<nodes.size();j++){
                if(nodes.get(j).getCurrent() != neighbors.get(i)){
                    tmp = true;
                } else {
                    tmp = false;
                    break;
                }
            }
            if(tmp){
                nodes.add(new Node(v, neighbors.get(i), (v.getCost() / 2) + (neighbors.get(i).getCost() / 2) ));
            }
        }

        return false;

    }

    // Locate a Edge if exists with two given Vertexes
    private Edge findEdge(Vertex one, Vertex two){
        for(int i=0; i<edges.size();i++){
            if(edges.get(i).contains(one)){
                if(edges.get(i).contains(two)){
                    return edges.get(i);
                }
            }
        }

        return null;
    }

    // Return an ArrayList of the neighborsof an Edge
    private static ArrayList<Edge> findNeighbors(Edge v){

        ArrayList<Edge> edges_neighbors = new ArrayList<Edge>();

        for(int i=0;i<edges.size();i++){
            if(edges.get(i).contains(v.getOne()) || edges.get(i).contains(v.getTwo()) ){
                edges_neighbors.add(edges.get(i));
            }
        }

        return edges_neighbors;

    }

    // Do not duplicate veretxes, find or create
    private static Vertex findOrCreate(float x, float y){
        for(int i = 0; i<vertexes.size(); i++){
            if(vertexes.get(i).getX() == x && vertexes.get(i).getY() == y){
                return vertexes.get(i);
            }
        }

        Vertex v = new Vertex(x,y);
        vertexes.add(v);
        return v;
    }

    public static float[][] getCosts(){

        //Number of zones of type G or Z//
        int keySections=GenotypeCost.beaconZones+GenotypeCost.fixedZones;
        float[][] matriz = new float[keySections][keySections];

        float cost;
        double tiempo;
        long startTime, stopTime, elapsedTime;

        startTime = System.currentTimeMillis();
        int count = 0;
        int iCount = 0;
        int jCount;

        for(int i=0;i<edges.size();i++)
        {
            jCount = iCount+1;
            for(int j=i+1;j<edges.size();j++)
            {
                int type1 = Integer.parseInt(edges.get(i).getType());
                int type2 = Integer.parseInt(edges.get(j).getType());

                if((type1 == 1 || type1 == Integer.parseInt(InputInfo.productZone)) && (type2 == 1 || type2 == Integer.parseInt(InputInfo.productZone)))
                {
                    cost = run(edges.get(i), edges.get(j));
                    matriz[iCount][jCount] = cost;
                    matriz[jCount][iCount] = cost;
                    jCount++;

                    //If jcount is equal to the number of key sections iterate for next iCount//
                    if(jCount==keySections)
                    {
                        iCount++;
                        break;
                    }
                    count++;
                }
            }
        }

        stopTime = System.currentTimeMillis();
        elapsedTime = stopTime - startTime;
        tiempo = elapsedTime / (double)1000;

        return matriz;
    }

    public static String printMatrix(float[][] matriz){

        String m = "";
        m += "  |   ";
        for(int i=0;i<edges.size();i++)
            m += edges.get(i).getName()+"   |   ";
        m += "\n";

        m += "--|-----------------------------------------------------------------------\n";

        for(int i=0;i<edges.size();i++){
            m += edges.get(i).getName()+" | ";
            for(int j=0;j<edges.size();j++){
                m += String.format("%5.1f",  matriz[i][j])+" | ";
            }
            m += "\n--|-----------------------------------------------------------------------\n";
        }

        return m;
    }

    public static void printSections(){

        for(int i=0;i<edges.size();i++){
            System.out.println(edges.get(i));
        }

    }

}
