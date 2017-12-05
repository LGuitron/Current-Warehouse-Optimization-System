package mx.itesm.csf.ge_scanner;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.Scanner;

/*
Source: https://tech.sarathdr.com/convert-database-cursor-result-to-json-array-android-app-development-1b9702fc7bbb
*/

/**
 * Created by danflovier on 25/09/2017.
 */

public class SQLiteAdapter {

    private SQLiteHelper myhelper;
    private Context context;

    // Constructor of the class
    SQLiteAdapter(Context context) {
        this.context = context;
        myhelper = new SQLiteHelper(this.context);
    }

    ////////////////////////////////////////////////////
    ///////////////// GENERAL METHODS /////////////////
    //////////////////////////////////////////////////

    // Get the size of the table
    public int getSize(String table){
        // Open the database
        SQLiteDatabase db = myhelper.getReadableDatabase();

        // Declare a query for the database
        String query;

        // Save the number of rows of the table
        int size;

        // Cursor to go through every record of the table
        Cursor cursor;

        // Get the size
        query = "SELECT * FROM " + table;
        cursor = db.rawQuery(query, null);

        size = cursor.getCount();

        // Close the cursor
        cursor.close();

        // Close the database
        db.close();

        // Return the size of the table
        return size;
    }

    // Delete data from the table
    public void deleteData(String table){
        // Open the database
        SQLiteDatabase db = myhelper.getWritableDatabase();

        // Delete data from table
        db.delete(table, null, null);

        // Reset ID value from table
        db.delete("sqlite_sequence", "name='" + table + "'", null);
        // Close the database
        db.close();
    }

    // Make a JSONArray of the data that couldn't be sent to the server
    public JSONArray getJSONArray(String table_name) {
        // Open the database
        SQLiteDatabase db = myhelper.getReadableDatabase();

        // Make a query to the table of missing products
        String query = "SELECT * FROM " + table_name;

        // Declare a cursor to go through every record
        Cursor cursor = db.rawQuery(query, null);

        // JSONArray to save the data of the JSONObject
        JSONArray array = new JSONArray();

        // Move the cursor to the index 0 of the column
        cursor.moveToFirst();

        // Add records to the JSONArray as long as
        // the cursor can move inside the table
        while (!cursor.isAfterLast()) {
            // Get the number of the columns of the query
            int total_columns = cursor.getColumnCount();

            // Create a JSONObject to copy the data of the rows
            JSONObject table_rows = new JSONObject();

            int j = 0;

            if (table_name == SQLiteHelper.UPLOAD_PENDING){
                j = 1;
            }
            for(int i = j ;  i < total_columns ; i++ ) {
                if(cursor.getColumnName(i) != null) {
                    try {
                        // As long as the cursor can detect information
                        // the data is stored in the JSONObject
                        if(cursor.getString(i) != null) {
                            Log.wtf("SQLite info: ", cursor.getString(i));
                            // Add data to the JSONObject of each column
                            table_rows.put(cursor.getColumnName(i),cursor.getString(i));
                        }
                        else {
                            table_rows.put(cursor.getColumnName(i) , "" );
                        }
                    }
                    catch( Exception e ) {
                        Log.wtf("Error JSON: ", e.getMessage()  );
                    }
                }
            }

            array.put(table_rows);
            cursor.moveToNext();
        }

        // Close cursor
        cursor.close();

        //Close database
        db.close();

        Log.wtf("Final JSON: ", array.toString() );

        // Return the JSONArray
        return array;
    }


    //////////////////////////////////////////
    //////// UPLOAD PENDING PRODUCTS ////////
    ////////////////////////////////////////

    // Insert data to the database
    public void insertUploadPendingData(String pid, String ean, String lift_truck, String status, String section, String rack_floor, String created_at) {

        // Open the database
        SQLiteDatabase db = myhelper.getWritableDatabase();

        // Use of ContentValues to insert the records
        ContentValues values = new ContentValues();

        // Insert data in table saved_products
        values.put(SQLiteHelper.P_ID, pid);
        values.put(SQLiteHelper.EAN, ean);
        values.put(SQLiteHelper.LIFT_TRUCK, lift_truck);
        values.put(SQLiteHelper.STATUS, status);
        values.put(SQLiteHelper.SECTION, section);
        values.put(SQLiteHelper.RACK_FLOOR, rack_floor);
        values.put(SQLiteHelper.CREATED_AT, created_at);

        // Insert the record into the table
        db.insert(SQLiteHelper.UPLOAD_PENDING, null, values);

        // Close the database
        db.close();

    }

