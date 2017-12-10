package geneticAlgorithm;
import java.util.Arrays;
import java.util.Random;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;
import java.util.HashMap;
import java.util.Map;
import java.util.Iterator;
public class InputInfo
{
    //Variables passed from webapp for execution//
    public static String productZone;
    public static String uid;
    public static String startDate;
    public static String endDate;
    public static float reservePercentage;      //Reservation percentage for empty warehouse spaces//
    
    //Web service url//
    private static String url;
    private static JsonData request;
    
    //Get amount of every ean in the warehouse//
    public static HashMap<String, Integer> eanAmounts;
    
    //Maps for Z zones, G zones, and eans into indexes (0,1,2,...)//
    public static HashMap<String, Integer> zMapping;
    public static HashMap<String, Integer> gMapping;  
    public static HashMap<String, Integer> eanMapping; 
    
    //Arrays for getting keys back with indexes//
    public static String[] rev_zMapping;
    public static String[] rev_gMapping;  
    public static String[] rev_eanMapping; 
    
    
    private static int productQuantity;   //Total number of products in the warehouse//
    public static int minFloor;           //Lowest zone number in the warehouse (usually 0 or 1)//
    
    //Default values use if value could not be calculated from DB//
    private static float avgLiftTruckSpeed = 3;        //Defualt value if no one can be calculated from DV (avg lift truck ground speed 3 m/s)
    private static float fixedHorizontalTime = 60;    //Horizontal fixed time of moving product to the first floor//  
    private static float fixedVerticalTime = 10; //Fixed time to get a product from/to the second floor in case there are not enough routes to get this info from DB//
                                                //By default assume 15 seconds per higher floor//
    
    public static void predix()
    {
        url =  Main.webServiceURL+ "/index.php";
        request = new JsonData(); 
        productZones();
        beaconZones();
        fixedZones();
        distinctProds();
        Mappings();
        Calculate.getData();
        GenotypeCost.d_matrix = Calculate.getCosts();
        verticalCost();
        zoneCapacities();
        zoneFloors();
        verticalMovementCosts();
        DzoneMapping();
        productMapping();
        movementRegisters();
        generateReserveMapping();
    }
    
    //////////////////////////////////////////////////AMOUNT OF PRODUCT ZONES//////////////////////////////////////////////////
    private static void productZones()
    {
        String _productZones = request.getData("[{\"s\":\"productZones\" , \"type\" : " + productZone + "}]",url);
        try
        {
            JSONObject productZones_ = new JSONObject(_productZones);
            GenotypeCost.productZones = Integer.parseInt((String)productZones_.get("sum"));
        }
        catch(Exception e){
            System.out.println(e);}
    }
    
    //////////////////////////////////////////////////AMOUNT OF BEACON ZONES//////////////////////////////////////////////////
    private static void beaconZones()
    {
        String _beaconZones = request.getData("[{\"s\":\"beaconZones\" , \"type\" : " + productZone + "}]",url);
        try
        {
            JSONObject beaconZones_ = new JSONObject(_beaconZones);
            GenotypeCost.beaconZones = Integer.parseInt((String)beaconZones_.get("count"));
        }
        catch(Exception e){
            System.out.println(e);}
    }
    
    //////////////////////////////////////////////////AMOUNT OF FIXED ZONES//////////////////////////////////////////////////
    private static void fixedZones()
    {
        String _fixedZones = request.getData("[{\"s\":\"beaconZones\" , \"type\" : \"1\"}]",url);
        try
        {
            JSONObject fixedZones_ = new JSONObject(_fixedZones);
            GenotypeCost.fixedZones = Integer.parseInt((String)fixedZones_.get("count"));
        }
        catch(Exception e){
            System.out.println(e);}
    }
    
    //////////////////////////////////////////////////AMOUNT OF DISTINCT PRODUCTS//////////////////////////////////////////////////
    private static void distinctProds()
    {
        String _distinctProds = request.getData("[{\"s\":\"distinctProds\" , \"type\" : " + productZone + "}]",url);
        try
        {
            JSONArray distinctProds_ = new JSONArray(_distinctProds);
            //GenotypeCost.distinctProds = Integer.parseInt((String)distinctProds_.getJSONObject("0").get("count"));
            GenotypeCost.distinctProds = Integer.parseInt((String)distinctProds_.getJSONObject(0).get("count"));
        }
        catch(Exception e){
            System.out.println(e);}
    }
    
