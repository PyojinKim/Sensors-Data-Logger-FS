package com.pjinkim.sensors_data_logger_fs;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import android.Manifest;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    // properties
    private final static String LOG_TAG = MainActivity.class.getName();

    private final static int REQUEST_CODE_ANDROID = 1001;
    private static String[] REQUIRED_PERMISSIONS = new String[] {
            Manifest.permission.READ_PHONE_STATE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.ACCESS_WIFI_STATE,
            Manifest.permission.CHANGE_WIFI_STATE,
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.VIBRATE
    };

    private Button mStartServiceButton, mStopServiceButton;
    private TextView mLabelInterfaceTime;
    private TimerStatusReceiver receiver;


    // Android activity lifecycle states
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // initialize screen labels and buttons
        initializeViews();
        receiver = new TimerStatusReceiver();
    }


    @Override
    protected void onResume() {
        super.onResume();

        // request Android permissions
        if (!hasPermissions(this, REQUIRED_PERMISSIONS)) {
            requestPermissions(REQUIRED_PERMISSIONS, REQUEST_CODE_ANDROID);
        }

        // handle time status manager
        LocalBroadcastManager.getInstance(this).registerReceiver(receiver, new IntentFilter(ForegroundService.TIME_INFO));
    }


    @Override
    protected void onPause() {
        super.onPause();
    }


    @Override
    protected void onStop() {
        LocalBroadcastManager.getInstance(this).unregisterReceiver(receiver);
        super.onStop();
    }


    // methods
    public void startService(View view) {
        Intent serviceIntent = new Intent(this, ForegroundService.class);
        serviceIntent.setAction(ForegroundService.ACTION_START_FOREGROUND_SERVICE);
        ContextCompat.startForegroundService(this, serviceIntent);
    }


    public void stopService(View view) {
        Intent serviceIntent = new Intent(this, ForegroundService.class);
        serviceIntent.setAction(ForegroundService.ACTION_STOP_FOREGROUND_SERVICE);
        startService(serviceIntent);
    }


    private static boolean hasPermissions(Context context, String... permissions) {

        // check Android hardware permissions
        for (String permission : permissions) {
            if (ContextCompat.checkSelfPermission(context, permission) != PackageManager.PERMISSION_GRANTED) {
                return false;
            }
        }
        return true;
    }


    private void initializeViews() {

        mStartServiceButton = (Button) findViewById(R.id.button_start_service);
        mStopServiceButton = (Button) findViewById(R.id.button_stop_service);
        mLabelInterfaceTime = (TextView) findViewById(R.id.label_interface_time);
    }


    // definition of 'TimerStatusReceiver' class
    private class TimerStatusReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent != null && intent.getAction().equals(ForegroundService.TIME_INFO)) {
                if (intent.hasExtra("VALUE")) {
                    mLabelInterfaceTime.setText(intent.getStringExtra("VALUE"));
                }
            }
        }
    }
}
