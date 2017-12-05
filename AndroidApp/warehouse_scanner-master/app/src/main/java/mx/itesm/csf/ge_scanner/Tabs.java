package mx.itesm.csf.ge_scanner;

import android.Manifest;
import android.app.ProgressDialog;
import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.content.res.ColorStateList;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.RemoteException;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.TabLayout;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

import org.json.JSONArray;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Objects;
import java.util.Queue;

import com.estimote.coresdk.common.requirements.SystemRequirementsChecker;
import org.altbeacon.beacon.BeaconConsumer;
import org.altbeacon.beacon.BeaconManager;
import org.altbeacon.beacon.BeaconParser;
import org.altbeacon.beacon.MonitorNotifier;
import org.altbeacon.beacon.Region;


/**
 * Created by danflovier on 10/09/2017.
 */

public class Tabs extends AppCompatActivity implements BeaconConsumer {

    public static final String PREFS = "examplePrefs";
    private Context context;

    private SectionsPagerAdapter mSectionsPagerAdapter;
    private static final int ZXING_CAMERA_PERMISSION = 1;

    //Beacon global variables
    private BeaconManager beaconManager; //The beacon manager who is going to monitor the beacons
    public static int root_zone;  //The initial monitoring zone to start from
    private boolean on_first_region, inOneZone;  //Boolean values to know if the program is paused or is goint to start monitoring
    public static HashMap<Integer, Bicon> BeaconsDeployed;    //HashMap to sae the beacons configured in the warehouse
    public Queue<Integer> queueZones;   //Queue to save the zones where the user is
    Handler handler;    //Handler to make a simple pause before start scanning to get the beacons configuration
    public static int current_minor;    //variable to save the minor of the last beacon that was saw
    private boolean just_started;    //Boolean to know if the app has just started to scan
    private boolean confReceived;   //Boolean to know if the configuration was received already from the server
    private boolean requestAgain; //Boolean to know if the configuration window has been opened, so the configurations must been requested again

    //Trigger to know if the bluetooth changed its state ON/OFF
    private BroadcastReceiver trigger;

    // ViewPager that will host the section contents.
    private ViewPager mViewPager;

    // SQLite Database
    private SQLiteAdapter db;

    // AlertDialog
    private AlertDialog.Builder builder;
    private AlertDialog alertDialog;

    // Network receiver
    private NetworkReceiver networkReceiver;

    // String to store the id of the liftruck
    static String id_lt;

    // Shared Preferences for session login
    private LoginPreferences session;

    private FloatingActionButton fab;

    // Shared Preferences for list items
    private ProductsPreferences list_sP;