    //////////////////////////////////////////////////////ZONES & PRODUCT MAPPINGS///////////////////////////////////////////////////////////
    private static void Mappings()
    {
        String _productMapping = request.getData("[{\"s\":\"productMapping\" , \"type\" : " + productZone + "}]",url);
        String _productEans = request.getData("[{\"s\":\"productEans\"}]",url);
        String _productAmounts = request.getData("[{\"s\":\"productAmounts\" , \"type\" : " + productZone + "}]",url);
        String _zSectionMapping = request.getData("[{\"s\":\"zSecitionMapping\", \"type\" : \"1\"}]",url);
        String _gSectionMapping = request.getData("[{\"s\":\"zSecitionMapping\", \"type\" : "+productZone+"}]",url);
        
        zMapping = new HashMap<String, Integer>();
        gMapping = new HashMap<String, Integer>();
        eanMapping = new HashMap<String, Integer>();
        eanAmounts = new HashMap<String,Integer>();
        rev_zMapping  = new String[GenotypeCost.fixedZones];
        rev_gMapping = new String[GenotypeCost.beaconZones]; 
        rev_eanMapping = new String[GenotypeCost.distinctProds];  

        String section_id;
        String ean;
        int amount;
        
        try
        {
            JSONObject zSectionMapping_ = new JSONObject(_zSectionMapping);
            JSONObject gSectionMapping_ = new JSONObject(_gSectionMapping);
            JSONObject productAmounts_ = new JSONObject(_productAmounts);
            JSONArray productEans_ = new JSONArray(_productEans);

            int count = 0;
            
            //G ZONE//
            while(gSectionMapping_.has(Integer.toString(count)))
            {
                section_id = (String)(gSectionMapping_.getJSONObject(Integer.toString(count)).get("id"));
                gMapping.put(section_id, count);
                rev_gMapping[count] = section_id;
                count++;
            }
            
            //Z ZONE//
            count = 0;
            while(zSectionMapping_.has(Integer.toString(count)))
            {
                section_id = (String)(zSectionMapping_.getJSONObject(Integer.toString(count)).get("id"));
                zMapping.put(section_id, count);
                rev_zMapping[count] = section_id;
                count++;
            }
            
            //EANS//
            //Get all Eans from DB and initialize their amount to 0//
            count = 0;
            while(!productEans_.isNull(count))
            {
                ean = (String)(productEans_.getJSONObject(count).get("ean"));
                eanMapping.put(ean , count);
                eanAmounts.put(ean, 0);
                rev_eanMapping[count] = ean;
                count++;
            }
            
            //Product Amounts//
            //Change product amounts to the corresponding value//
            count = 0;
            while(productAmounts_.has(Integer.toString(count)))
            {
                ean = (String)(productAmounts_.getJSONObject(Integer.toString(count)).get("ean"));
                amount = Integer.parseInt((String)(productAmounts_.getJSONObject(Integer.toString(count)).get("count")));
                eanAmounts.put(ean, amount);
                count++;
            }
            
            //EANs//
            /*count = 0;
            while(productAmounts_.has(Integer.toString(count)))
            {
                ean = (String)(productAmounts_.getJSONObject(Integer.toString(count)).get("ean"));
                amount = Integer.parseInt((String)(productAmounts_.getJSONObject(Integer.toString(count)).get("count")));
                eanMapping.put(ean , count);
                eanAmounts.put(ean, amount);
                rev_eanMapping[count] = ean;
                count++;
                System.out.println("new: " + ean);
            }*/
        }
        catch(Exception e){
            System.out.println(e);}
    }
    
    
    ////////////////////////////////////////////AVERAGE LIFT TRUCK SPEED (VERTICAL COST)//////////////////////////////////////
    private static void verticalCost()
    {
        String _verticalCost = request.getData("[{\"s\":\"verticalCost\" , \"type\" : " + productZone + "}]",url);
        try
        {
            JSONObject verticalCost_ = new JSONObject(_verticalCost);
            if(Integer.parseInt((String)verticalCost_.get("status"))==1)
            {
                int count = 0;
                            
                //Get total distances and time from ground routes//
                float totalDistance = 0;
                int totalTime = 0;
                while(verticalCost_.has(Integer.toString(count)))
                {
                    String section1 = (String)(verticalCost_.getJSONObject(Integer.toString(count)).get("initial_section"));
                    String section2 = (String)(verticalCost_.getJSONObject(Integer.toString(count)).get("final_section"));
                    int type1 = Integer.parseInt((String)(verticalCost_.getJSONObject(Integer.toString(count)).get("initial_type")));
                    int type2 = Integer.parseInt((String)(verticalCost_.getJSONObject(Integer.toString(count)).get("final_type")));
                    totalTime += Integer.parseInt((String)(verticalCost_.getJSONObject(Integer.toString(count)).get("time")));
                    int index1 = 0;
                    int index2 = 0;
                    
                    //Get distance matrix indexes for each section//
                    if(type1==1)
                        index1=zMapping.get(section1)+GenotypeCost.beaconZones;
                    else
                        index1=gMapping.get(section1);
                    
                    if(type2==1)
                        index2=zMapping.get(section2)+GenotypeCost.beaconZones;
                    else
                        index2=gMapping.get(section2);
                    
                    totalDistance+=GenotypeCost.d_matrix[index1][index2];
                    count++;
                }
                GenotypeCost.verticalCost = totalDistance/(float)totalTime;
            }
            else
                GenotypeCost.verticalCost = avgLiftTruckSpeed;
        }
        catch(Exception e){
            System.out.println(e);}
    }
    
