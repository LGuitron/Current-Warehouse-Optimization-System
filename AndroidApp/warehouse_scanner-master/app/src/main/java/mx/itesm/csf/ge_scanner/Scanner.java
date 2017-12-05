package mx.itesm.csf.ge_scanner;

import android.app.ActionBar;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Handler;
import android.support.v4.app.NavUtils;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.ViewGroup;
import com.google.zxing.Result;
import me.dm7.barcodescanner.zxing.ZXingScannerView;

public class Scanner extends AppCompatActivity implements ZXingScannerView.ResultHandler {
    private Request request;
    private SQLiteAdapter db;
    private ZXingScannerView mScannerView;
    private static String id_lt = Tabs.getVariable();
    private AlertDialog.Builder builder;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.scanner);

        id_lt = Tabs.getVariable();

        // Arrow button
        ActionBar actionBar = getActionBar();
        if (actionBar != null) {
            actionBar.setDisplayHomeAsUpEnabled(true);
        }

        // Viewgroup
        ViewGroup contentFrame = (ViewGroup) findViewById(R.id.content_frame);

        // Adapter of the internal database
        db = new SQLiteAdapter(getApplicationContext());

        // Request to the server
        request = new Request(getApplicationContext());

        // Builder of the AlertDialog
        builder = new AlertDialog.Builder(this);

        // Scanner
        mScannerView = new ZXingScannerView(this);

        // Adding the scanner to the Viewgroup
        contentFrame.addView(mScannerView);
    }

    // Switch of the button from the actionbar
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        // Switch of the items from the bar
        switch (item.getItemId()) {
            case android.R.id.home:
                // Go to parent activity (home)
                resumeActivity();
                return true;

            default:
                return super.onOptionsItemSelected(item);
        }
    }


    // Behaviour of the scanner when the activity is onResume()
    @Override
    public void onResume() {
        super.onResume();
        mScannerView.setResultHandler(this);
        mScannerView.setAspectTolerance(0.5f);
        mScannerView.startCamera();
    }

    // Behaviour of the scanner when the activity is onPause()
    @Override
    public void onPause() {
        super.onPause();
        mScannerView.stopCamera();
    }

    // Handle the EAN when it's found by the camera
    @Override
    public void handleResult(Result rawResult) {
        // Get the EAN
        String ean = rawResult.getText();

        // Match the EAN with a product name
        retrieveProduct(ean);
    }


    // Get the name of the product base on the EAN found by the camera
    public void retrieveProduct(String ean) {

        // Get product name from the internal database
        String productName = db.getProductName(ean);

        // Assign and send the data if the EAN found a match with a product name
        if (productName.length() == 0) {
            Message.message(getApplicationContext(), "EAN not found. Try again!");

            // Making a delay on the camera with a handler
            Handler handler;
            handler = new Handler();
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    mScannerView.resumeCameraPreview(Scanner.this);
                }
            }, 1500);
        } else {
            mScannerView.stopCameraPreview();

            setRackFloor(RandomIDGenerator.generateRandomID(), ean, productName,DateTime.getDateandTime());
        }
    }

    // Set the rack floor of the product
    public void setRackFloor(final String pid, final String ean, final String productName, final String date_time) {
        //stringID = Integer.toString(id);

        //Resources from beacons/zones pulled from Tabs.java
        final int minor = Tabs.getZoneByMinor();
        final int floors_size = Tabs.getFloors();

        //Array of strings to show floors after scanning
        String[] items = new String[floors_size + 1];

        //Insert data in array
        for(int i = 0; i < floors_size + 1; i++)
        {
            if(i == 0)
                items[i] = "Nada";
            else
                items[i] = String.valueOf(i);
        }

        // Creating the builder of the alert dialog
        builder.setTitle("RACK FLOOR")
                // Select just a single choice of the items array
                .setSingleChoiceItems(items, 0, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int item) {
                        String rack_floor =  String.valueOf(item);

                        // Check a valid option of the rack floor
                        if (item == 0)
                        {
                            Message.message(getApplicationContext(), "You must enter a valid option");
                        }
                        else
                        {
                            dialog.dismiss();
                            resumeActivity();

                            // Send the data to the database
                            request.sendToPredix (pid, ean, id_lt, "1", String.valueOf(Tabs.getSection(minor, Integer.parseInt(rack_floor))), rack_floor, date_time);

                            // Create a product with the properly parameters
                            Products product = new Products(pid, ean, productName, id_lt, "1", String.valueOf(Tabs.getSection(minor, Integer.parseInt(rack_floor))));

                            // Send the data to the function of the
                            // other fragment to manipulate the info and add a product to the list
                            Tab2_Products.addProduct(product);

                            //db.insertPID(pid);
                        }
                    }


                })
                .setOnDismissListener(new DialogInterface.OnDismissListener() {
                    @Override
                    public void onDismiss(DialogInterface dialog) {
                        mScannerView.stopCameraPreview();
                        //mScannerView.stopCamera();
                        resumeActivity();
                    }
                });

        // Create the alert dialog
        AlertDialog dialog = builder.create();

        // Display dialog
        dialog.show();
    }

    // Back to the parent activity of Scanner (Tabs) without restarting it
    public void resumeActivity(){
        Intent intent = NavUtils.getParentActivityIntent(this);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        NavUtils.navigateUpTo(this, intent);
    }
}
