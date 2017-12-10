package mx.itesm.csf.ge_scanner;

import android.content.Context;
import android.graphics.Color;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.SearchView;
import android.util.Base64;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by danflovier on 23/10/2017.
 */

public class Request {
    // URL of the server
    protected String URL = "https://webservice-warehouse.run.aws-usw02-pr.ice.predix.io/index.php";

    // TAG to make a Log
    private static String TAG = Request.class.getSimpleName();

    // SQLite adapter
    private SQLiteAdapter db;
    private DataAdapter mAdapter;

    private String status;
    ArrayList<Beacon> mArrayList;

    //HashMap to save the configurations of the beacons
    HashMap<Integer, Bicon> beacons = new HashMap<Integer, Bicon>();

    // Context of the class
    Context context;

    // Constructor of the class
    Request(Context context){
        this.context = context;
        db = new SQLiteAdapter(this.context);
    }

    //Function to return the configurations by minor value
    public HashMap<Integer, Bicon> GetDeployedBeacons()
    {
        HashMap<Integer, Bicon> min_beacons = new HashMap<Integer, Bicon>();
        for (Bicon beacon : beacons.values())
        {
            min_beacons.put(beacon.getMinor(), beacon);
        }
        return min_beacons;
    }

    //Function to call the 2 requests for beacon configurations
    public void setFloorsNAdj()
    {
        RequestFloors("sectionBeaconFloor");
        RequestAdjacencies("adjacencies");
    }

