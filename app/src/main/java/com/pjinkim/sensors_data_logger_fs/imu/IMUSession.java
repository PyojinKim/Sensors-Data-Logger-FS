package com.pjinkim.sensors_data_logger_fs.imu;

import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.net.Uri;
import android.os.Environment;
import android.util.Log;

import com.pjinkim.sensors_data_logger_fs.ForegroundService;
import com.pjinkim.sensors_data_logger_fs.fio.FileStreamer;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;
import java.security.KeyException;
import java.util.HashMap;
import java.util.concurrent.atomic.AtomicBoolean;
import java.lang.Math;

public class IMUSession implements SensorEventListener {

    // properties
    private final static String LOG_TAG = IMUSession.class.getName();

    private ForegroundService mContext;
    private SensorManager mSensorManager;
    private HashMap<String, Sensor> mSensors = new HashMap<>();
    private float mInitialStepCount = -1;
    private FileStreamer mFileStreamer = null;

    private AtomicBoolean mIsRecording = new AtomicBoolean(false);
    private AtomicBoolean mIsWritingFile = new AtomicBoolean(false);

    private float[] mAcceBias = new float[3];
    private float[] mGyroBias = new float[3];
    private float[] mMagnetBias = new float[3];

    private float[] mAccelMeasure = new float[3];
    private float[] mLinearAccelMeasure = new float[3];
    private float[] mGravityMeasure = new float[3];

    private double mMotionStaticPreviousTimeStamp = 0.0;
    private double mMotionStaticAccumulatedTime = 0.0;


