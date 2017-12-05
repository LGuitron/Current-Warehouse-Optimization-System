package mx.itesm.csf.ge_scanner;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import org.json.JSONArray;

/* Resource
   https://stackoverflow.com/questions/31689513/broadcastreceiver-to-detect-network-is-connected
*/

/**
 * Created by danflovier on 26/09/2017.
 */
public class NetworkReceiver extends BroadcastReceiver {
    // SQLite Database
    private SQLiteAdapter db;

    // Request to the server
    private Request request;

    // Whenever an event occurs (connectivity state) Android calls this method
    @Override
    public void onReceive(Context context, Intent intent) {
        // Check connectivity state in Tabs
        try {
            if (isNetworkAvailable(context)) {
                new Tabs().connectivityState(true);
            } else {
                new Tabs().connectivityState(false);
            }
        } catch (NullPointerException e) {
            e.printStackTrace();
        }

        // Use of the internal database in SQLite
        db = new SQLiteAdapter(context);
        // Request to the server
        request = new Request(context);
    }


    // Check if the device is connected to Internet (Wi-Fi or Mobile)
    public boolean isNetworkAvailable(Context context) {
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
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

            int uploadPedingData = db.getSize(SQLiteHelper.UPLOAD_PENDING);
            int deletedProductsData = db.getSize(SQLiteHelper.DELETED_PRODUCTS);

            // Send stored data to the server if there's content into the table
            if (uploadPedingData > 0){
                sendUploadPendingProducts(context);
            }

            // Send store data to the server if there's content into the tables
            if (deletedProductsData > 0){
                // Send saved data to the server
                sendDeletedProducts(context);
            }

            // Update the data of the list products
            try {
                db.deleteData(SQLiteHelper.PRODUCTS_LIST);
                request.RequestProducts("listaProducto");
            } catch (Exception e) {
                e.printStackTrace();
                Message.message(context, "Error trying to get the list of products. Try again!");
            }

            return true;
        }
        else{
            Message.message(context, "Not connected to Internet");
            return false;
        }
    }

    // Send data of the pending products to the server
    public void sendUploadPendingProducts(Context context){

        //JSONArray
        JSONArray jsonArray;

        jsonArray = db.getJSONArray(SQLiteHelper.UPLOAD_PENDING);
        //db.deleteData("upload_pending");
        Message.message(context, jsonArray.toString());

        request.sendUploadPendingData("offline", jsonArray.toString());
    }

    // Send data of the pending products to the server
    public void sendDeletedProducts(Context context){
        //JSONArray
        JSONArray jsonArray;

        jsonArray = db.getJSONArray(SQLiteHelper.DELETED_PRODUCTS);
        //db.deleteData("upload_pending");
        Message.message(context, jsonArray.toString());

        request.sendDeletedProductsData("offline", jsonArray.toString());
    }

}