    // Get all data of the table
    public String getUploadPendingData(){
        // Open the database
        SQLiteDatabase db = myhelper.getWritableDatabase();

        // Array of string to save the records of each column
        String[] columns;

        // Cursor to go through the table of the internal database
        Cursor cursor;

        // Column ID
        int cid;

        // String buffer to save all the data loaded
        StringBuffer buffer = new StringBuffer();

        // Strings of the columns to save the data
        String pid, ean, product_name, lift_truck, status, section, rack_floor, created;

        columns = new String[]{SQLiteHelper.ID, SQLiteHelper.P_ID, SQLiteHelper.EAN, SQLiteHelper.LIFT_TRUCK, SQLiteHelper.STATUS, SQLiteHelper.SECTION, SQLiteHelper.RACK_FLOOR, SQLiteHelper.CREATED_AT};
        cursor = db.query(SQLiteHelper.UPLOAD_PENDING, columns, null, null, null, null, null);

        while (cursor.moveToNext()) {
            cid = cursor.getInt(cursor.getColumnIndex(SQLiteHelper.ID));
            ean = cursor.getString(cursor.getColumnIndex(SQLiteHelper.EAN));
            lift_truck = cursor.getString(cursor.getColumnIndex(SQLiteHelper.LIFT_TRUCK));
            status = cursor.getString(cursor.getColumnIndex(SQLiteHelper.STATUS));
            section = cursor.getString(cursor.getColumnIndex(SQLiteHelper.SECTION));
            rack_floor = cursor.getString(cursor.getColumnIndex(SQLiteHelper.RACK_FLOOR));
            buffer.append(cid + "\t\t\t" + ean + "\t\t\t" + lift_truck + "\t\t" + status + "\t\t" + section + "\t\t" + rack_floor + "\n");
        }

        // Close the database
        db.close();

        // Return the buffer of the data
        return buffer.toString();
    }

    // Method to return the data to the database
    public void returnUploadPendingData(String json){
        // Open the database
        SQLiteDatabase db = myhelper.getReadableDatabase();
        try {
            // Transform the response into JSONArray
            JSONArray array = new JSONArray(json);

            // Go through every index of the array
            // to read the data and save it in the JSONObject
            for (int i = 0; i < array.length(); i++) {

                // Save info of the array in the JSONObject
                JSONObject products = (JSONObject) array.get(i);

                // Obtain the info inside of every
                // attribute inside of the object
                String pid = products.getString(SQLiteHelper.PID);
                String ean = products.getString(SQLiteHelper.EAN);
                String lt = products.getString(SQLiteHelper.LIFT_TRUCK);
                String status = products.getString(SQLiteHelper.STATUS);
                String section = products.getString(SQLiteHelper.SECTION);
                String rack_floor = products.getString(SQLiteHelper.RACK_FLOOR);
                String created_at = products.getString(SQLiteHelper.CREATED_AT);

                insertUploadPendingData(pid,ean,lt,status,section,rack_floor,created_at);
            }
        } catch (JSONException e) {
            e.printStackTrace();
            //Message.message(context, "Error: " + e.getMessage());
        }
    }


    //////////////////////////////////////////
    ////////// LIST PRODUCTS TABLE //////////
    ////////////////////////////////////////


    // Insert data to the table
    public void insertProductsData(String ean, String product_name) {
        // Open the database
        SQLiteDatabase db = myhelper.getWritableDatabase();

        // Use of ContentValues to insert the records
        ContentValues values = new ContentValues();

        // Insert data in each column
        values.put(SQLiteHelper.EAN, ean);
        values.put(SQLiteHelper.PRODUCT_NAME, product_name);

        // Insert data into the table
        db.insert(SQLiteHelper.PRODUCTS_LIST, null, values);

        // Close the database
        db.close();
    }