    // constructor
    public IMUSession(ForegroundService context) {

        // initialize object and sensor manager
        mContext = context;
        mSensorManager = (SensorManager) mContext.getSystemService(Context.SENSOR_SERVICE);

        // setup and register various sensors
        mSensors.put("acce", mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER));
        mSensors.put("acce_uncalib", mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER_UNCALIBRATED));
        mSensors.put("gyro", mSensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE));
        mSensors.put("gyro_uncalib", mSensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE_UNCALIBRATED));
        mSensors.put("linacce", mSensorManager.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION));
        mSensors.put("gravity", mSensorManager.getDefaultSensor(Sensor.TYPE_GRAVITY));
        mSensors.put("magnet", mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD));
        mSensors.put("magnet_uncalib", mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD_UNCALIBRATED));
        mSensors.put("rv", mSensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR));
        mSensors.put("game_rv", mSensorManager.getDefaultSensor(Sensor.TYPE_GAME_ROTATION_VECTOR));
        mSensors.put("magnetic_rv", mSensorManager.getDefaultSensor(Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR));
        mSensors.put("step", mSensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER));
        mSensors.put("pressure", mSensorManager.getDefaultSensor(Sensor.TYPE_PRESSURE));
        registerSensors();
    }


    // methods
    public void registerSensors() {
        for (Sensor eachSensor : mSensors.values()) {
            mSensorManager.registerListener(this, eachSensor, 10000);
        }
    }


    public void unregisterSensors() {
        for (Sensor eachSensor : mSensors.values()) {
            mSensorManager.unregisterListener(this, eachSensor);
        }
    }


    public void startSession(String streamFolder) {

        // initialize text file streams
        if (streamFolder != null) {
            mFileStreamer = new FileStreamer(mContext, streamFolder);
            try {
                mFileStreamer.addFile("acce", "acce.txt");
                mFileStreamer.addFile("acce_uncalib", "acce_uncalib.txt");
                mFileStreamer.addFile("gyro", "gyro.txt");
                mFileStreamer.addFile("gyro_uncalib", "gyro_uncalib.txt");
                mFileStreamer.addFile("linacce", "linacce.txt");
                mFileStreamer.addFile("gravity", "gravity.txt");
                mFileStreamer.addFile("magnet", "magnet.txt");
                mFileStreamer.addFile("magnet_uncalib", "magnet_uncalib.txt");
                mFileStreamer.addFile("rv", "rv.txt");
                mFileStreamer.addFile("game_rv", "game_rv.txt");
                mFileStreamer.addFile("magnetic_rv", "magnetic_rv.txt");
                mFileStreamer.addFile("step", "step.txt");
                mFileStreamer.addFile("pressure", "pressure.txt");
                mFileStreamer.addFile("acce_bias", "acce_bias.txt");
                mFileStreamer.addFile("gyro_bias", "gyro_bias.txt");
                mFileStreamer.addFile("magnet_bias", "magnet_bias.txt");
                mIsWritingFile.set(true);
            } catch (IOException e) {
                Log.d(LOG_TAG, "startSession: Error occurs when creating output IMU files.");
                e.printStackTrace();
            }
        }
        mIsRecording.set(true);
    }


    public void stopSession() {

        mIsRecording.set(false);
        if (mIsWritingFile.get()) {

            // close all recorded text files
            try {
                mFileStreamer.endFiles();
            } catch (IOException e) {
                Log.d(LOG_TAG, "stopSession: Error occurs when finishing IMU text files.");
                e.printStackTrace();
            }

            // copy accelerometer calibration file to the streaming folder
            try {
                File acceCalibFile = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS) + "/acce_calib.txt");
                File outAcceCalibFile = new File(mFileStreamer.getOutputFolder() + "/acce_calib.txt");
                if (acceCalibFile.exists()) {
                    FileInputStream istr = new FileInputStream(acceCalibFile);
                    FileOutputStream ostr = new FileOutputStream(outAcceCalibFile);
                    FileChannel ichn = istr.getChannel();
                    FileChannel ochn = ostr.getChannel();
                    ichn.transferTo(0, ichn.size(), ochn);
                    istr.close();
                    ostr.close();

                    Intent scanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
                    scanIntent.setData(Uri.fromFile(outAcceCalibFile));
                    mContext.sendBroadcast(scanIntent);
                }
            } catch (IOException e) {
                Log.d(LOG_TAG, "stopSession: Error occurs when copying accelerometer calibration text files.");
                e.printStackTrace();
            }

            // reset some properties
            mIsWritingFile.set(false);
            mFileStreamer = null;
        }
        mInitialStepCount = -1;
    }


    @Override
    public void onSensorChanged(final SensorEvent sensorEvent) {

        // set some variables
        float[] values = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f};
        boolean isFileSaved = (mIsRecording.get() && mIsWritingFile.get());

        // update each sensor measurements
        long timestamp = sensorEvent.timestamp;
        Sensor eachSensor = sensorEvent.sensor;
        try {
            switch (eachSensor.getType()) {
                case Sensor.TYPE_ACCELEROMETER:
                    mAccelMeasure[0] = sensorEvent.values[0];
                    mAccelMeasure[1] = sensorEvent.values[1];
                    mAccelMeasure[2] = sensorEvent.values[2];
                    if (isFileSaved) {
                        mFileStreamer.addRecord(timestamp, "acce", 3, sensorEvent.values);
                    }
                    break;

                case Sensor.TYPE_ACCELEROMETER_UNCALIBRATED:
                    mAcceBias[0] = sensorEvent.values[3];
                    mAcceBias[1] = sensorEvent.values[4];
                    mAcceBias[2] = sensorEvent.values[5];
                    if (isFileSaved) {
                        mFileStreamer.addRecord(timestamp, "acce_uncalib", 3, sensorEvent.values);
                        mFileStreamer.addRecord(timestamp, "acce_bias", 3, mAcceBias);
                    }
                    break;

                case Sensor.TYPE_GYROSCOPE:
                    if (isFileSaved) {
                        mFileStreamer.addRecord(timestamp, "gyro", 3, sensorEvent.values);
                    }
                    break;

                case Sensor.TYPE_GYROSCOPE_UNCALIBRATED:
                    mGyroBias[0] = sensorEvent.values[3];
                    mGyroBias[1] = sensorEvent.values[4];
                    mGyroBias[2] = sensorEvent.values[5];
                    if (isFileSaved) {
                        mFileStreamer.addRecord(timestamp, "gyro_uncalib", 3, sensorEvent.values);
                        mFileStreamer.addRecord(timestamp, "gyro_bias", 3, mGyroBias);
                    }
                    break;

                case Sensor.TYPE_LINEAR_ACCELERATION:
                    mLinearAccelMeasure[0] = sensorEvent.values[0];
                    mLinearAccelMeasure[1] = sensorEvent.values[1];
                    mLinearAccelMeasure[2] = sensorEvent.values[2];
                    if (isFileSaved) {
                        mFileStreamer.addRecord(timestamp, "linacce", 3, sensorEvent.values);
                    }
                    break;

                case Sensor.TYPE_GRAVITY:
                    mGravityMeasure[0] = sensorEvent.values[0];
                    mGravityMeasure[1] = sensorEvent.values[1];
                    mGravityMeasure[2] = sensorEvent.values[2];
                    if (isFileSaved) {
                        mFileStreamer.addRecord(timestamp, "gravity", 3, sensorEvent.values);
                    }
                    break;

                case Sensor.TYPE_MAGNETIC_FIELD:
                    if (isFileSaved) {
                        mFileStreamer.addRecord(timestamp, "magnet", 3, sensorEvent.values);
                    }
                    break;

                case Sensor.TYPE_MAGNETIC_FIELD_UNCALIBRATED:
                    mMagnetBias[0] = sensorEvent.values[3];
                    mMagnetBias[1] = sensorEvent.values[4];
                    mMagnetBias[2] = sensorEvent.values[5];
                    if (isFileSaved) {
                        mFileStreamer.addRecord(timestamp, "magnet_uncalib", 3, sensorEvent.values);
                        mFileStreamer.addRecord(timestamp, "magnet_bias", 3, mMagnetBias);
                    }
                    break;

                case Sensor.TYPE_ROTATION_VECTOR:
                    if (isFileSaved) {
                        mFileStreamer.addRecord(timestamp, "rv", 4, sensorEvent.values);
                    }
                    break;

                case Sensor.TYPE_GAME_ROTATION_VECTOR:
                    if (isFileSaved) {
                        mFileStreamer.addRecord(timestamp, "game_rv", 4, sensorEvent.values);
                    }
                    break;

                case Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR:
                    if (isFileSaved) {
                        mFileStreamer.addRecord(timestamp, "magnetic_rv", 4, sensorEvent.values);
                    }
                    break;

                case Sensor.TYPE_STEP_COUNTER:
                    if (mInitialStepCount < 0) {
                        mInitialStepCount = sensorEvent.values[0] - 1;
                    }
                    values[0] = sensorEvent.values[0] - mInitialStepCount;
                    if (isFileSaved) {
                        mFileStreamer.addRecord(timestamp, "step", 1, values);
                    }
                    break;

                case Sensor.TYPE_PRESSURE:
                    if (isFileSaved) {
                        mFileStreamer.addRecord(timestamp, "pressure", 1, sensorEvent.values);
                    }
                    break;
            }
        } catch (IOException | KeyException e) {
            Log.d(LOG_TAG, "onSensorChanged: Something is wrong.");
            e.printStackTrace();
        }
    }


    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }


    public boolean isMotionStatic() {

        // default variable setting
        boolean motionIsStatic = false;
        final double magnitudeThreshold = 0.1;  // m/s^2
        final double directionThreshold = 1.0;  // degrees
        final double durationThreshold = 5.0;   // second


        // compute the magnitude of each acceleration vector
        double accelMagnitude = Math.sqrt(mAccelMeasure[0] * mAccelMeasure[0] + mAccelMeasure[1] * mAccelMeasure[1] + mAccelMeasure[2] * mAccelMeasure[2]);
        double linearAccelMagnitude = Math.sqrt(mLinearAccelMeasure[0] * mLinearAccelMeasure[0] + mLinearAccelMeasure[1] * mLinearAccelMeasure[1] + mLinearAccelMeasure[2] * mLinearAccelMeasure[2]);
        double gravityMagnitude = Math.sqrt(mGravityMeasure[0] * mGravityMeasure[0] + mGravityMeasure[1] * mGravityMeasure[1] + mGravityMeasure[2] * mGravityMeasure[2]);


        // compute the angle between the acceleration and gravity vector
        double angleDeviation = Math.acos((mAccelMeasure[0] * mGravityMeasure[0] + mAccelMeasure[1] * mGravityMeasure[1] + mAccelMeasure[2] * mGravityMeasure[2]) / (accelMagnitude * gravityMagnitude));


        // check motion is static or not
        final double currentTimeStamp = ((double) System.currentTimeMillis()) / 1000;  // milli sec to sec
        final double isMotionStaticTimeDelta = (currentTimeStamp - mMotionStaticPreviousTimeStamp);
        mMotionStaticPreviousTimeStamp = currentTimeStamp;
        final boolean isMotionTemporarilyStatic = ((linearAccelMagnitude < magnitudeThreshold) && (rad2deg(angleDeviation) <= directionThreshold));
        if (isMotionTemporarilyStatic) {

            // accumulate motion static duration time
            mMotionStaticAccumulatedTime += isMotionStaticTimeDelta;
            if (mMotionStaticAccumulatedTime > durationThreshold) {
                motionIsStatic = true;
            }
        } else {

            // reset motion static accumulated time
            mMotionStaticAccumulatedTime = 0.0;
            motionIsStatic = false;
        }
        return motionIsStatic;
    }


    private double deg2rad(double angleInDegrees) {
        double angleInRadians = (Math.PI/180) * angleInDegrees;
        return angleInRadians;
    }


    private double rad2deg(double angleInRadians) {
        double angleInDegrees = (180/Math.PI) * angleInRadians;
        return angleInDegrees;
    }


    // getter and setter
    public boolean isRecording() {
        return mIsRecording.get();
    }

    public float[] getAcceBias() {
        return mAcceBias;
    }

    public float[] getGyroBias() {
        return mGyroBias;
    }

    public float[] getMagnetBias() {
        return mMagnetBias;
    }

    public double getMotionStaticAccumulatedTime() {
        return mMotionStaticAccumulatedTime;
    }
}
