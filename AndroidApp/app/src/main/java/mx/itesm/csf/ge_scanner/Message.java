package mx.itesm.csf.ge_scanner;

import android.content.Context;
import android.widget.Toast;

/**
 * Created by danflovier on 25/09/2017.
 */

public class Message {

    // Method to make the use of the Toast easier
    public static void message(Context context, String message) {
        Toast.makeText(context, message, Toast.LENGTH_LONG).show();
    }
}