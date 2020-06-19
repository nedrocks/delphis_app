package ai.chatham.alpha;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import io.ably.lib.realtime.AblyRealtime;
import io.ably.lib.realtime.CompletionListener;
import io.ably.lib.realtime.ConnectionStateListener;
import io.ably.lib.types.AblyException;
import io.ably.lib.types.ClientOptions;
import io.ably.lib.types.ErrorInfo;
import io.ably.lib.util.IntentUtils;
import io.flutter.view.FlutterView;
import android.content.Context;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import io.flutter.plugins.GeneratedPluginRegistrant;

import ai.chatham.alpha.receivers.AblyPushMessagingService;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

public class MainActivity extends FlutterActivity {
    static final String API_KEY = "HZZHIQ.UeYnxQ:Vb7o5FUq2KLUaWJr";
    static final String CHANNEL_NAME = "chatham.ai/push_token";
    static final String CHANNEL_METHOD_ID = "didReceiveDeviceID";
    static final String CHANNEL_METHOD_TOKEN = "didReceiveToken";
    static final String CHANNEL_METHOD_BOTH = "didReceiveTokenAndDeviceID";
    private AblyRealtime ablyRealtime;
    private MethodChannel flutterDeviceChannel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        LocalBroadcastManager.getInstance(this).registerReceiver(pushReceiver, new IntentFilter("io.ably.broadcast.PUSH_ACTIVATE"));
        LocalBroadcastManager.getInstance(this).registerReceiver(pushReceiver, new IntentFilter(AblyPushMessagingService.PUSH_NOTIFICATION_ACTION));
        LocalBroadcastManager.getInstance(this).registerReceiver(pushReceiver, new IntentFilter(AblyPushMessagingService.NEW_TOKEN_ACTION));
        try {
            initAblyRuntime();
        } catch (AblyException e) {
            logMessage("AblyException " + e.getMessage());
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        createFlutterDeviceChannel(flutterEngine);
    }

    /* I have no clue on how Flutter/Android handle this part, and if different threads will access this section.
       I consider this critical section is here only to avoid problems. */
    private synchronized void createFlutterDeviceChannel(@NonNull FlutterEngine flutterEngine) {
        this.flutterDeviceChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_NAME);
        this.flutterDeviceChannel.setMethodCallHandler((call, result) -> {
            logMessage("Ably received an unexpected method call from Flutter: " + call.method);
        });
    }

    private synchronized  MethodChannel getFlutterDeviceChannel() {
        return this.flutterDeviceChannel;
    }

    private void initAblyRuntime() throws AblyException {
        ClientOptions options = new ClientOptions();
        options.key = API_KEY;
        options.clientId = Settings.Secure.getString(getContentResolver(), Settings.Secure.ANDROID_ID);
        ablyRealtime = new AblyRealtime(options);
        ablyRealtime.connect();
        ablyRealtime.connection.on(new ConnectionStateListener() {
            @Override
            public void onConnectionStateChanged(ConnectionStateChange state) {
                logMessage("Ably Connection state changed to : " + state.current.name());
                switch (state.current) {
                    case connected:
                        try {
                            ablyRealtime.platform.setAndroidContext(getContext());
                            ablyRealtime.push.activate();
                        }
                        catch (Exception e) {
                            logMessage("Ably unable to connect error: " + e);
                        }
                        break;
                }
            }
        });
    }
    
    private BroadcastReceiver pushReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {

            if ("io.ably.broadcast.PUSH_ACTIVATE".equalsIgnoreCase(intent.getAction())) {
                ErrorInfo error = IntentUtils.getErrorInfo(intent);
                if (error != null) {
                    logMessage("Ably error activating push service: " + error);
                    return;
                }
                try {
                    String deviceId = ablyRealtime.device().id;
                    String token = ablyRealtime.device().deviceIdentityToken;
                    logMessage("Ably device is now registered for push with deviceId " + deviceId);
                    logMessage("Ably device is now registered for push with token " + token);
                    sendInfoOnFlutterChannel();
                }
                catch(Exception e) {
                    logMessage("Ably exception getting deviceId or token: " + e);
                }
                return;
            }

            if (AblyPushMessagingService.PUSH_NOTIFICATION_ACTION.equalsIgnoreCase(intent.getAction())) {
                // Nothing to do here. If user needs the message he can receive it from the Flutter-side
                logMessage("Ably received a push notification message");
            }

            if (AblyPushMessagingService.NEW_TOKEN_ACTION.equalsIgnoreCase(intent.getAction())) {
                logMessage("Ably received a new device registration token");
                sendInfoOnFlutterChannel();
            }
        }
    };

    private void sendInfoOnFlutterChannel() {
        try {
            String deviceId = ablyRealtime.device().id;
            String token = ablyRealtime.device().deviceIdentityToken;

            /* Send info to Flutter side */
            MethodChannel channel = getFlutterDeviceChannel();
            if(channel != null) {
                if((deviceId != null && deviceId.length() > 0) && (token != null && token.length() > 0))
                    channel.invokeMethod(CHANNEL_METHOD_BOTH, deviceId + "." + token);
                else if(deviceId != null && deviceId.length() > 0)
                    channel.invokeMethod(CHANNEL_METHOD_ID, deviceId);
                else if(token != null && token.length() > 0)
                    channel.invokeMethod(CHANNEL_METHOD_TOKEN, token);
                else
                    logError("Ably wants tried to send null info to Flutter channel");
            };
        }
        catch (Exception e) {
            logError("Ably error in sending info to Flutter channel: " + e.getMessage());
        }
    }

    private void logMessage(String message) {
        Log.d(this.getClass().getSimpleName(), message);
    }

    private void logError(String message) {
        Log.e(this.getClass().getSimpleName(), message);
    }

}