package mx.itesm.csf.ge_scanner;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import java.util.Timer;
import java.util.TimerTask;

public class SplashTwo extends AppCompatActivity {
    // Duration of the splash_one screen
    private static final long SPLASH_SCREEN_DELAY = 1000;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash_two);

        TimerTask task = new TimerTask() {
            @Override
            public void run() {
                // Start activity Tabs
                Intent intent = new Intent(SplashTwo.this, Tabs.class);
                startActivity(intent);

                // Close the activity
                finish();
            }
        };

        // Simulate a long loading process on application startup.
        Timer timer = new Timer();
        timer.schedule(task, SPLASH_SCREEN_DELAY);
    }
}
