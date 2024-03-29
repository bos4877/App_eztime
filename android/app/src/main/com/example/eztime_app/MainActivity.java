package com.example.eztime_app;

import android.os.Bundle;
import android.provider.Settings;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private String CHANNEL = "checkADB";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(),CHANNEL).setMethodCallHandler((call, result) -> {
            if (call.method.equals("checkgadb")) {
                checkingadb(call,result);
            } else {
                result.notImplemented();
            }
        });
    }

    private void checkingadb(MethodCall call, MethodChannel.Result result) {
        if (Settings.Secure.getInt(this.getContentResolver(), Settings.Secure.ADB_ENABLED, 0) == 1) {
            // debugging enabled
            result.success(1);
        } else {
            //;debugging does not enabled
            result.success(0);
        }
    }
}