    ///////////////////////////////////////////////////////////G ZONE CAPACITIES///////////////////////////////////////////////
    private static void zoneCapacities()
    {
        String _zoneCapacities = request.getData("[{\"s\":\"zoneCapacities\" , \"type\" : " + productZone + "}]",url);
        try
        {
            JSONObject zoneCapacities_ = new JSONObject(_zoneCapacities);
            int count = 0;
            GenotypeCost.zoneCapacities = new int[GenotypeCost.beaconZones];
            while(zoneCapacities_.has(Integer.toString(count)))
            {
                GenotypeCost.zoneCapacities[count] = Integer.parseInt(((String)(zoneCapacities_.getJSONObject(Integer.toString(count)).get("capacity"))));
                count++;
            }
        }
        catch(Exception e){
            System.out.println(e);}
    }
    
    ///////////////////////////////////////////////////////////G ZONE FLOORS///////////////////////////////////////////////
    private static void zoneFloors()
    {
        String _zoneFloors = request.getData("[{\"s\":\"zoneFloors\" , \"type\" : " + productZone + "}]",url);
        try
        {
            JSONObject zoneFloors_ = new JSONObject(_zoneFloors);
            int count = 0;
            GenotypeCost.zoneFloors = new int[GenotypeCost.beaconZones];
            GenotypeCost.floorAmounts = 0;
            int maxFloor = Integer.parseInt(((String)(zoneFloors_.getJSONObject("0").get("floor"))));
            minFloor = Integer.parseInt(((String)(zoneFloors_.getJSONObject("0").get("floor"))));
            
            while(zoneFloors_.has(Integer.toString(count)))
            {
                int currentFloor = Integer.parseInt(((String)(zoneFloors_.getJSONObject(Integer.toString(count)).get("floor"))));
                GenotypeCost.zoneFloors[count] = currentFloor;
                
                //Get the highest floor and store value in floorAmounts//
                if(minFloor>currentFloor)
                    minFloor=currentFloor;
                if(maxFloor<currentFloor)
                    maxFloor=currentFloor;
                count++;
            }
            GenotypeCost.floorAmounts = 1 + maxFloor-minFloor;
        }
        catch(Exception e){
            System.out.println(e);}
    }
    
