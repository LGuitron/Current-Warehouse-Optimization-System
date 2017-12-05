package geneticAlgorithm;
import org.jenetics.Genotype;
import org.jenetics.EnumGene;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;
import java.util.ArrayList;

class JsonResults
{
    //Variable for storing results with particular solution_id//
    public static String solution_id;
    
    //Upload function calls the rest of the functions in this class//
    public static void upload(Genotype<EnumGene<Integer>> genotype)
    {
        insertSolution();
        getSolutionID();
        uploadResults(genotype);
        uploadOptimizationPercents();
        uploadInstructions(genotype);
    }

    //Insert solution register in DB
    private static void insertSolution()
    {
        String json = "[{\"s\":\"insertSolution\", \"uid\" : "+InputInfo.uid+" , \"since\" : \""+Main.sinceDate+"\" , \"until\" : \""+Main.untilDate+"\" , \"reservePercent\" : \""+InputInfo.reservePercentage+"\"}]";
        JsonData http = new JsonData();
        String response = http.getData(json,"https://webservice-warehouse.run.aws-usw02-pr.ice.predix.io/index.php");
    }
    
    //Get solution id for this solution after uploading this result
    private static void getSolutionID()
    {
        String json = "[{\"s\":\"solutionID\"}]";
        JsonData http = new JsonData();
        String response = http.getData(json,"https://webservice-warehouse.run.aws-usw02-pr.ice.predix.io/index.php");
        
        try
        {
            JSONObject obj = new JSONObject(response);
            solution_id = (String)obj.get("max");
        }
        catch (JSONException e)
        {
            e.printStackTrace();
        }
    }
    
    //Insert register of beacon zone mapped to each of its products in the warehouse//
    private static void uploadResults(Genotype<EnumGene<Integer>> genotype)
    {
        try
        {
            JsonData http = new JsonData();
            JSONArray array = new JSONArray();
            
            JSONObject obj = new JSONObject();
            obj.put("s", "gr");
            array.put(obj);
            
            int count = 0;
            for(int i=0;i<GenotypeCost.zoneCapacities.length;i++)
            {
                obj = new JSONObject();
                
                //Array of EANs contained in this zone (array starting and closing with {})
                String products = "{";
                String[] products2 = null;
                
                //Boolean to know if the first product of this zone has been added (for adding commas in string)//
                boolean firstProduct = true;
                for(int j=0;j<GenotypeCost.zoneCapacities[i];j++)
                {
                    products2 = new String[GenotypeCost.zoneCapacities[i]];
                    
                    int ean_index = GenotypeCost.productMapping[genotype.getChromosome().getGene(count).getAllele()];
                    if(ean_index != -1)
                    {
                        String ean = InputInfo.rev_eanMapping[ean_index];
                        products2[j] = ean;
                        if(firstProduct)
                        {
                            products+=ean;
                            firstProduct = false;
                        }
                        else
                            products+="," + ean;
                    }
                    count++;
                }
                products+="}";
                
                obj.put("section_id", InputInfo.rev_gMapping[i]);
                obj.put("data", products);
                obj.put("solution_id", solution_id);
                array.put(obj);
            }
            String json = array.toString();
            String response = http.getData(json,"https://webservice-warehouse.run.aws-usw02-pr.ice.predix.io/index.php");
        }
        
        catch (JSONException e){
            e.printStackTrace();
        }
    }
    
    //Upload optimization percentages to DB//
    private static void uploadOptimizationPercents()
    {
        String json = "[{\"s\":\"solutionPercentages\", \"time\" : "+WarehouseOptimization.timeOptPercent+" , \"distance\" : \""+WarehouseOptimization.distOptPercent+"\" , \"solution_id\" : \""+solution_id+"\"}]";
        JsonData http = new JsonData();
        String response = http.getData(json,"https://webservice-warehouse.run.aws-usw02-pr.ice.predix.io/index.php");
    }
    
    //Upload solution rearrangement instructions//
    private static void uploadInstructions(Genotype<EnumGene<Integer>> genotype)
    {
        

        
        JsonData http = new JsonData();
        
        
        int reNum = 0;
        for(int i=0;i<genotype.getChromosome().length();i++)
        {
            int DzoneIndex = genotype.getChromosome().getGene(i).getAllele();
            float horizontalDistance = GenotypeCost.d_matrix[GenotypeCost.beaconZoneMapping[i]][GenotypeCost.beaconZoneMapping[DzoneIndex]];   
            int productID = GenotypeCost.productMapping[i];
            
            //Vertical cost only considered if the product is located in a zone different than the original//
            if((GenotypeCost.beaconZoneMapping[i] != GenotypeCost.beaconZoneMapping[DzoneIndex] || GenotypeCost.floorMapping[i]!=GenotypeCost.floorMapping[DzoneIndex]) && productID!=-1)
            {
                String ean = InputInfo.rev_eanMapping[productID];
                String initialG = InputInfo.rev_gMapping[GenotypeCost.beaconZoneMapping[i]];
                String finalG = InputInfo.rev_gMapping[GenotypeCost.beaconZoneMapping[DzoneIndex]];
                String json = "[{\"s\":\"arrangeInstructions\", \"step\" : "+reNum+" , \"ean\" : \""+ean+"\" , \"initial_section\" : \""+initialG+"\" , \"final_section\" : \""+finalG+"\" , \"solution_id\" : \""+solution_id+"\" }]";
                http.getData(json,"https://webservice-warehouse.run.aws-usw02-pr.ice.predix.io/index.php");
                reNum++;
            }
        }
    }
}
