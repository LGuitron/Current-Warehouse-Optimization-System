package mx.itesm.csf.ge_scanner;

import android.content.Context;
import android.os.Bundle;
import android.os.RemoteException;
import android.support.v7.app.AppCompatActivity;
import android.text.Html;
import android.text.Spanned;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.Gson;

import org.altbeacon.beacon.BeaconConsumer;
import org.altbeacon.beacon.BeaconManager;
import org.altbeacon.beacon.BeaconParser;
import org.altbeacon.beacon.Identifier;
import org.altbeacon.beacon.RangeNotifier;
import org.altbeacon.beacon.Region;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class BeaconInfoActivity extends AppCompatActivity implements BeaconConsumer {

    Context context;
    EditText minorEditText;
    EditText floorEditText;
    EditText capacityEditText;
    EditText costEditText;
    Button updateZoneButton;
    Button selectClosestBeaconButton;
    Button resetBeaconButton;
    RadioButton leftRadioButton;
    RadioButton rightRadioButton;
    TextView beaconTextView;
    Spinner typeSpinner;

    private Beacon beacon;                                      // Beacon passed in as intentExtra
    private String position;                                    // RadioButtonGroup value
    private String type;
    private String highestMinor = "";                                // Closest beacon's MINOR
    private Request request = new Request(BeaconInfoActivity.this);                    // Requests to the server
    private BeaconManager beaconManager;                        // Beacon SDK
    // private String capacity;
    // private String cost;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_beacon_info);
        context = this;

        // Parse beacon object
        Gson gson = new Gson();
        String strObj = getIntent().getStringExtra("beacon");
        beacon = gson.fromJson(strObj, Beacon.class);
        position = beacon.getPosition();

        // Set the activity title
        getSupportActionBar().setTitle("Zone " + beacon.getId());
        initializeTextViews();

        // Declare beacon region to be scanned
        beaconManager = BeaconManager.getInstanceForApplication(this);
        beaconManager.getBeaconParsers().add(new BeaconParser().setBeaconLayout("m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24"));
        beaconManager.getBeaconParsers().add(new BeaconParser().setBeaconLayout("m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25"));
        beaconManager.bind(this);

        // Sets the Beacon ID field = the closest beacon's MINOR
        selectClosestBeaconButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                if (highestMinor.length() > 0) {
                    minorEditText.setText(highestMinor);
                }
            }
        });

        // Update zone's values on the server
        // We check which values have changed and we update only those
        updateZoneButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {

                type = String.valueOf(typeSpinner.getSelectedItemPosition());

                // BEACON ID
                if (!beacon.getMinor().equals(minorEditText.getText().toString()) && minorEditText.getText().toString().length() > 0) {
                    request.updateMinor(beacon.getId(), minorEditText.getText().toString(), context);
                }

                // POSITION
                if (!position.equals(beacon.getPosition())) {
                    request.updatePosition(beacon.getId(), position, context);
                }

                // We check if any fields changed from the original value
                boolean capacityChanged = !beacon.getCapacity().equals(capacityEditText.getText().toString()) && capacityEditText.getText().toString().length() > 0;
                boolean costChanged = !beacon.getCost().equals(costEditText.getText().toString()) && costEditText.getText().toString().length() > 0;
                boolean typeChanged = !type.equals(beacon.getType());
                boolean floorChanged = !beacon.getFloors().equals(floorEditText.getText().toString()) && floorEditText.getText().toString().length() > 0;

                // Only if values changed do we request the update on the server
                if (capacityChanged || costChanged || typeChanged || floorChanged) {
                    String beaconId = beacon.getId();
                    String capacity = capacityEditText.getText().toString().length() > 0 ? capacityEditText.getText().toString() : beacon.getCapacity();
                    String cost = costEditText.getText().toString().length() > 0 ? costEditText.getText().toString() : beacon.getCost();
                    String floor = floorEditText.getText().toString().length() > 0 ? floorEditText.getText().toString() : beacon.getFloors();
                    String type = String.valueOf(typeSpinner.getSelectedItemPosition());
                    request.setSections(context, beaconId, capacity, cost, floor, type);
                }
            }
        });

        // Sets the zone's beacon's MINOR = null on the server
        resetBeaconButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            request.updateMinor(beacon.getId(), "n", context);
            }
        });

        // Touch Listener to hide keyboard if you press outside of an EditText
        findViewById(R.id.linearLayout).setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                InputMethodManager imm = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(), 0);
                return true;
            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        beaconManager.unbind(this);
    }

    // Beacon Ranging with specific Region UUID to get the closest beacon
    @Override
    public void onBeaconServiceConnect() {
        beaconManager.addRangeNotifier(new RangeNotifier() {
            @Override
            public void didRangeBeaconsInRegion(final Collection<org.altbeacon.beacon.Beacon> beacons, Region region) {
                if (!beacons.isEmpty()) {
                    // We save the beacon closest to the device
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {

                            String newHighestMinor = beacons.iterator().next().getId3().toString();
                            int highestRssi = beacons.iterator().next().getRssi();

                            for (org.altbeacon.beacon.Beacon beacon : beacons) {
                                if (beacon.getRssi() > highestRssi) {
                                    newHighestMinor = beacon.getId3().toString();
                                }
                            }

                            if (!highestMinor.equals(newHighestMinor)) highestMinor = newHighestMinor;

                            String display = "ID: " + highestMinor + "  RSSI: "  + beacons.iterator().next().getRssi();
                            beaconTextView.setText(display);
                        }
                    });
                }
            }
        });

        try {
            beaconManager.startRangingBeaconsInRegion(new Region("myRangingUniqueId", Identifier.parse("4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21"), null, null));
        } catch (RemoteException e) {
            // catch error
        }
    }

    public void initializeTextViews() {
        Spanned missing = Html.fromHtml("<font color='#EE0000'>missing</font>");

        // Bind layout elements to variables
        typeSpinner = findViewById(R.id.typeSpinner);
        minorEditText = findViewById(R.id.minorEditText);
        floorEditText= findViewById(R.id.floorEditText);
        beaconTextView = findViewById(R.id.beaconTextView);
        leftRadioButton = findViewById(R.id.left);
        capacityEditText = findViewById(R.id.capacityEditText);
        costEditText = findViewById(R.id.costEditText);
        rightRadioButton = findViewById(R.id.right);
        updateZoneButton = findViewById(R.id.updateZoneButton);
        resetBeaconButton = findViewById(R.id.resetBeaconButton);
        selectClosestBeaconButton = findViewById(R.id.selectClosestBeaconButton);

        // Assign values
        floorEditText.setHint(beacon.getFloors().equals("null") ? missing : beacon.getFloors());             // FLOOR
        minorEditText.setHint(beacon.getMinor().equals("null") ? missing : beacon.getMinor());               // MINOR
        costEditText.setHint(beacon.getCost().equals("null") ? missing : beacon.getCost());                  // COST
        capacityEditText.setHint(beacon.getCapacity().equals("null") ? missing : beacon.getCapacity());      // CAPACITY
        if (position.equals("Left")) leftRadioButton.setChecked(true);                                       // LEFT
        if (position.equals("Right")) rightRadioButton.setChecked(true);                                     // RIGHT

        // If the beacon zone is 0 or 1, we don't show floor input fields
        if (beacon.getType().equals("0") || beacon.getType().equals("1")) {
            findViewById(R.id.floorFields).setVisibility(View.GONE);
        }

        addItemsOnSpinner();
        typeSpinner.setSelection(Integer.valueOf(beacon.getType()));
    }

    // add items into spinner dynamically
    public void addItemsOnSpinner() {
        List<String> list = new ArrayList<>();
        list.add("Pasillos");
        list.add("Zona de carga/descarga o producción");
        list.add("Rack con producto directo");
        list.add("Rack de tarimas");
        list.add("Espacio para productos pequeños");
        ArrayAdapter<String> dataAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, list);
        dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        typeSpinner.setAdapter(dataAdapter);
    }

    // Read values from the RadioButtonGroup
    public void onRadioButtonClicked(View view) {
        // Is the button now checked?
        boolean checked = ((RadioButton) view).isChecked();

        // Check which radio button was clicked
        switch(view.getId()) {
            case R.id.left:
                if (checked)
                    position = "Left";
                    break;
            case R.id.right:
                if (checked)
                    position = "Right";
                    break;
        }
    }
}
