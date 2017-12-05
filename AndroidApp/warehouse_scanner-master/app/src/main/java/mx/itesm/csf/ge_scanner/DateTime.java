package mx.itesm.csf.ge_scanner;

import android.annotation.SuppressLint;
import android.util.Log;

import java.text.SimpleDateFormat;
import java.util.Calendar;

/**
 * Created by danflovier on 07/11/2017.
 */

public class DateTime {
    public static String getDateandTime() {

        // Object of calendar
        Calendar c = Calendar.getInstance();

        // Specify the date format
        @SuppressLint("SimpleDateFormat")
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        // Convert time to string
        String date_time = df.format(c.getTime());
        Log.e("DateTime TAG: ", "time date " + date_time);

        // Return the string of the datetime
        return date_time;
    }
}