    // Request to the server
    private Request request;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.tabs);

        context = this;

        //Set the Bluetooth ON if it's not enabled
        BluetoothAdapter BT = BluetoothAdapter.getDefaultAdapter();
        if (!BT.isEnabled())
        {
            BT.enable();
        }

        //Wait dialog to know the app is starting
        new newProgressDialog().execute();

        //Gives features to the global variables
        initializeVariables();

        // Create and set the toolbar
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        // Create the adapter that will return a fragment for each of the three
        // primary sections of the activity.
        mSectionsPagerAdapter = new SectionsPagerAdapter(getSupportFragmentManager());

        // Set up the ViewPager with the sections adapter.
        mViewPager = (ViewPager) findViewById(R.id.container);
        mViewPager.setAdapter(mSectionsPagerAdapter);

        TabLayout tabLayout = (TabLayout) findViewById(R.id.tabs);
        tabLayout.setupWithViewPager(mViewPager);

        // Check Network Broadcast
        networkBroadcast();

        // Check if the permission to use the CAMERA was activated on the device
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.CAMERA}, ZXING_CAMERA_PERMISSION);
        }

        // Check connectivity to Internet
        ConnectivityManager connectivityManager = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();
        if (networkInfo != null && networkInfo.isConnected()) {
            connectivityState(true);
        } else {
            connectivityState(false);
        }
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////// BEACONS /////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////

    //Function to detect iBeacon regions that were configured in the warehouse DB
    @Override
    public void onBeaconServiceConnect()
    {
        //Add a notifier of monitoring to the beacon manager
        beaconManager.addMonitorNotifier(new MonitorNotifier()
        {
            //Function called when a monitored region was entered (the beacon was saw)
            @Override
            public void didEnterRegion(Region region)
            {
                //If the app hasn't saw a beacon yet
                if(just_started)
                {
                    runOnUiThread(new Runnable()
                    {
                        //Activate the floating button to scan the EANs
                        @Override
                        public void run()
                        {
                            fab.setEnabled(true);
                            fab.setBackgroundTintList(getResources().getColorStateList(R.color.colorPrimary));
                        }
                    });
                    just_started = false;
                }

                //get values from the zone entered
                int minor = Integer.parseInt(region.getId3().toString());
                int reg_zone;
                if(!BeaconsDeployed.get(minor).equals(null))
                {
                    reg_zone = BeaconsDeployed.get(minor).getZone();    //Get the zone from that region
                }
                else
                {
                    Message.message(getApplicationContext(), "error, beacon null");
                    reg_zone = BeaconsDeployed.get(minor).getZone();    //Get the zone from that region
                }

                //If the region is the first to be monitored
                if(!on_first_region)
                {
                    queueZones.clear(); //Clear data from previous monitoring
                    queueZones.add(minor); //Add the zone to the queue
                    current_minor = minor; //Set the current minor of the beacon entered
                    root_zone = reg_zone;  //Set the root zone value equal to the minor of the region entered
                    on_first_region = true; //Set Boolean to true so now it is known that the first region was entered
                }

                if(adjacentToQueue(reg_zone)) //If the new region entered is in adjacency of the previous entered regions in the queue
                {
                    if(inOneZone)   //In the case that the user is not in any area but the exit trigger didn't erase the zone from the queue
                    {
                        queueZones.remove();    //The zone that was exited long ago is removed as we entered now a new one
                        inOneZone = false;  //As the new zone was entered we must avoid to remove it the next time we enter to a zone (Example: Far Far zones)
                    }
                    queueZones.add(minor);   //Add the zone to the queue
                    current_minor = minor; //Set the current minor of the beacon entered
                    root_zone = reg_zone;  //Set the root zone value equal to the minor of the region entered
                }
            }

            //Function called when a monitored region was exited (the beacon is out of range)
            @Override
            public void didExitRegion(Region region)
            {
                //Get value of zone exited
                int minor = Integer.parseInt(region.getId3().toString());

                //If there's more than one zone in the queue(the user is more than one zone)
                if(queueZones.size() > 1)
                {
                    removeElementFromQueue(minor); //Remove the specific zone that was exited
                    int last_minor = queueZones.element();  //Get the last configuration of the zone that was exited
                    root_zone = BeaconsDeployed.get(last_minor).getZone(); //set the global zone to the last one entered
                    current_minor = last_minor; //Set the current_minor to the zone that is left the queue
                    inOneZone = false; //Boolean to know that the user is still in a zone
                }
                else
                    inOneZone = true;   //As we exited the last zone we entered we must keep it in the queue in order to enter a new zone by adjacency, so we use this boolean to know that the only zone left in the queue was already exited
            }

            //Function to detect if there are beacons in the monitored area or aren't seen anymore
            @Override
            public void didDetermineStateForRegion(int state, Region region) {}
        });
    }

    protected void initializeVariables() //Function to set the features of global variables declared in the class
    {
        just_started = true;
        on_first_region = false;
        confReceived = false;
        requestAgain = false;
        queueZones = new LinkedList<Integer>(); //Initialize the queue for monitoring the zones efficiently
        inOneZone = false;  //Boolean to know that the app hasn't entered a zone yet

        //Trigger for knowing if the bluetooth was enabled or disabled in the app
        trigger = new BroadcastReceiver()
        {
            @Override
            public void onReceive(Context context, Intent intent) {
                final String action = intent.getAction();
                if (action.equals(BluetoothAdapter.ACTION_STATE_CHANGED)) {
                    final int bluetoothState = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR);
                    switch (bluetoothState)
                    {
                        //If the bluetooth was enabled
                        case BluetoothAdapter.STATE_ON:
                            BeaconsDeployed = request.GetDeployedBeacons(); //Return the beacons configuration to start the monitoring
                            start_Scanning();
                            break;
                        //If the bluetooth was disabled
                        case BluetoothAdapter.STATE_OFF:
                            fab.setEnabled(false);  //Disable floating button for scanning
                            fab.setBackgroundTintList(getResources().getColorStateList(R.color.DisabledButton));
                            just_started = true;
                            on_first_region = false;
                            stop_Scanning();
                            break;
                    }
                }
            }
        };

        // Create a floating action button to use the barcode scanner
        fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View view)
            {
                Intent intent = new Intent(Tabs.this, Scanner.class);
                startActivity(intent);
            }
        });
        fab.setEnabled(false);
        fab.setBackgroundTintList(getResources().getColorStateList(R.color.DisabledButton));

        // Shared Preferences class instance for the user session
        session = new LoginPreferences(getApplicationContext());

        // Shared Preferences class instance for the list of the products
        list_sP = new ProductsPreferences(getApplicationContext());

        // Components to use the SQLite database
        db = new SQLiteAdapter(this);

        HashMap<String, String> user = session.getLiftTruckDetail();
        id_lt = user.get(LoginPreferences.KEY_LIFTTRUCK);

        // AlertDialog
        builder = new AlertDialog.Builder(this);

        // Network receiver
        networkReceiver = new NetworkReceiver();

        // Request to the server
        request = new Request(getApplicationContext());

        //AltBeacon Parsing methods for monitoring to detect estimote and kontakt beacons
        beaconManager = BeaconManager.getInstanceForApplication(this);
        beaconManager.getBeaconParsers().add(new BeaconParser().setBeaconLayout("m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24"));
        beaconManager.getBeaconParsers().add(new BeaconParser().setBeaconLayout("m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25"));
        beaconManager.setBackgroundScanPeriod(100);
        beaconManager.setForegroundBetweenScanPeriod(100);
        beaconManager.bind(this);

        //Register the trigger to know if bluetooth state changed
        IntentFilter filter = new IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED);
        registerReceiver(trigger, filter);
    }

    //Function to get the beacon configuration information again when the zones were configured before
    protected void restartBeaconsConfiguration()
    {
        just_started = true;
        on_first_region = false;
        requestAgain = false;
        BeaconsDeployed = new HashMap<Integer, Bicon>();
        queueZones = new LinkedList<Integer>();
        inOneZone = false;
        fab.setEnabled(false);
        fab.setBackgroundTintList(getResources().getColorStateList(R.color.DisabledButton));
        request.RequestBeaconsConfiguration("beacons");

        handler = new Handler();    //Handler to make sure that the requests have been made to get beacons configuration and then use that info correctly
        handler.postDelayed(new Runnable()
        {
            @Override
            public void run()
            {
                BeaconsDeployed = request.GetDeployedBeacons(); //Return the beacons configuration to start the monitoring
                confReceived = true;
                start_Scanning();
            }
        }, 1000);
    }


    //Function to remove the zone from the queue that was exited
    protected void removeElementFromQueue(int x)
    {
        for(Integer in : queueZones)
        {
            if(in == x)
            {
                queueZones.remove(in);
                break;
            }
        }
    }

    //Function to check if the new entered zone is adjacent to the regions in the queue where the user is
    protected boolean adjacentToQueue(int x)
    {
        for(Integer zon: queueZones)
        {
            if(BeaconsDeployed.get(zon) != null)
            {
                if(BeaconsDeployed.get(zon).isAdjacent(x))
                    return true;
            }
        }
        return false;
    }

    //Function to start monitoring zones according to the Warehouse DB configuration
    protected void start_Scanning()
    {
        BeaconsDeployed = new HashMap<Integer, Bicon>();
        BeaconsDeployed = request.GetDeployedBeacons();
        try
        {
            for (Bicon beacon : BeaconsDeployed.values())   //Start the monitoring of all regions
            {
                beaconManager.startMonitoringBeaconsInRegion(beacon.getRegion());
            }
        }
        catch (RemoteException e)
        {
            Message.message(getApplicationContext(), "ERROR: " + e);
        }
    }

    //Function to stop monitoring zones according to the Warehouse DB configuration
    protected void stop_Scanning()
    {
        try
        {
            for (Bicon beacon : BeaconsDeployed.values())   //Stop the monitoring of all regions
            {
                beaconManager.stopMonitoringBeaconsInRegion(beacon.getRegion());
            }
        }
        catch (RemoteException e)
        {
            Message.message(getApplicationContext(), "ERROR: " + e);
        }
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////// NETWORK ///////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////

    // Set the connectivity
    public void connectivityState(boolean connectivity){
        int LIDData = db.getSize(SQLiteHelper.LID);
        String last_LID = db.getLastLID();
        int uploadPedingData = db.getSize(SQLiteHelper.UPLOAD_PENDING);
        int deletedProductsData = db.getSize(SQLiteHelper.DELETED_PRODUCTS);

        // Validate if there's connection to Internet
        if (connectivity){

            if(confReceived == false)   //If the configuration of beacons hasn't been received yet
            {
                //If there's internet, request the beacons configuration from the warehouse
                request.RequestBeaconsConfiguration("beacons");

                handler = new Handler();    //Handler to make sure that the requests have been made to get beacons configuration and then use that info correctly
                handler.postDelayed(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        BeaconsDeployed = request.GetDeployedBeacons(); //Return the beacons configuration to start the monitoring
                        confReceived = true;
                        start_Scanning();
                    }
                }, 1000);
            }

            if (uploadPedingData > 0){
                sendUploadPendingProducts();
            }

            // Send store data to the server if there's content into the tables
            if (deletedProductsData > 0){
                // Send saved data to the server
                sendDeletedProducts();
            }

            // Insert the lift truck ID into the table
            if (LIDData == 0){
                db.insertLID(id_lt);
            }

            // Send stored data to the server of the ID of the lift truck
            if ((LIDData > 0) && (!Objects.equals(id_lt, last_LID))) {
                sendPendingLID();
            }

            // Update the data of the list products
            try {
                db.deleteData(SQLiteHelper.PRODUCTS_LIST);
                request.RequestProducts("listaProducto");
            } catch (Exception e) {
                e.printStackTrace();
                Message.message(getApplicationContext(), "Error trying to get the list of products. Try again!");
            }

        }
    }

    // Network broadcast depending the version of Android
    private void networkBroadcast() {
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
    protected void unregisterNetwork() {
        try {
            unregisterReceiver(networkReceiver);
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        }
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////// MENU /////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////

    // Inflate the menu - Add items to the action bar if it is present.
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    // Handle action bar item clicks here. The action bar will
    // automatically handle clicks on the Home/Up button, so long
    // as you specify a parent activity in AndroidManifest.xml.
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        // Item that shows the info of the upload pending products
        if (id == R.id.upload_pending) {
            showUploadPendingProducts();
            return true;
        }

        // Item that shows the product list of the splash_two
        if (id == R.id.list_products) {
            showProductsList();
            return true;
        }

        // Item to show the deleted items
        /*if (id == R.id.lid) {
            showUploadDeletedProducts();
            return true;
        }*/

        if (id == R.id.IndoorSetup) {
            stop_Scanning();
            requestAgain = true;
            Intent intent = new Intent(Tabs.this, Splash2.class);
            Tabs.this.startActivity(intent);
            this.finish();
            return true;
        }

        // Item to log out of the app
        if (id == R.id.logout) {
            //Message.message(getApplicationContext(), "EL LT ES: " + id_lt);
            request.leaveLiftTruck("unselectLT",id_lt);
            list_sP.removeList();
            session.logoutLiftTruck();
            this.finish();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    //Returns a fragment corresponding to one of the tabs.
    public class SectionsPagerAdapter extends FragmentPagerAdapter {
        public SectionsPagerAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int position) {
            switch (position) {
                case 0:
                    return Tab1_Principal.newInstance();
                case 1:
                    return Tab2_Products.newInstance();
            }
            return null;
        }

        // Obtain the number of tabs showed in the bar(2)
        @Override
        public int getCount() {
            return 2;
        }

        // Set the title of each tab
        @Override
        public CharSequence getPageTitle(int position) {
            switch (position) {
                case 0:
                    return "PRINCIPAL";
                case 1:
                    return context.getResources().getString(R.string.products_label);
            }
            return null;
        }
    }

    /////////////////////////////////////////////////////////////////////////
    ///////////////////////// GETTING DATA /////////////////////////////////
    ///////////////////////////////////////////////////////////////////////

    // Get the ID of the lifttruck to show the data in other places of the app
    public static String getVariable(){return id_lt;}
    //Get the section of the current zone
    public static int getSection(int m, int fl) {return BeaconsDeployed.get(m).getFloorZone(fl);}
    //Get the ID of the current zone
    public static int getZone() {return root_zone;}
    //Get the minor of the current zone
    public static int getZoneByMinor() {return current_minor;}
    //Get the number of floors in the current zone
    public static int getFloors() {return BeaconsDeployed.get(current_minor).getFloorsSize();}

    ////////////////////////////////////////////////////////////////////
    ////////////////////// INTERNAL DATABASE //////////////////////////
    //////////////////////////////////////////////////////////////////

    // Send data of the pending products to the server
    public void sendUploadPendingProducts(){
        // Show a Progress Dialog in the activity
        new newProgressDialog().execute();

        //JSONArray
        JSONArray jsonArray;

        jsonArray = db.getJSONArray(SQLiteHelper.UPLOAD_PENDING);
        //db.deleteData("upload_pending");
        Message.message(getApplicationContext(), jsonArray.toString());

        request.sendUploadPendingData("offline", jsonArray.toString());
    }

    // Send data of the pending products to the server
    public void sendDeletedProducts(){
        //JSONArray
        JSONArray jsonArray;

        jsonArray = db.getJSONArray(SQLiteHelper.DELETED_PRODUCTS);
        //db.deleteData("upload_pending");
        Message.message(getApplicationContext(), jsonArray.toString());

        request.sendDeletedProductsData("offline", jsonArray.toString());
    }

    // Send data of the pending products to the server
    public void sendPendingLID(){
        //JSONArray
        String last_LID;

        last_LID = db.getLastLID();
        //db.deleteData("upload_pending");
        //Message.message(getApplicationContext(), "EL LT ES: " + last_LID);
        request.leaveLiftTruck("unselectLT", last_LID);
    }

    ////////////////////////////////////////////////////////////////////
    /////////////////// ALERTDIALOG OF THE DATA ///////////////////////
    //////////////////////////////////////////////////////////////////

    // Alert dialog showing the pending products
    public void showUploadPendingProducts() {
        String database = db.getUploadPendingData();

        if (!Objects.equals(database, "")) {
            builder.setTitle(context.getResources().getString(R.string.database_content))
                    .setMessage("ID \t\t\tEAN(BARCODE)\t\tLT\tST\tSE\tRF\n" + database)
                    .setPositiveButton(context.getResources().getString(R.string.accept) ,new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    dialog.dismiss();
                                }
                            });
            alertDialog = builder.create();
            alertDialog.getWindow().setLayout(600, 400);
            alertDialog.show();
        }
        else{
            Message.message(getApplicationContext(), "No records found");
        }
    }

    // Alert dialog showing the products list of the splash_two
    public void showProductsList() {
        String database = db.getProductsData();

        if (!Objects.equals(database, "")) {
            builder.setTitle(context.getResources().getString(R.string.database_content))
                    .setMessage("ID \t\t\tEAN(BARCODE)\t\t\tNAME\n\n" + database)
                    .setPositiveButton(context.getResources().getString(R.string.accept),
                            new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    dialog.dismiss();
                                }
                            });
            alertDialog = builder.create();
            alertDialog.getWindow().setLayout(600, 400);
            alertDialog.show();
        }
        else{
            Message.message(getApplicationContext(), "No records found");
        }
    }

    // Send data of the pending products to the server
    public void showUploadDeletedProducts(){
        String database = db.getDeletedProductsData();

        if (!Objects.equals(database, "")) {
            builder.setTitle(context.getResources().getString(R.string.database_content))
                    .setMessage("DATA\n" + database)
                    .setPositiveButton(context.getResources().getString(R.string.accept), new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                        }
                    });
            alertDialog = builder.create();
            alertDialog.getWindow().setLayout(600, 400);
            alertDialog.show();
        }
        else{
            Message.message(getApplicationContext(), "No records found");
        }
    }

    // Default function of Android Studio to know if the app is running
    @Override
    protected void onResume() {
        super.onResume();
        SystemRequirementsChecker.checkWithDefaultDialogs(this);    //Check if requirements of the cellphone are accomplished to make the app work

        if(requestAgain)
        {
            requestAgain = false;
            restartBeaconsConfiguration();
        }
        else if(confReceived)
            start_Scanning();
    }

    // Default function of Android Studio to know if the app is on pause
    @Override
    protected void onPause() {
        super.onPause();
    }

    // Call the unregisterNetwork() and unbind() method
    // before the activity is totally destroyed
    @Override
    public void onDestroy() {
        super.onDestroy();
        //Unbind beacon parser configurations
        beaconManager.unbind(this);
        // Checks the unregister network changes
        unregisterNetwork();
    }


    ////////////////////////////////////////////////////////////////////
    /////////////////////////// ASYNCTASK /////////////////////////////
    //////////////////////////////////////////////////////////////////

    private class newProgressDialog extends AsyncTask<Void,Void,Void> {
        // Initialize a new instance of progress dialog
        private ProgressDialog pd = new ProgressDialog(Tabs.this);

        @Override
        protected void onPreExecute(){
            super.onPreExecute();
            // Set the title
            pd.setTitle("Processing");
            // Set a message
            pd.setMessage("Loading...");
            // Set a style of the progress
            pd.setProgressStyle(ProgressDialog.STYLE_SPINNER);
            // Sets whether the dialog is cancelable or not
            pd.setCancelable(false);
            // Show the progress dialog
            pd.show();
        }

        @Override
        protected Void doInBackground(Void...args){
            // Start Operation in a background thread
            new Thread(new Runnable() {
                @Override
                public void run() {
                        try {
                            // Set time of showing ProgressDialog
                            Thread.sleep(3000);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                        // Close the ProgressDialog
                        pd.dismiss();
                }
            }).start(); // Start the operation

            return null;
        }
    }
}