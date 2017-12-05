package mx.itesm.csf.ge_scanner;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import java.util.Objects;

/**
 * Created by danflovier on 10/09/2017.
 */

public class Login2 extends AppCompatActivity {
    private String pass = "currentconfig";

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.login2);

        final EditText form = findViewById(R.id.editText);
        final Button button = findViewById(R.id.button1);

        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Intent intent = new Intent(Login2.this, ZonesListActivity.class);
                //startActivity(intent);
                if (Objects.equals(form.getText().toString(), pass.toString())) {
                    Intent intent = new Intent(Login2.this, ZonesListActivity.class);
                    startActivity(intent);
                }
                else
                {
                    Toast.makeText(Login2.this, "Wrong Password!", Toast.LENGTH_LONG).show();
                }
            }
        });

    }

    @Override
    public void onStop(){
        super.onStop();
        this.finish();
    }
}