     ///////////////////////////////////////////////////////////VERTICAL MOVEMENT COSTS///////////////////////////////////////////////
    private static void verticalMovementCosts()
    {
        GenotypeCost.upVerticalMovementCosts = new float[GenotypeCost.floorAmounts];
        
        //Check manually the times required for each floor//
        for(int i=minFloor;i<minFloor+GenotypeCost.floorAmounts;i++)
        {
            String upCost = request.getData("[{\"s\":\"upVerticalCost\" , \"type\" : "+productZone+", \"secondFloor\" : "+i+"}]",url); 
            try
            {
                JSONObject upCost_ = new JSONObject(upCost);
                
                //At least one register to/from this floor for this WH type//
                if(Integer.parseInt((String)upCost_.get("status"))==1)
                    GenotypeCost.upVerticalMovementCosts[i-minFloor] = Float.parseFloat((String)(upCost_.getJSONObject("0").get("average")));
                
                //Assign vertical cost to the floor depending on the cost for the previous floor//
                else
                {
                    //Add constant plus the cost of previous floor for the cost of this floor//
                    if(i!=minFloor)
                        GenotypeCost.upVerticalMovementCosts[i-minFloor] = GenotypeCost.upVerticalMovementCosts[i-1-minFloor] + fixedVerticalTime;
                    
                    //In case of the first floor assign a particular constant//
                    else
                        GenotypeCost.upVerticalMovementCosts[i-minFloor] = fixedHorizontalTime;
                }
            }
            catch(Exception e){
                System.out.println(e);}
        }
        
        //Normalize times with relation to the time for a first floor route//
        float groundTime = GenotypeCost.upVerticalMovementCosts[0];   //Time required for horizontal movement (used for only getting routes vertical times)
        for(int i=0;i<GenotypeCost.floorAmounts;i++)
        {
            GenotypeCost.upVerticalMovementCosts[i]-=groundTime;
            
            //If the time of this floor results lower than the time for the previous floor reassign cost for this floor//
            if(i!=0 && GenotypeCost.upVerticalMovementCosts[i] < GenotypeCost.upVerticalMovementCosts[i-1])
                GenotypeCost.upVerticalMovementCosts[i] = GenotypeCost.upVerticalMovementCosts[i-1];
        }
    }
    
    //////////////////////////////////////////////////D ZONE MAPPING//////////////////////////////////////////
    private static void DzoneMapping()
    {
        //Zone Mapping, and beacon zone mapping (For every D zone)//
        int count = 0;
        GenotypeCost.beaconZoneMapping = new int[GenotypeCost.productZones];
        GenotypeCost.floorMapping = new int[GenotypeCost.productZones];
        for(int i=0;i<GenotypeCost.beaconZones;i++)
        {
            for(int j=0;j<GenotypeCost.zoneCapacities[i];j++)
            {
                GenotypeCost.floorMapping[count] = GenotypeCost.zoneFloors[i];
                GenotypeCost.beaconZoneMapping[count] = i;
                count++;
            }
        }
    }
    
    ////////////////////////////////////////////////////PRODUCT MAPPING//////////////////////////////////////////////////////
    private static void productMapping()
    {
        String _productMapping = request.getData("[{\"s\":\"productMapping\" , \"type\" : " + productZone + "}]",url);
        String section_id;
        String ean;
        
        try
        {
            //Product Mapping//
            //Count amount of product for each zone//
            int[] productsPerZone = new int[GenotypeCost.beaconZones];
            JSONObject productMapping_ = new JSONObject(_productMapping);
            int count = 0;
            productQuantity = 0;
            while(productMapping_.has(Integer.toString(count)))
            { 
                section_id = (String)productMapping_.getJSONObject(Integer.toString(count)).get("section_id");
                productsPerZone[gMapping.get(section_id)]++;
                productQuantity+=1;
                count++;
            }
            
            //Write product mapping using the ean mapping//
            GenotypeCost.productMapping = new int[GenotypeCost.productZones];
            Arrays.fill(GenotypeCost.productMapping, -1);   //Initialize array with -1 (empty product zones)
            count = 0;                                      //counting for product mapping array//
            int productCount = 0;                           //counting for rows obtained in JSONObject//
            for(int i=0;i<GenotypeCost.beaconZones;i++)
            {
                for(int j=0;j<productsPerZone[i];j++)
                {
                    ean = (String)productMapping_.getJSONObject(Integer.toString(productCount)).get("ean");
                    GenotypeCost.productMapping[count] = eanMapping.get(ean);
                    count++;
                    productCount++;
                }
                //Add empty zones for this zone to the counter//
                count+= (GenotypeCost.zoneCapacities[i]-productsPerZone[i]);
            }
        }
        catch(Exception e){
            System.out.println(e);}
    }
    
