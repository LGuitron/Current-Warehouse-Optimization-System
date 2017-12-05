package mx.itesm.csf.ge_scanner;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.ProgressBar;

/**
 * Created by danflovier on 10/09/2017.
 */

public class SplashOne extends AppCompatActivity {

    // Session Manager Class
    LoginPreferences session;

    // Progressbar
    ProgressBar mProgress;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash_one);

        // Session class instance
        session = new LoginPreferences(getApplicationContext());
        mProgress = (ProgressBar) findViewById(R.id.progressbar);

        // Show splash_one screen and login session if the user is not logged in
        if (session.isLoggedIn()){
            startTabbedActivity();
        }else {
            startSplash();
        }
    }

    public void startSplash() {
        // Start a thread for set the progressbar value
        new Thread(new Runnable() {
            public void run() {
                for (int progress = 0; progress <= 100; progress++) {
                    try {
                        // Set the velocity of the value progress
                        Thread.sleep(30);
                        mProgress.setProgress(progress);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                // Start next activity
                startLogin();
                finish();
            }
        }).start();
    }

    // Method to start Tabs class
    public void startTabbedActivity(){
        Intent intent = new Intent(SplashOne.this, SplashTwo.class);
        startActivity(intent);
        finish();
    }

    // Method to start Login class
    public void startLogin(){
        Intent intent = new Intent(SplashOne.this, Login.class);
        startActivity(intent);
        finish();
    }
}