    // Get all the data stored in the table of PRODUCTS_LIST
    public String getProductsData(){
        // Open the database
        SQLiteDatabase db = myhelper.getWritableDatabase();

        // Array of string to save the records of each column
        String[] columns;

        // Cursor to go through the table of the internal database
        Cursor cursor;

        // Column ID
        int cid;

        // String buffer to save all the data loaded
        StringBuffer buffer = new StringBuffer();

        // String to save the data
        String ean, product_name;

        columns = new String[]{SQLiteHelper.ID, SQLiteHelper.EAN, SQLiteHelper.PRODUCT_NAME};
        cursor = db.query(SQLiteHelper.PRODUCTS_LIST,columns,null,null,null,null,null);

        while (cursor.moveToNext()){
            cid = cursor.getInt(cursor.getColumnIndex(SQLiteHelper.ID));
            ean = cursor.getString(cursor.getColumnIndex(SQLiteHelper.EAN));
            product_name = cursor.getString(cursor.getColumnIndex(SQLiteHelper.PRODUCT_NAME));

            String short_product_name = product_name.substring(0,Math.min(product_name.length(), 11));
            buffer.append(cid+ "\t\t\t" + ean + "\t\t\t\t" + short_product_name + "\n");
        }

        db.close();

        return buffer.toString();
    }

    // Returns the name of one product based on its EAN
    public String getProductName(String ean){
        // Open the database
        SQLiteDatabase db = myhelper.getReadableDatabase();

        // Declare a query string
        String query = "SELECT " +  SQLiteHelper.PRODUCT_NAME + " FROM " + SQLiteHelper.PRODUCTS_LIST +
                       " WHERE " + SQLiteHelper.EAN + "='" + ean + "'";

        // Start the cursor with the query declared
        Cursor cursor = db.rawQuery(query, null);

        // Initialize the string of the product name
        String product_name="";

        // Move the cursor the first index (0) of the column of the table
        cursor.moveToFirst();

        // Search the product name
        if (cursor.moveToFirst()) {
            while (!cursor.isAfterLast()) {
                product_name = cursor.getString(0);
                cursor.moveToNext();
            }
        }

        // Close cursor
        cursor.close();

        // Close database
        db.close();

        // Return the name of the product
        return product_name;
    }

    ///////////////////////////////////////
    ////////// LID (LIFTTRUCK ID) ////////
    /////////////////////////////////////

    public void insertLID(String lid) {
        // Open the database
        SQLiteDatabase db = myhelper.getWritableDatabase();

        // Use of ContentValues to insert the records
        ContentValues values = new ContentValues();

        // Insert data in the column of the LIFT TRUCK
        values.put(SQLiteHelper.LIFT_TRUCK, lid);

        // Insert the record
        db.insert(SQLiteHelper.LID, null, values);

        // Close the database
        db.close();
    }

    public String getLIDData(){
        // Open the database
        SQLiteDatabase db = myhelper.getWritableDatabase();

        // Array of string to save the records of each column
        String[] columns;

        // Cursor to go through the table of the internal database
        Cursor cursor;

        // String buffer to save all the data loaded
        StringBuffer buffer = new StringBuffer();

        // String to save the data
        String lift_truck;

        columns = new String[]{SQLiteHelper.LIFT_TRUCK};
        cursor = db.query(SQLiteHelper.LID,columns,null,null,null,null,null);

        while (cursor.moveToNext()){
            lift_truck = cursor.getString(cursor.getColumnIndex(SQLiteHelper.LIFT_TRUCK));
            buffer.append(lift_truck + "\n");
        }

        db.close();

        return buffer.toString();
    }


    // Get the ID of the lift truck that couldn't be sent to the server
    public String getLastLID() {
        // Open the database
        SQLiteDatabase db = myhelper.getReadableDatabase();

        // Make a query to the table of the id's of the lift trucks
        String query = "SELECT * FROM " + SQLiteHelper.LID;

        // Declare a cursor
        Cursor cursor = db.rawQuery(query, null);

        // ID of the lift truck
        String id_lt = "";

        // Move to the last record of the table
        if (cursor.moveToLast()) {
            id_lt = cursor.getString(cursor.getColumnIndex(SQLiteHelper.LIFT_TRUCK));
        }

        // Close cursor
        cursor.close();

        // Close database
        db.close();

        // Return the lift truck ID
        return id_lt;
    }


    ///////////////////////////////////////
    /////////// DELETED PRODUCTS /////////
    /////////////////////////////////////

    // Insert data to DELETED_PRODUCTS
    public void insertDeletedProductsData(String pid, String ean, String lid) {
        // Open the database
        SQLiteDatabase db = myhelper.getWritableDatabase();

        // Use of ContentValues to insert the records
        ContentValues values = new ContentValues();

        // Insert data in each column
        values.put(SQLiteHelper.P_ID, pid);
        values.put(SQLiteHelper.EAN, ean);
        values.put(SQLiteHelper.LIFT_TRUCK, lid);

        // Insert data into the table
        db.insert(SQLiteHelper.DELETED_PRODUCTS, null, values);

        // Close the database
        db.close();
    }