    /////////////////////////////////////////////////MOVEMENT REGISTERTS///////////////////////////////////////////////////////
    private static void movementRegisters()
    {
        String _incomingRegisters = request.getData("[{\"s\":\"movementRegisters\", \"type\" : " +productZone + " , \"startDate\" : \"" +startDate + "\" ,  \"endDate\" : \"" +endDate+ "\"}]",url);
        
        String _outgoingRegisters = request.getData("[{\"s\":\"outgoingRegisters\", \"type\" : " +productZone + " , \"startDate\" : \"" +startDate + "\" ,  \"endDate\" : \"" +endDate+ "\"}]",url);
        
        String section_id;
        String ean;
        
        try
        {
            GenotypeCost.movementRegisters = new int[GenotypeCost.fixedZones][GenotypeCost.distinctProds];
            /////////INCOMING/////////
            //GenotypeCost.incomingRegisters = new int[GenotypeCost.fixedZones][GenotypeCost.distinctProds];
            JSONObject incomingRegisters_ = new JSONObject(_incomingRegisters);
            int count = 0;
            while(incomingRegisters_.has(Integer.toString(count)))
            {
                section_id = (String)incomingRegisters_.getJSONObject(Integer.toString(count)).get("initial_section");
                ean = (String)incomingRegisters_.getJSONObject(Integer.toString(count)).get("ean");
                GenotypeCost.movementRegisters[zMapping.get(section_id)][eanMapping.get(ean)]+=1;
                count++;
            }
            
            
            /////////OUTGOING/////////
            //GenotypeCost.outgoingRegisters = new int[GenotypeCost.fixedZones][GenotypeCost.distinctProds];
            JSONObject outgoingRegisters_ = new JSONObject(_outgoingRegisters);
            count = 0;
            while(outgoingRegisters_.has(Integer.toString(count)))
            {
                section_id = (String)outgoingRegisters_.getJSONObject(Integer.toString(count)).get("final_section");
                ean = (String)outgoingRegisters_.getJSONObject(Integer.toString(count)).get("ean");
                GenotypeCost.movementRegisters[zMapping.get(section_id)][eanMapping.get(ean)]+=1;
                count++;
            }
        }
        catch(Exception e){
            System.out.println(e);}
    }
    
    /////////////////////////////////////////////////////////RESERVE MAPPING//////////////////////////////////////////////////////////////
    //Generate permutation of the warehouse with proportional product reservations//
    //The parameter repserents the amount of empty space that is reserved for incoming product//
    private static void generateReserveMapping()
    {
        int[] productReservations = new int[GenotypeCost.distinctProds];         //Reservations made by every product in the warehouse//
        //Proportions of different product in the warehouse//
        int[] productProportions = new int[productQuantity];
        
        int count = 0;

        //Approximation of the reservations to be made for any product//
        float reserveRatio = (float)GenotypeCost.productZones/(float)productQuantity;
        
        //Iterator it = eanAmounts.entrySet().iterator();
        Iterator<Map.Entry<String, Integer>> it = eanAmounts.entrySet().iterator();
        
        for(int i=0;i<GenotypeCost.distinctProds;i++)
        {
            //Map.Entry pair = (Map.Entry)it.next();
            Map.Entry<String,Integer> pair = it.next();
            int originalAmount = (int)pair.getValue();                                           //original amount of this particular product//
            int index = eanMapping.get(pair.getKey());                                                                       //index of this key in the eanMapping// 
            float reservations = ((float)originalAmount*reserveRatio - (float)originalAmount) * (reservePercentage/100.0f);     //Amount of reservations for this product//
            float temp = (float)originalAmount*reserveRatio - (float)originalAmount;
            productReservations[index] = Math.round(reservations);
        }
    
        //Generate reservations product mapping each product reserves
        //empty spaces proportional to the amount of product currently in the warehouse
        Random random = new Random();
        GenotypeCost.reserveProductMapping = new int[GenotypeCost.productZones];
        Arrays.fill(GenotypeCost.reserveProductMapping, -1);

        for(int i=0;i<GenotypeCost.reserveProductMapping.length;i++)
        {
            //Copy all info from product mapping array where products are located//
            if(GenotypeCost.productMapping[i]!=-1)
                GenotypeCost.reserveProductMapping[i]=GenotypeCost.productMapping[i];
                
            //Intoduce product reservation in an empty space//
            else
            {
                for(int j=0;j<GenotypeCost.distinctProds;j++)
                {
                    if(productReservations[j]>0)
                    {
                        productReservations[j]--;
                        GenotypeCost.reserveProductMapping[i]=j;
                        break;
                    }
                }
            }
        }
    }
}
