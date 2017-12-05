package mx.itesm.csf.ge_scanner;

/**
 * Created by danflovier on 16/11/2017.
 */

import java.util.UUID;

public class RandomIDGenerator {

    // Generate a random string with the UUID format
    // to use it as a product ID (PID)
    public static String generateRandomID() {
        String uuid = UUID.randomUUID().toString();
        return uuid;
    }
}