    // Get all data stored in the table
    public String getDeletedProductsData(){
        // Open the database
        SQLiteDatabase db = myhelper.getWritableDatabase();

        // Array of string to save the records of each column
        String[] columns;

        // Cursor to go through the table of the internal database
        Cursor cursor;

        // Column ID
        //int pid;

        // String buffer to save all the data loaded
        StringBuffer buffer = new StringBuffer();

        // String to save the data
        String pid, ean, lid;

        columns = new String[]{SQLiteHelper.P_ID, SQLiteHelper.EAN, SQLiteHelper.LIFT_TRUCK};
        cursor = db.query(SQLiteHelper.DELETED_PRODUCTS,columns,null,null,null,null,null);

        while (cursor.moveToNext()){
            pid = cursor.getString(cursor.getColumnIndex(SQLiteHelper.P_ID));
            ean = cursor.getString(cursor.getColumnIndex(SQLiteHelper.EAN));
            lid = cursor.getString(cursor.getColumnIndex(SQLiteHelper.LIFT_TRUCK));

            buffer.append(pid + "\t\t\t" + ean + "\t\t\t\t" + lid + "\n");
        }

        db.close();

        return buffer.toString();
    }



    // Return data to the table by parsing the JSON
    public void returnDeletedProductsData(String json){
        // Open the database
        SQLiteDatabase db = myhelper.getReadableDatabase();
        try {
            // Transform the response into JSONArray
            JSONArray array = new JSONArray(json);

            // Go through every index of the array
            // for reading the data and save it in the JSONObject
            for (int i = 0; i < array.length(); i++) {

                // Save info of the array in the JSONObject
                JSONObject products = (JSONObject) array.get(i);

                // Obtain the info inside of every
                // attribute inside of the object
                String pid = products.getString(SQLiteHelper.P_ID);
                String ean = products.getString(SQLiteHelper.EAN);
                String lid = products.getString(SQLiteHelper.LIFT_TRUCK);

                //Message.message(context, "ENTRE: " + pid + " " + ean + " " + lid);
                insertDeletedProductsData(pid,ean,lid);
            }
        } catch (JSONException e) {
            e.printStackTrace();
            //Message.message(context, "Error: " + e.getMessage());
        }
    }

    ///////////////////////////////////////
    ////////// PID (PRODUCT ID) //////////
    /////////////////////////////////////

    /*
    public void insertPID(int pid) {
        // Open the database
        SQLiteDatabase db = myhelper.getWritableDatabase();

        // Use of ContentValues to insert the records
        ContentValues values = new ContentValues();

        // Insert data in table of PID's
        values.put(SQLiteHelper.ID, pid);

        // Insert the record
        db.insert(SQLiteHelper.PID, null, values);

        // Close the database
        db.close();
    }

    // Get all data of the table
    public String getPIDData(){
        // Open the database
        SQLiteDatabase db = myhelper.getWritableDatabase();

        // Array of string to save the records of each column
        String[] columns;

        // Cursor to go through the table of the internal database
        Cursor cursor;

        // Product ID
        int pid;

        // String buffer to save all the data loaded
        StringBuffer buffer = new StringBuffer();

        columns = new String[]{SQLiteHelper.ID};
        cursor = db.query(SQLiteHelper.PID,columns,null,null,null,null,null);

        while (cursor.moveToNext()){
            pid = cursor.getInt(cursor.getColumnIndex(SQLiteHelper.ID));
            buffer.append(pid + "\n");
        }

        // Close the database
        db.close();

        // Return the buffer of the data
        return buffer.toString();
    }

    public int getLastPID() {
        // Open the database
        SQLiteDatabase db = myhelper.getReadableDatabase();
        String query = "SELECT * FROM " + SQLiteHelper.PID;
        Cursor cursor = db.rawQuery(query, null);

        int pid = 0;

        if (cursor.moveToLast()) {
            pid = cursor.getInt(0);
        }

        // Close cursor
        cursor.close();

        // Close database
        db.close();

        //Message.message(context, "VALUE PID: " + String.valueOf(pid));

        return pid;
    }*/



}
