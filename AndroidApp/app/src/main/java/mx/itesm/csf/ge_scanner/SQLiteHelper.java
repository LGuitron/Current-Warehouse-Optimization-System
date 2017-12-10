package mx.itesm.csf.ge_scanner;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

/*
Resource:
http://abhiandroid.com/database/sqlite
https://thebhwgroup.com/blog/how-android-sqlite-onupgrade
https://medium.com/@ssaurel/learn-to-save-data-with-sqlite-on-android-b11a8f7718d3
*/

/**
 * Created by danflovier on 25/09/2017.
 */

public class SQLiteHelper extends SQLiteOpenHelper {

    // Name of the database
    protected static final String DATABASE_NAME = "warehouse_db";

    // Database Version
    private static final int DATABASE_VERSION = 1;

    // Name of the tables
    protected static final String UPLOAD_PENDING = "upload_pending";
    protected static final String PRODUCTS_LIST = "products_list";
    protected static final String DELETED_PRODUCTS = "deleted_productst";
    protected static final String PID = "pid";
    protected static final String LID = "lid";

    // Columns of the tables
    protected static final String ID = "id";
    protected static final String P_ID = "pid";
    protected static final String EAN = "ean";
    protected static final String PRODUCT_NAME = "product_name";
    protected static final String LIFT_TRUCK = "mnt";
    protected static final String STATUS = "status";
    protected static final String SECTION = "sec";
    protected static final String RACK_FLOOR = "floor";
    protected static final String CREATED_AT = "time";

    // Create table for Upload Pending Products
    private static final String CREATE_TABLE_ONE = "CREATE TABLE " + UPLOAD_PENDING + " ("
                    + ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                    + P_ID + " VARCHAR(36), "
                    + EAN + " VARCHAR(13), "
                    + LIFT_TRUCK + " VARCHAR(2), "
                    + STATUS + " VARCHAR(1), "
                    + SECTION + " VARCHAR(1), "
                    + RACK_FLOOR + " VARCHAR(2), "
                    + CREATED_AT + " DATETIME DEFAULT (datetime('now','localtime')));";

    // Create table for Products List
    private static final String CREATE_TABLE_TWO = "CREATE TABLE " + PRODUCTS_LIST + " ("
                    + ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                    + EAN + " VARCHAR(13), "
                    + PRODUCT_NAME + " VARCHAR(50));";

    // Create table for the LTD's
    private static final String CREATE_TABLE_THREE = "CREATE TABLE " + LID + " (" + LIFT_TRUCK + " VARCHAR(2));";

    // Create table for the deleted products from the list
    private static final String CREATE_TABLE_FOUR = "CREATE TABLE " + DELETED_PRODUCTS + " ("
            + P_ID + " VARCHAR(36), "
            + EAN + " VARCHAR(13), "
            + LIFT_TRUCK + " VARCHAR(2));";


    // Drop tables
    private static final String DROP_TABLE_ONE = "DROP TABLE IF EXISTS " + UPLOAD_PENDING;
    private static final String DROP_TABLE_TWO = "DROP TABLE IF EXISTS " + PRODUCTS_LIST;
    private static final String DROP_TABLE_THREE = "DROP TABLE IF EXISTS " + LID;
    private static final String DROP_TABLE_FOUR = "DROP TABLE IF EXISTS " + DELETED_PRODUCTS;

    private Context context;

    SQLiteHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        this.context = context;
    }

    // Create tables
    @Override
    public void onCreate(SQLiteDatabase db) {
        try {
            db.execSQL(CREATE_TABLE_ONE);
            db.execSQL(CREATE_TABLE_TWO);
            db.execSQL(CREATE_TABLE_THREE);
            db.execSQL(CREATE_TABLE_FOUR);
        } catch (Exception e) {
            Message.message(context,""+e);
        }
    }

    // Upgrade the database depending of the versions
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        try {
            Message.message(context,"OnUpgrade");
            db.execSQL(DROP_TABLE_ONE);
            db.execSQL(DROP_TABLE_TWO);
            db.execSQL(DROP_TABLE_THREE);
            db.execSQL(DROP_TABLE_FOUR);
            onCreate(db);
        }catch (Exception e) {
            Message.message(context,"" + e);
        }
    }
}
