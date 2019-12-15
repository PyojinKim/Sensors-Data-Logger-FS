package com.pjinkim.sensors_data_logger_fs;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.PowerManager;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.pjinkim.sensors_data_logger_fs.fio.OutputDirectoryManager;
import com.pjinkim.sensors_data_logger_fs.imu.IMUConfig;
import com.pjinkim.sensors_data_logger_fs.imu.IMUSession;
import com.pjinkim.sensors_data_logger_fs.location.FLPSession;
import com.pjinkim.sensors_data_logger_fs.wifi.WifiSession;

import java.io.IOException;
import java.util.Locale;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.atomic.AtomicBoolean;

public class ForegroundService extends Service {

    // properties
    private static final String LOG_TAG = ForegroundService.class.getName();
    public static final String MOTION_INFO = "MotionInfo";
    public static final String TIME_INFO = "TimeInfo";
    public static final String CHANNEL_ID = "ForegroundServiceChannel";

    public static final String ACTION_START_FOREGROUND_SERVICE = "ACTION_START_FOREGROUND_SERVICE";
    public static final String ACTION_STOP_FOREGROUND_SERVICE = "ACTION_STOP_FOREGROUND_SERVICE";

    private IMUConfig mConfig = new IMUConfig();
    private IMUSession mIMUSession;
    private WifiSession mWifiSession;
    private BatterySession mBatterySession;
    private FLPSession mFLPSession;

    private Handler mHandler = new Handler();
    private AtomicBoolean mIsRecording = new AtomicBoolean(false);
    private PowerManager.WakeLock mWakeLock;

    private Timer mInterfaceTimer = new Timer();
    private int mSecondCounter = 0;

    private Timer mMotionStatusTimer = new Timer();
    private String mMotionStatus = "";


    // Android service lifecycle states
    @Override
    public void onCreate() {
        super.onCreate();

        // initialize each sensor session
        mIMUSession = new IMUSession(this);
        mWifiSession = new WifiSession(this);
        mBatterySession = new BatterySession(this);
        mFLPSession = new FLPSession(this);


        // battery power setting
        PowerManager powerManager = (PowerManager) getSystemService(Context.POWER_SERVICE);
        mWakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "sensors_data_logger:wakelocktag");
        mWakeLock.acquire();


        // start motion status on screen
        mMotionStatus = "Moving";
        mMotionStatusTimer.schedule(new TimerTask() {
            @Override
            public void run() {

                // check the phone is static or not
                if (mIMUSession.isMotionStatic()) {
                    mMotionStatus = "Static";
                } else {
                    mMotionStatus = "Moving";
                }

                // broadcast the current motion status
                Intent motionInfoIntent = new Intent(MOTION_INFO);
                motionInfoIntent.putExtra("VALUE", mMotionStatus);
                LocalBroadcastManager.getInstance(ForegroundService.this).sendBroadcast(motionInfoIntent);
            }
        }, 0, 500);
    }


    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        // execute each action with intent input
        if (intent != null) {

            String action = intent.getAction();
            switch (action) {
                case ACTION_START_FOREGROUND_SERVICE:

                    // start foreground service (FS)
                    startForegroundService();
                    Toast.makeText(this, "Foreground service now starts!", Toast.LENGTH_SHORT).show();

                    // start recording various sensor measurements
                    startRecording();
                    Toast.makeText(this, "You click Record button!", Toast.LENGTH_SHORT).show();
                    break;

                case ACTION_STOP_FOREGROUND_SERVICE:

                    // stop & save the recorded text files
                    stopRecording();
                    Toast.makeText(this, "You click Stop button!", Toast.LENGTH_SHORT).show();

                    // stop foreground service (FS)
                    stopForegroundService();
                    Toast.makeText(this, "Foreground service stops!", Toast.LENGTH_SHORT).show();
                    break;
            }
        }
        return super.onStartCommand(intent, flags, startId);
    }


    @Override
    public void onDestroy() {

        // notify IMU recording foreground service done
        Toast.makeText(this, "Service Done!", Toast.LENGTH_SHORT).show();

        // release and unregister sensors
        if (mWakeLock.isHeld()) {
            mWakeLock.release();
        }
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
        builder.setContentText("Now, recording IMU/WiFi data for WiFi SfM.");
        builder.setDefaults(Notification.DEFAULT_ALL);
        builder.setPriority(NotificationCompat.PRIORITY_MAX);
        builder.setFullScreenIntent(pendingIntent, true);

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
        mFLPSession.startSession(outputFolder);
        mIsRecording.set(true);

        // start interface timer on screen
        mSecondCounter = 0;
        mInterfaceTimer.schedule(new TimerTask() {
            @Override
            public void run() {
                mSecondCounter += 1;
                Intent timerInfoIntent = new Intent(TIME_INFO);
                timerInfoIntent.putExtra("VALUE", interfaceIntTime(mSecondCounter));
                LocalBroadcastManager.getInstance(ForegroundService.this).sendBroadcast(timerInfoIntent);
            }
        }, 0, 1000);
    }


    protected void stopRecording() {

        // stop all session
        mHandler.post(new Runnable() {
            @Override
            public void run() {

                // stop each session
                mIMUSession.stopSession();
                mWifiSession.stopSession();
                mBatterySession.stopSession();
                mFLPSession.stopSession();
                mIsRecording.set(false);
            }
        });

        // stop interface timer on screen
        mInterfaceTimer.cancel();
        Intent timerInfoIntent = new Intent(TIME_INFO);
        timerInfoIntent.putExtra("VALUE", "Completed");
        LocalBroadcastManager.getInstance(ForegroundService.this).sendBroadcast(timerInfoIntent);

        // stop motion status on screen
        mMotionStatusTimer.cancel();
        Intent motionInfoIntent = new Intent(MOTION_INFO);
        motionInfoIntent.putExtra("VALUE", "Completed");
        LocalBroadcastManager.getInstance(ForegroundService.this).sendBroadcast(motionInfoIntent);
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
