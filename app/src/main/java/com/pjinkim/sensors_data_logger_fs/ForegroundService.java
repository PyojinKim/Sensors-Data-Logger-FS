package com.pjinkim.sensors_data_logger_fs;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import java.io.IOException;
import java.util.Locale;
import java.util.concurrent.atomic.AtomicBoolean;

public class ForegroundService extends Service {

    // properties
    private static final String LOG_TAG = ForegroundService.class.getName();
    public static final String CHANNEL_ID = "ForegroundServiceChannel";

    public static final String ACTION_START_FOREGROUND_SERVICE = "ACTION_START_FOREGROUND_SERVICE";
    public static final String ACTION_STOP_FOREGROUND_SERVICE = "ACTION_STOP_FOREGROUND_SERVICE";
    public static final String ACTION_START_RECORDING = "ACTION_START_RECORDING";
    public static final String ACTION_STOP_RECORDING = "ACTION_STOP_RECORDING";

    private IMUConfig mConfig = new IMUConfig();
    private IMUSession mIMUSession;
    private WifiSession mWifiSession;
    private BatterySession mBatterySession;

    private Handler mHandler = new Handler();
    private AtomicBoolean mIsRecording = new AtomicBoolean(false);


    // Android service lifecycle states
    @Override
    public void onCreate() {
        super.onCreate();

        // initialize each sensor session
        mIMUSession = new IMUSession(this);
        mWifiSession = new WifiSession(this);
        mBatterySession = new BatterySession(this);
    }


    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        // execute each action with intent input
        if (intent != null) {

            String action = intent.getAction();
            switch (action) {
                case ACTION_START_FOREGROUND_SERVICE:
                    startForegroundService();
                    Toast.makeText(this, "Foreground service now starts!", Toast.LENGTH_LONG).show();
                    break;

                case ACTION_STOP_FOREGROUND_SERVICE:
                    stopForegroundService();
                    Toast.makeText(this, "Foreground service stops!", Toast.LENGTH_LONG).show();
                    break;

                case ACTION_START_RECORDING:
                    startRecording();
                    Toast.makeText(this, "You click Record button!", Toast.LENGTH_LONG).show();
                    break;

                case ACTION_STOP_RECORDING:
                    stopRecording();
                    Toast.makeText(this, "You click Stop button!", Toast.LENGTH_LONG).show();
                    break;
            }
        }
        return super.onStartCommand(intent, flags, startId);
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
        // TODO(pjinkim): Return the communication channel to the service.
        throw new UnsupportedOperationException("Not yet implemented");
    }


    // methods
    private void startForegroundService() {

        // create notification default intent and builder
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, CHANNEL_ID);

        // define notification style and icon
        builder.setSmallIcon(R.drawable.app_small_icon);
        Bitmap largeIconBitmap = BitmapFactory.decodeResource(getResources(), R.drawable.app_large_icon);
        builder.setLargeIcon(largeIconBitmap);
        builder.setWhen(System.currentTimeMillis());
        builder.setContentTitle("Sensors Data Logger in FS");
        builder.setContentText("Click RECORD button to save IMU/WiFi data.");
        builder.setDefaults(Notification.DEFAULT_ALL);
        builder.setPriority(NotificationCompat.PRIORITY_MAX);
        builder.setFullScreenIntent(pendingIntent, true);

        // add Record button intent in notification
        Intent recordIntent = new Intent(this, ForegroundService.class);
        recordIntent.setAction(ACTION_START_RECORDING);
        PendingIntent pendingRecordIntent = PendingIntent.getService(this, 0, recordIntent, 0);
        NotificationCompat.Action recordAction = new NotificationCompat.Action(android.R.drawable.ic_media_play, "RECORD", pendingRecordIntent);
        builder.addAction(recordAction);

        // add Stop button intent in notification
        Intent stopIntent = new Intent(this, ForegroundService.class);
        stopIntent.setAction(ACTION_STOP_RECORDING);
        PendingIntent pendingStopIntent = PendingIntent.getService(this, 0, stopIntent, 0);
        NotificationCompat.Action stopAction = new NotificationCompat.Action(android.R.drawable.ic_media_pause, "STOP", pendingStopIntent);
        builder.addAction(stopAction);

        // build the notification
        createNotificationChannel();
        Notification notification = builder.build();


        // start foreground service
        startForeground(1, notification);
    }


    private void stopForegroundService() {

        // stop foreground service and remove the notification
        stopForeground(true);

        // stop the foreground service
        stopSelf();
    }


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
        mWifiSession.startSession(outputFolder);
        mBatterySession.startSession(outputFolder);
        mIsRecording.set(true);
    }


    protected void stopRecording() {
        mHandler.post(new Runnable() {
            @Override
            public void run() {

                // stop each session
                mIMUSession.stopSession();
                mWifiSession.stopSession();
                mBatterySession.stopSession();
                mIsRecording.set(false);
            }
        });
    }


    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel serviceChannel = new NotificationChannel(CHANNEL_ID, "Foreground Service Channel", NotificationManager.IMPORTANCE_HIGH);
            serviceChannel.setDescription("Foreground Service for Sensors");
            serviceChannel.enableLights(true);
            serviceChannel.setLightColor(Color.GREEN);
            serviceChannel.setShowBadge(true);
            serviceChannel.enableVibration(true);
            serviceChannel.setVibrationPattern(new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400});

            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(serviceChannel);
        }
    }


    private String interfaceIntTime(final int second) {

        // check second input
        if (second < 0) {
            Log.e(LOG_TAG, "interfaceIntTime: Second cannot be negative.");
            return null;
        }

        // extract hour, minute, second information from second
        int input = second;
        int hours = input / 3600;
        input = input % 3600;
        int mins = input / 60;
        int secs = input % 60;

        // return interface int time
        return String.format(Locale.US, "%02d:%02d:%02d", hours, mins, secs);
    }
}
