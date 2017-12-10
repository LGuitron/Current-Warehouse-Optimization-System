package geneticAlgorithm;
import java.lang.System;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

//EXECUTION PARAMETERS (JSON format)//
//{"startDate":"26-08-2017", "endDate":"26-12-2017" , "user_id":"1", "reservePercent":"0", "emails" : {"1" : "legl_1995@hotmail.com"}}


public class Main
{    
    //URL of the web service where all requests are made//
    public static String webServiceURL;
   
    //Dates as recevied by web app (dd-mm-yyyy)//
    public static String sinceDate;
    public static String untilDate;

    
    public static String run(String jsonInput)
    {
        //SET THE URL OF YOUR WEB SERVICE HERE//
        webServiceURL = "https://webservice-warehouse.run.aws-usw02-pr.ice.predix.io";
        
        
        String[] emails = null;
        boolean hasRecipients = false;
        String results = "";
        
        try
        {
            JSONObject inputs = new JSONObject(jsonInput);
            
            //Save input parameters into static class variables//
            InputInfo.uid = (String)inputs.get("user_id");
            InputInfo.reservePercentage = Float.parseFloat((String)inputs.get("reservePercent"));
            sinceDate = (String)inputs.get("startDate");
            untilDate = (String)inputs.get("endDate");
            InputInfo.startDate = (String)inputs.get("startDate") + " 00:00:01";
            InputInfo.endDate = (String)inputs.get("endDate") + " 23:59:59";
            hasRecipients = inputs.has("emails");
            
            //Get all emails from JSON (if any)
            if(hasRecipients)
            {
                JSONObject JSONemails = inputs.getJSONObject("emails");
                emails = new String[JSONemails.length()];
                for(int i = 0; i<JSONemails.length();i++){
                    emails[i] = (String)JSONemails.get(String.valueOf(i+1));
                }
            }
            results += predixOptimize();
            
            if(hasRecipients)
            {
                SendEmail.setRecipients(emails);
                SendEmail.sendFromGmail("Solucion GE", results);
            }
            
        }
        
        catch(Exception e)
        {
            System.out.println(e);
            return "null";
        }
        return results;
    }
    ////////////////////////////////////////////////////PREDIX/////////////////////////////////////////////////////////
    private static String predixOptimize()
    {   
        String results = "";
        //Results found
        try
        {
            //Run optimization for each separate warehouse type//
            JsonData request = new JsonData(); 
            String types = request.getData("[{\"s\":\"getZoneTypes\"}]",webServiceURL);
            JSONArray typeArray = new JSONArray(types);
            JSONObject jsonObject = new JSONObject();
            
            
            for(int i = 0;i<typeArray.length();i++)
            {
                jsonObject = typeArray.getJSONObject(i);
                String type = (String) jsonObject.get("type");
                //Values for these parameters where found with tests//
                //results += WarehouseOptimization.generateSolution(0.9f,0.01f,1000,type,30,3,10E-30,0.50f);
                results += WarehouseOptimization.generateSolution(0.9f,0.01f,1000,type,2,1,1,0.50f);
            }
        }
        
        catch(Exception e)
        {
            System.out.println(e);
            return "Error processing Warehouse Optimization";
        }
        return "Warehouse optimization complete, you can check your solution at " + webServiceURL;
    }

    ///////////////////////////////////////////////MAIN//////////////////////////////////////////////////
    /*public static void main(String[] args)
    {   
        //TEST//
        //String a = run ("{\"startDate\":\"26-10-2017\", \"endDate\":\"26-11-2017\" , \"user_id\":\"1\", \"reservePercent\":\"0\" , \"epsilon\":\"10E-25\", \"longPeriodFactor\":\"25\" , \"shortPeriodFactor\":\"3\",\"emails\" : {\"1\" : \"legl_1995@hotmail.com\"}}");

        
        //FINAL EXECUTION//
        //String a = run ("{\"startDate\":\"26-10-2017\", \"endDate\":\"26-12-2017\" , \"user_id\":\"1\", \"reservePercent\":\"1.5\",\"emails\" : {\"1\" : \"alejandra.tubilla@gmail.com\"}}");
        
        String a = run ("{\"startDate\":\"26-10-2017\", \"endDate\":\"26-12-2017\" , \"user_id\":\"1\", \"reservePercent\":\"1.5\",\"emails\" : {\"1\" : \"legl_1995@hotmail.com\"}}");
        
        System.out.println(a);
    }*/
}
