package geneticAlgorithm;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.xml.bind.DatatypeConverter;
import javax.net.ssl.HttpsURLConnection;
import java.net.HttpURLConnection;

public class JsonData {

	private final String USER_AGENT = "Mozilla/5.0";

	public String getData( String json, String dataURL)
        {
            String inputLine;
            StringBuffer response = new StringBuffer();
            try{
		URL obj = new URL(dataURL);
            
		HttpsURLConnection con = (HttpsURLConnection) obj.openConnection();
             
                //add reuqest header
                con.setRequestMethod("POST");
                con.setRequestProperty("User-Agent", USER_AGENT);
                con.setRequestProperty("Content-Type","application/x-www-form-urlencoded"); 
                con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
             
                // Send post request
                con.setDoOutput(true);
                DataOutputStream wr = new DataOutputStream(con.getOutputStream());
                wr.writeBytes(json);
                wr.flush();
                wr.close();

                BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
                while ((inputLine = in.readLine()) != null)
                        response.append(inputLine);
                in.close();
                return response.toString();
            }
            catch(Exception e)
            {
                System.out.println(e);
                return "null";
            }
        }
}
