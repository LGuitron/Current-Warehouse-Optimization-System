package mx.itesm.csf.ge_scanner;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.bluetooth.BluetoothAdapter;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Base64;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;

import com.android.volley.AuthFailureError;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.estimote.coresdk.common.requirements.SystemRequirementsChecker;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by danflovier on 10/09/2017.
 */

public class Login extends AppCompatActivity implements Spinner.OnItemSelectedListener{

    // String to save the id of the lift truck
    private String lid = "";

    // Session Manager Class
    private LoginPreferences session;

    // Request class
    private Request request;

    // Spinner of the login
    protected Spinner spinner;

    // Button of the login
    protected Button button;

    // Arraylist to save the data of the lift trucks
    protected ArrayList<String> lift_trucks;

    // Network receiver
    private LoginNetworkReceiver networkReceiver;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.login);

        //Turn ON the bluetooth in order to use it for the app
        BluetoothAdapter BT = BluetoothAdapter.getDefaultAdapter();
        if (!BT.isEnabled())
        {
            BT.enable();
        }

        SystemRequirementsChecker.checkWithDefaultDialogs(this);    //Check if requirements of the cellphone are accomplished to make the app work

        // Initializing the Spinner
        spinner = (Spinner) findViewById(R.id.spinner1);
        spinner.setOnItemSelectedListener(this);

        // Initializing the Button
        button = (Button) findViewById(R.id.button1);

        // Session Manager
        session = new LoginPreferences(getApplicationContext());

        //Initializing the ArrayList
        lift_trucks = new ArrayList<>();

        // Initializing the server request
        request = new Request(getApplicationContext());

        // Set initial behaviour of the button
        button.setClickable(false);
        button.setEnabled(false);
        button.setTextColor(Color.parseColor("#BB1D0E"));
        button.setBackgroundColor(Color.parseColor("#E84C3D"));

        // Network receiver
        networkReceiver = new LoginNetworkReceiver();

        // Check Network Broadcast
        networkBroadcast();

        // Obtain the data shown on the Spinner
        //getLiftTruckData("mont");
    }

    // Listener of the spinner to specify the behaviour of it when an item is selected
    @Override
    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
        // Pass value of the spinner as the value of the lift truck ID
        String id_lt = parent.getItemAtPosition(position).toString();
        lid = id_lt;

        // Behavior of the button depending of the option selected on the Spinner
        if(position != 0){
            isLiftTruckAvailable("selectLT", lid);
        }

        // if the user clicked on an option that is valid to put as the value of the lift truck ID
        // Then the button of START will be enabled
        else{
            button.setClickable(false);
            button.setEnabled(false);
            button.setTextColor(Color.parseColor("#BB1D0E"));
            button.setBackgroundColor(Color.parseColor("#E84C3D"));
        }

        // Behaviour of the button START when it is clicked
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                session.createLoginSession(lid);
                Intent intent = new Intent(Login.this, Tabs.class);
                startActivity(intent);
            }
        });
    }

    @Override
    public void onNothingSelected(AdapterView<?> parent) {}

    // Send to the server the lift truck ID that is going to be used
    public void isLiftTruckAvailable(final String status, final String id_lt) {

        StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST, request.URL, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                try {
                    // Save info of the response in the JSONObject
                    JSONObject products = new JSONObject(response);

                    // Extract the answer of the server from JSONObject of the response
                    String ans = products.getString("status");

                    // If the response was successfully, let the user to
                    // continue to the next activity of the app by using the enabled button
                    if(ans.equals("001")) {
                        spinner.setEnabled(false);
                        button.setClickable(true);
                        button.setEnabled(true);
                        button.setTextColor(Color.parseColor("#FFFFFF"));
                        button.setBackgroundColor(Color.parseColor("#2DCC70"));
                    }

                    // If the response wasn't successfully, let the user to choose another
                    // option from the list of the spinner
                    else {
                        Message.message(getApplicationContext(), "Sorry, the lift truck is not available. Try again!");
                        lift_trucks.clear();
                        new LoginNetworkReceiver().getLiftTruckData("mont");
                        button.setClickable(false);
                        button.setEnabled(false);
                        button.setTextColor(Color.parseColor("#BB1D0E"));
                        button.setBackgroundColor(Color.parseColor("#E84C3D"));
                    }
                }catch (JSONException e) {
                    e.printStackTrace();
                    //Message.message(getApplicationContext(), "Error: " + e.getMessage());
                }


            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                //Message.message(getApplicationContext(), "Error to connect");
            }

        }){
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<>();
                params.put("s", status);
                params.put("lt", id_lt);
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

    // Network broadcast depending the version of Android
    public void networkBroadcast() {
        // Android Nougat
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            registerReceiver(networkReceiver, new IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION));
        }

        // Android Marshmallow
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            registerReceiver(networkReceiver, new IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION));
        }
    }

    // Unregister the networkReceiver
    public void unregisterNetwork() {
        try {
            unregisterReceiver(networkReceiver);
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        }
    }

    // Finish the activity before it can't be visible to the user
    @Override
    public void onStop(){
        super.onStop();
        this.finish();
    }

    // Call the unregisterNetwork() method
    // before the activity is totally destroyed
    @Override
    public void onDestroy() {
        super.onDestroy();
        unregisterNetwork();
    }


    // Inner class to manage the events of the connectivity
    public class LoginNetworkReceiver extends BroadcastReceiver {

        // Whenever an event occurs (connectivity state) Android calls this method
        @Override
        public void onReceive(Context context, Intent intent) {
            try {
                if (isNetworkAvailable(context)) {
                    new Login();
                } else {
                    new Login();
                }
            } catch (NullPointerException e) {
                e.printStackTrace();
            }
        }

        // Check if the device is connected to Internet (Wi-Fi or Mobile)
        public boolean isNetworkAvailable(Context context) {
            // Get the connectivity service from the cellphone
            ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
            assert connectivityManager != null;

            // Get the information from the network
            NetworkInfo info = connectivityManager.getActiveNetworkInfo();

            // Check if the connectivity is available
            if (info != null && info.isConnectedOrConnecting()) {

                //Check if the connection is from Wi-Fi
                if (info.getType() == ConnectivityManager.TYPE_WIFI) {
                    if (info.isAvailable() && info.isConnectedOrConnecting()){
                        Message.message(context, "Connected to Wi-Fi");
                    }
                }

                //Check if the connection is from Mobile data plan
                else if ((info.getType() == ConnectivityManager.TYPE_MOBILE)) {
                    if (info.isAvailable() && info.isConnectedOrConnecting()) {
                        Message.message(context, "Connected to mobile data");
                    }
                }

                // Receive the data of the lift trucks available
                if (spinner.getCount() == 0) {
                    // Receive the data of the number of the lift trucks available
                    getLiftTruckData("mont");
                }
                else{
                    lift_trucks.clear();
                    spinner.setAdapter(null);
                    getLiftTruckData("mont");
                }

                return true;
            }
            else{
                lift_trucks.clear();
                spinner.setAdapter(null);

                // Set behaviour of button so it can't be clicked by the user
                button.setClickable(false);
                button.setEnabled(false);
                button.setTextColor(Color.parseColor("#BB1D0E"));
                button.setBackgroundColor(Color.parseColor("#E84C3D"));

                Message.message(context, "Not connected");
                return false;
            }
        }

        // Obtain the data shown on the Spinner
        public void getLiftTruckData(final String status) {
            StringRequest sr = new StringRequest(com.android.volley.Request.Method.POST,request.URL, new Response.Listener<String>() {

                @Override
                public void onResponse(String response) {
                    lift_trucks.add("Enter a valid option");
                    spinner.setEnabled(true);
                    try {
                        // Transform the response into JSONArray
                        JSONArray array = new JSONArray(response);

                        // Go through every index of the array
                        // for reading the data and save it in the JSONObject
                        for (int i = 0; i < array.length(); i++) {

                            // Save info of the array in the JSONObject
                            JSONObject products = (JSONObject) array.get(i);

                            // Add the data of the JSONObject to the ArrayList
                            lift_trucks.add(products.getString("id"));
                        }

                        // Setting adapter to show the items in the spinner
                        spinner.setAdapter(new ArrayAdapter<>(Login.this, android.R.layout.simple_spinner_dropdown_item, lift_trucks));

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }, new Response.ErrorListener() {
                @Override
                public void onErrorResponse(VolleyError error) {
                    // Set a message in case of error
                    //Message.message(getApplicationContext(), "Verify connectivity and restart the app!");

                    // Setting adapter to show the items in the spinner
                    spinner.setAdapter(new ArrayAdapter<>(Login.this, android.R.layout.simple_spinner_dropdown_item, lift_trucks));

                    // Set behaviour of the spinner and the buttons if there's no connectivity
                    button.setClickable(false);
                    button.setEnabled(false);
                    button.setTextColor(Color.parseColor("#BB1D0E"));
                    button.setBackgroundColor(Color.parseColor("#E84C3D"));
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
    }
}
