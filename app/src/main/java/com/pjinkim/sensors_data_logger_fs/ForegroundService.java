package com.pjinkim.sensors_data_logger_fs;

import android.Manifest;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.SystemClock;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;

import java.io.IOException;
import java.util.Timer;
import java.util.concurrent.atomic.AtomicBoolean;

public class ForegroundService extends Service {

    // properties
    private static final String LOG_TAG = ForegroundService.class.getName();
    public static final String CHANNEL_ID = "ForegroundServiceChannel";

    private IMUConfig mConfig = new IMUConfig();
    private IMUSession mIMUSession;
    private WifiSession mWifiSession;
    private BatterySession mBatterySession;

    private Handler mHandler = new Handler();
    private AtomicBoolean mIsRecording = new AtomicBoolean(false);

    private Timer mInterfaceTimer = new Timer();
    private int mSecondCounter = 0;


    // Android service lifecycle states
    @Override
    public void onCreate() {
        super.onCreate();

        // initialize each sensor session
        mIMUSession = new IMUSession(this);
        // mWifiSession = new WifiSession(this);
        // mBatterySession = new BatterySession(this);
    }


    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        // notify IMU recording foreground service starts
        Toast.makeText(this, "Service Starts!", Toast.LENGTH_SHORT).show();

        // status bar notification configuration
        String input = intent.getStringExtra("inputExtra");
        createNotificationChannel();
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);

        Notification notification = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Sensors Data Logger in Foreground Service")
                .setContentText(input)
                .setSmallIcon(R.drawable.gruvi_logo)
                .setContentIntent(pendingIntent)
                .build();

        startForeground(1, notification);

        // do heavy work on a background thread
        startRecording();
        Log.d(LOG_TAG, "onStartCommand: startRecording()");



        SystemClock.sleep(10000);



        stopRecording();
        Log.d(LOG_TAG, "onStartCommand: stopRecording()");
        // stopSelf();

        return START_NOT_STICKY;
    }


    @Override
    public void onDestroy() {

        // notify IMU recording foreground service done
        Toast.makeText(this, "Service Done!", Toast.LENGTH_SHORT).show();
        mIMUSession.unregisterSensors();
        super.onDestroy();
    }


    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }


    // methods
    private void startRecording() {

        // output directory for text files
        String outputFolder = null;
        try {
            OutputDirectoryManager folder = new OutputDirectoryManager(mConfig.getFolderPrefix(), mConfig.getSuffix());
            outputFolder = folder.getOutputDirectory();
            mConfig.setOutputFolder(outputFolder);
        } catch (IOException e) {
            Log.d(LOG_TAG, "startRecording: Cannot create output folder.");
            e.printStackTrace();
        }

        // start each session
        mIMUSession.startSession(outputFolder);
        // mWifiSession.startSession(outputFolder);
        // mBatterySession.startSession(outputFolder);
        mIsRecording.set(true);
    }


    protected void stopRecording() {
        mHandler.post(new Runnable() {
            @Override
            public void run() {

                // stop each session
                mIMUSession.stopSession();
                // mWifiSession.stopSession();
                // mBatterySession.stopSession();
                mIsRecording.set(false);
            }
        });
    }


    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel serviceChannel = new NotificationChannel(
                    CHANNEL_ID,
                    "Foreground Service Channel",
                    NotificationManager.IMPORTANCE_DEFAULT
            );

            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(serviceChannel);
        }
    }
}