    //Request to get the adjacent zones that each beacon is related to
    public void RequestAdjacencies(final String status) //status = adjacencies
    {
        StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST, URL, new Response.Listener<String>()
        {
            @Override
            public void onResponse(String response)
            {
                //Message.message(context, "response in Adjacencies");
                try
                {
                    if(!beacons.isEmpty())
                    {
                        JSONArray array = new JSONArray(response);

                        for (int i = 0; i < array.length(); i++)
                        {
                            JSONObject adjacent = (JSONObject) array.get(i);

                            int beacon_id = adjacent.getInt("beacon_id");
                            int adjbeacon_id = adjacent.getInt("adjacent_beacon_id");
                            if(beacons.get(beacon_id) != null)
                            {
                                beacons.get(beacon_id).insertBiA(adjbeacon_id);
                            }
                        }
                    }
                }
                catch (JSONException e)
                {
                    e.printStackTrace();
                    Message.message(context, "Error: " + e.getMessage());
                }
            }
        }, new Response.ErrorListener()
        {
            @Override
            public void onErrorResponse(VolleyError error)
            {
                Message.message(context, "Error to connect (adjacencies)");
            }
        }){
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<>();
                params.put("s", status);
                return params;
            }

            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                String encodedString = Base64.encodeToString(String.format("%s:%s", "app_client", "prueba123").getBytes(), Base64.NO_WRAP);
                String infoAut = String.format("Basic %s", encodedString);
                headers.put("Authorization", infoAut);
                return headers;
            }
        };
        VolleySingleton.getInstance().addToRequestQueue(sr);
    }

    //Request to add the sections and floors that each beacon is related to
    public void RequestFloors(final String status) //status = "sectionBeaconFloor"
    {
        StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST, URL, new Response.Listener<String>()
        {
            @Override
            public void onResponse(String response)
            {
                //Message.message(context, "response in Floors");
                try
                {
                    if(!beacons.isEmpty())
                    {
                        JSONArray array = new JSONArray(response);

                        for(int i = 0; i < array.length(); i++)
                        {
                            JSONObject region = (JSONObject) array.get(i);

                            if(!region.getString("beacon_minor").equals("null"))
                            {
                                int beacon_id = region.getInt("beacon_id");
                                int section_id = region.getInt("section_id");

                                if(region.getString("floor").equals("null"))
                                {
                                    if(beacons.get(beacon_id) != null)
                                        beacons.get(beacon_id).setFloor(1, section_id);
                                }
                                else
                                {
                                    if(beacons.get(beacon_id) != null)
                                        beacons.get(beacon_id).setFloor(region.getInt("floor"), section_id);
                                }
                            }
                        }
                    }
                }
                catch (JSONException e)
                {
                    e.printStackTrace();
                    Message.message(context, "Error: " + e.getMessage());
                }
            }
        }, new Response.ErrorListener()
        {
            @Override
            public void onErrorResponse(VolleyError error)
            {
                Message.message(context, "Error to connect (floors)");
            }
        }){
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<>();
                params.put("s", status);
                return params;
            }

            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                String encodedString = Base64.encodeToString(String.format("%s:%s", "app_client", "prueba123").getBytes(), Base64.NO_WRAP);
                String infoAut = String.format("Basic %s", encodedString);
                headers.put("Authorization", infoAut);
                return headers;
            }
        };
        VolleySingleton.getInstance().addToRequestQueue(sr);
    }

    //Request the beacons configuration of the warehouse
    public void RequestBeaconsConfiguration(final String status) {
        StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST,URL, new Response.Listener<String>() {

            @Override
            public void onResponse(String response) {
                Log.d(TAG, response);
                //Message.message(context, response);
                try {

                    // Transform the response into JSONArray
                    JSONArray array = new JSONArray(response);
                    beacons = new HashMap<Integer, Bicon>();

                    // Go through every index of the array
                    // for reading the data and save it in the JSONObject
                    for (int i = 0; i < array.length(); i++)
                    {

                        // Save info of the array in the JSONObject
                        JSONObject beacon = (JSONObject) array.get(i);

                        if(beacon.getString("has_beacon").equals("t") && !beacon.getString("minor").equals("null")) //If a beacon exists in the JSONObject
                        {
                            // Obtain the info inside of every
                            // attribute inside of the object
                            String uuid = beacon.getString("uuid");
                            int major, minor, id;
                            major = minor = id = 0;

                            //Catch parsing error from the JSON Object
                            try
                            {
                                id = beacon.getInt("id");
                                major = beacon.getInt("major");
                                minor = beacon.getInt("minor");
                            }
                            catch(NumberFormatException e)
                            {
                                Message.message(context, "ERROR: " + e);
                            }

                            // Insert the Beacons object with the corresponding configurations in the beacons array
                            beacons.put(id, new Bicon(uuid, major, minor, id));
                            //Message.message(context, "beacon creado con minor: "+ minor + " y id: " + id);
                        }
                    }
                    setFloorsNAdj(); //Set the floors and the adjacencies in the hashmap of the Bicon class objects
                }
                catch (JSONException e)
                {
                    e.printStackTrace();
                    Message.message(context, "Error: " + e.getMessage());
                }
            }
        }
        , new Response.ErrorListener()
        {
            @Override
            public void onErrorResponse(VolleyError error)
            {
                VolleyLog.d(TAG, "Error: " + error.getMessage());
                Toast.makeText(context, "Error to connect" + error.toString(), Toast.LENGTH_LONG).show();
            }
        })
        {
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<>();
                params.put("s", status);
                return params;
            }
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                String encodedString = Base64.encodeToString(String.format("%s:%s", "app_client", "prueba123").getBytes(), Base64.NO_WRAP);
                String infoAut = String.format("Basic %s", encodedString);
                headers.put("Authorization", infoAut);
                return headers;
            }
        };
        VolleySingleton.getInstance().addToRequestQueue(sr);
    }

    ///////////////////////////////////////////////////////////////
    /////////////////// UPLOAD PENDING PRODUCTS //////////////////
    /////////////////////////////////////////////////////////////

    // Connection to the external database (Predix). Send the products to the server
    public void sendToPredix(final String pid, final String ean, final String mont, final String status, final String section, final String rack_floor, final String date_time) {
        StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST, URL, new Response.Listener<String>() {

            @Override
            public void onResponse(String response) {

                // If the response from the server was successfully, show a message
                if(response.equals("001")) {
                    Message.message(context,"Registered (" + response +")\n EAN: " + ean );
                    //Message.message(context, pid + " " + ean + " " + mont + " " + status + " " + section + " " + rack_floor + " " + date_time );
                }

                // If the response wasn't successfully, show a error message
                else {
                    Message.message(context,"Registered (" + response + ")" );

                    // Insert the data into the internal database
                    db.insertUploadPendingData(pid, ean, mont, status, section, rack_floor, date_time);
                }
            }
        }, new Response.ErrorListener() {
            // Shows an error message in case the connectivity has failed while info transmission
            @Override
            public void onErrorResponse(VolleyError error) {
                Message.message(context, "Error to connect");

                // Insert the data into the internal database
                db.insertUploadPendingData(pid, ean, mont, status, section, rack_floor, date_time);
            }

        }){
            // Build a HashMap to pass the value of the parameters
            // and return the object to the Volley request for posting
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<>();
                params.put("pid", pid);
                params.put("ean", ean);
                params.put("mnt", mont);
                params.put("s", status);
                params.put("sec", section);
                params.put("floor", rack_floor);
                params.put("time", date_time);

                // Map of parameters to be used for a POST request
                return params;
            }

            // Authentication to provide the values for a POST request
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                String encodedString = Base64.encodeToString(String.format("%s:%s", "app_client", "prueba123").getBytes(), Base64.NO_WRAP);
                String infoAut = String.format("Basic %s", encodedString);
                headers.put("Authorization", infoAut);
                return headers;
            }
        };
        VolleySingleton.getInstance().addToRequestQueue(sr);
    }

    // Method to send the data stored on the internal database to the server
    public void sendUploadPendingData(final String status, final String json) {

        StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST, URL, new Response.Listener<String>() {

            @Override
            public void onResponse(String response) {
                // if the data was sent successfully the database deletes the data from the table
                if (response.equals("001")){
                    db.deleteData(SQLiteHelper.UPLOAD_PENDING);
                }

                // if there was an error sending the data, we delete the data from the table and
                // return the json to the database by parsing it and saving the data correctly.
                else{
                    db.deleteData(SQLiteHelper.UPLOAD_PENDING);
                    db.returnUploadPendingData(json);
                }
            }
        }, new Response.ErrorListener() {
            // Returns the data into the internal database
            // in case of error on the connectivity
            @Override
            public void onErrorResponse(VolleyError error) {
                db.deleteData(SQLiteHelper.UPLOAD_PENDING);
                db.returnUploadPendingData(json);
            }

        }){
            // Build a HashMap to pass the value of the parameters
            // and return the object to the Volley request for posting
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<>();
                params.put("s", status);
                params.put("pending_data", json);

                // Map of parameters to be used for a POST request
                return params;
            }

            // Authentication to provide the values for a POST request
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                String encodedString = Base64.encodeToString(String.format("%s:%s", "app_client", "prueba123").getBytes(), Base64.NO_WRAP);
                String infoAut = String.format("Basic %s", encodedString);
                headers.put("Authorization", infoAut);
                return headers;
            }
        };
        VolleySingleton.getInstance().addToRequestQueue(sr);
    }


    ///////////////////////////////////////////////////////////////
    ////////////////////// DELETED PRODUCTS /////////////////////
    ////////////////////////////////////////////////////////////

    // Send deleted product info to the server
    public void sendDeletedProducts(final String pid, final String ean, final String mont) {
        StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST, URL, new Response.Listener<String>() {

            @Override
            public void onResponse(String response) {
                if(response.equals("001")) {
                }
                else {
                    // Shows a message with the value of the error response
                    Message.message(context,"Registered error (" + response + ")" );

                    // Insert data that can't be sent to the server
                    db.insertDeletedProductsData(pid, ean, mont);
                }
            }
        }, new Response.ErrorListener() {

            // Insert data that can't be sent to the server
            @Override
            public void onErrorResponse(VolleyError error) {
                Message.message(context, "Error to connect");
                db.insertDeletedProductsData(pid, ean, mont);
            }

        }){

            // Build a HashMap to pass the value of the parameters
            // and return the object to the Volley request for posting
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<>();
                params.put("s", "delete");
                params.put("pid", pid);
                params.put("ean", ean);
                params.put("mnt", mont);

                // Map of parameters to be used for a POST request
                return params;
            }

            // Authentication to provide the values for a POST request
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                String encodedString = Base64.encodeToString(String.format("%s:%s", "app_client", "prueba123").getBytes(), Base64.NO_WRAP);
                String infoAut = String.format("Basic %s", encodedString);
                headers.put("Authorization", infoAut);
                return headers;
            }
        };
        VolleySingleton.getInstance().addToRequestQueue(sr);
    }

    // Send the data that is storage on the internal database
    public void sendDeletedProductsData(final String status, final String json) {

        StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST, URL, new Response.Listener<String>() {

            @Override
            public void onResponse(String response) {

                // In case of success, we make sure the data of
                // the deleted products is empty, so we delete the data again
                if (response.equals("001")){
                    db.deleteData(SQLiteHelper.DELETED_PRODUCTS);
                }

                // in case of error, we return the data to the internal database
                else{
                    db.deleteData(SQLiteHelper.DELETED_PRODUCTS);
                    db.returnDeletedProductsData(json);
                }
            }
        }, new Response.ErrorListener() {
            // Returns the data into the internal database
            // in case of error on the connectivity
            @Override
            public void onErrorResponse(VolleyError error) {
                db.deleteData(SQLiteHelper.DELETED_PRODUCTS);
                db.returnDeletedProductsData(json);
            }

        }){
            // Build a HashMap to pass the value of the parameters
            // and return the object to the Volley request for posting
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<>();
                params.put("s", status);
                params.put("deleted_products", json);

                // Map of parameters to be used for a POST request
                return params;
            }

            // Authentication to provide the values for a POST request
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                String encodedString = Base64.encodeToString(String.format("%s:%s", "app_client", "prueba123").getBytes(), Base64.NO_WRAP);
                String infoAut = String.format("Basic %s", encodedString);
                headers.put("Authorization", infoAut);
                return headers;
            }
        };
        VolleySingleton.getInstance().addToRequestQueue(sr);
    }


    //////////////////////////////////////////////////////////////
    ///////////////////// LIST OF PRODUCTS //////////////////////
    ////////////////////////////////////////////////////////////

    // Make JSON array request with ([)
    public void RequestProducts(final String status) {
        StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST,URL, new Response.Listener<String>() {

            @Override
            public void onResponse(String response) {
                Log.d(TAG, response);
                try {
                    // Transform the response into JSONArray
                    JSONArray array = new JSONArray(response);

                    // Go through every index of the array
                    // for reading the data and save it in the JSONObject
                    for (int i = 0; i < array.length(); i++) {

                        // Save info of the array in the JSONObject
                        JSONObject products = (JSONObject) array.get(i);

                        // Obtain the info inside of every
                        // attribute inside of the object
                        String name = products.getString("name");
                        String ean = products.getString("ean");

                        // Insert the information of the products in the internal database
                        db.insertProductsData(ean, name);
                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                    Message.message(context, "Error trying to receive the list. Try again");
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                VolleyLog.d(TAG, "Error: " + error.getMessage());
                Message.message(context, "Error to connect" );
            }
        }){
            // Build a HashMap to pass the value of the parameters
            // and return the object to the Volley request for posting
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<>();
                params.put("s", status);

                // Map of parameters to be used for a POST request
                return params;
            }

            // Authentication to provide the values for a POST request
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                String encodedString = Base64.encodeToString(String.format("%s:%s", "app_client", "prueba123").getBytes(), Base64.NO_WRAP);
                String infoAut = String.format("Basic %s", encodedString);
                headers.put("Authorization", infoAut);
                return headers;
            }
        };
        VolleySingleton.getInstance().addToRequestQueue(sr);
    }


    //////////////////////////////////////////////////////////////
    /////////////////////// LIFT TRUCKS /////////////////////////
    ////////////////////////////////////////////////////////////

    // Leave lift truck when user wants to log out
    public void leaveLiftTruck(final String status, final String last_LID) {

        StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST, URL, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                try {

                    // Save info of the response in the JSONObject
                    JSONObject products = new JSONObject(response);

                    // Save the eans from the server
                    String ans = products.getString("status");

                    // Shows a message if the id of the lift truck
                    // was delivered successfully
                    if(ans.equals("001")) {
                        // Data has been sent successfully,
                        // so we delete the data from the database
                        db.deleteData(SQLiteHelper.LID);
                    }
                }catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                db.deleteData(SQLiteHelper.LID);
                db.insertLID(last_LID);
            }

        }){
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<>();
                params.put("s", status);
                params.put("lt", last_LID);
                return params;
            }

            // Authentication to provide te values for a POST request
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                String encodedString = Base64.encodeToString(String.format("%s:%s", "app_client", "prueba123").getBytes(), Base64.NO_WRAP);
                String infoAut = String.format("Basic %s", encodedString);
                headers.put("Authorization", infoAut);
                return headers;
            }
        };
        VolleySingleton.getInstance().addToRequestQueue(sr);
    }



    // Make JSON array request with ([)
    public void getZones(final Context context, final RecyclerView mRecyclerView) {
        RequestQueue queue = Volley.newRequestQueue(context);
        StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST, URL, new com.android.volley.Response.Listener<String>() {

            @Override
            public void onResponse(String response) {
                try {
                    // Transform the response into JSONArray
                    JSONArray array = new JSONArray(response);
                    ArrayList tempArrayList = new ArrayList<Beacon>();

                    // Go through every index of the array
                    // for reading the data and save it in the JSONObject
                    for (int i = 0; i < array.length(); i++) {

                        // Save info of the array in the JSONObject
                        JSONObject beacons = (JSONObject) array.get(i);

                        String has_beacon = beacons.getString("has_beacon");

                        if (has_beacon.equals("t")) {
                            // Obtain the info inside of every
                            // attribute inside of the object
                            String minor = beacons.getString("minor");
                            String major = beacons.getString("major");
                            String id = beacons.getString("id");
                            String position = beacons.getString("position");

                            tempArrayList.add(new Beacon(id, minor, major, position));
                        }
                    }
                    mArrayList = new ArrayList<>(tempArrayList);
                    Collections.sort(mArrayList);

                    // Floors are requested from the server and added to the Beacon Info already downloaded
                    // Before setting the RecyclerView adapter.
                    getFloors(context, mRecyclerView);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }, new com.android.volley.Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                VolleyLog.d("MainActivity", "Error: " + error.getMessage());
            }
        }){
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<>();
                params.put("s", "beacons");
                return params;
            }
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                String encodedString = Base64.encodeToString(String.format("%s:%s", "app_client", "prueba123").getBytes(), Base64.NO_WRAP);
                String infoAut = String.format("Basic %s", encodedString);
                headers.put("Authorization", infoAut);
                return headers;
            }
        };
        queue.add(sr);
    }

    // returns how many floors each zone has registered in the database and the type of zone it is.
    public void getFloors(final Context context, final RecyclerView mRecyclerView) {
        RequestQueue queue = Volley.newRequestQueue(context);
        StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST, URL, new com.android.volley.Response.Listener<String>() {

            @Override
            public void onResponse(String response) {
                try {
                    // Transform the response into JSONArray
                    JSONArray array = new JSONArray(response);

                    // Go through every index of the array
                    // to read the data and save it in the JSONObject
                    for (int i = 0; i < array.length(); i++) {

                        // Save info of the array in the JSONObject
                        JSONObject beacons = (JSONObject) array.get(i);

                        String beacon_id = beacons.getString("beacon_id");
                        String floors = beacons.getString("floors");
                        String type = beacons.getString("type");
                        String capacity = beacons.getString("capacity");
                        String cost = beacons.getString("cost");

                        for (Beacon beacon : mArrayList) {
                            // setFloorTypeCapacityCost checks if the info belongs to an already saved Beacon
                            // if it does it adds the type and floor info to be displayed in the RecyclerView
                            beacon.setFloorTypeCapacityCost(beacon_id, floors, type, capacity, cost);
                        }
                    }
                    mAdapter = new DataAdapter(mArrayList, context);
                    mRecyclerView.setAdapter(mAdapter);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }, new com.android.volley.Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                VolleyLog.d("MainActivity", "Error: " + error.getMessage());
            }
        }){
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<>();
                params.put("s", "beaconFloors");
                return params;
            }
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                String encodedString = Base64.encodeToString(String.format("%s:%s", "app_client", "prueba123").getBytes(), Base64.NO_WRAP);
                String infoAut = String.format("Basic %s", encodedString);
                headers.put("Authorization", infoAut);
                return headers;
            }
        };
        queue.add(sr);
    }

    // Update Section info for specific ID
    public void setSections(final Context context, final String beacon_id, final String capacity, final String cost, final String floor, final String type) {
        RequestQueue queue = Volley.newRequestQueue(context);
        StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST, URL, new Response.Listener<String>() {

            @Override
            public void onResponse(String response) {
                //Toast.makeText(context, "response: " + response, Toast.LENGTH_LONG).show();
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                status = "100";
                Message.message(context, "Error to connect (" + status + ")");
            }
        }){
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<>();
                params.put("cost", cost);
                params.put("floor", floor);
                params.put("type", type);
                params.put("capacity", capacity);
                params.put("beacon", beacon_id);
                params.put("s", "setFloors");
                return params;
            }

            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                String encodedString = Base64.encodeToString(String.format("%s:%s", "app_client", "prueba123").getBytes(), Base64.NO_WRAP);
                String infoAut = String.format("Basic %s", encodedString);
                headers.put("Authorization", infoAut);
                return headers;
            }
        };
        queue.add(sr);
    }

    // Filters values on RecyclerView List when a query is typed in
    public void search(SearchView searchView) {
        searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
                return false;
            }

            @Override
            public boolean onQueryTextChange(String newText) {
                if (mAdapter != null) mAdapter.getFilter().filter(newText);
                return true;
            }
        });
    }

    // Update MINOR for specific ID
    public void updateMinor(final String id, final String minor, final Context context) {
        RequestQueue queue = Volley.newRequestQueue(context);
        StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST, URL, new Response.Listener<String>() {

            @Override
            public void onResponse(String response) {
                try {
                    JSONObject jsonResponse = new JSONObject(response);
                    status = jsonResponse.getString("status");

                    if(!status.equals("001")) {
                        if (status.equals("030")) {
                            // The only specific error we care about is if the minor is already in use
                            Message.message(context,"Error Updating ID: ID not available");
                        } else Message.message(context,"Error Updating ID " + status);
                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                status = "100";
                Message.message(context, "Error to connect (" + status + ")");
            }
        }){
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<>();
                params.put("id", id);
                params.put("minor", minor);
                params.put("s", "updateMinor");
                return params;
            }

            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                String encodedString = Base64.encodeToString(String.format("%s:%s", "app_client", "prueba123").getBytes(), Base64.NO_WRAP);
                String infoAut = String.format("Basic %s", encodedString);
                headers.put("Authorization", infoAut);
                return headers;
            }
        };
        queue.add(sr);
    }

    // Update POSITION for specific ID
    public void updatePosition(final String id, final String position, final Context context) {
        RequestQueue queue = Volley.newRequestQueue(context);
        StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST, URL, new Response.Listener<String>() {

            @Override
            public void onResponse(String response) {
                try {
                    JSONObject jsonResponse = new JSONObject(response);
                    status = jsonResponse.getString("status");

                    if(!status.equals("001"))
                        Message.message(context,"Error Updating Position " + status);

                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                status = "100";
                Message.message(context, "Error to connect (" + status + ")");
            }
        }){
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<>();
                params.put("id", id);
                params.put("position", position);
                params.put("s", "setPosition");
                return params;
            }

            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                String encodedString = Base64.encodeToString(String.format("%s:%s", "app_client", "prueba123").getBytes(), Base64.NO_WRAP);
                String infoAut = String.format("Basic %s", encodedString);
                headers.put("Authorization", infoAut);
                return headers;
            }
        };
        queue.add(sr);
    }
}
