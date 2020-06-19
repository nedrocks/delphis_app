package ai.chatham.alpha;

import android.util.Log;
import android.os.Bundle;
import androidx.annotation.NonNull;
import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.InstanceIdResult;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    static final String CHANNEL_NAME = "chatham.ai/push_token";
    static final String CHANNEL_METHOD_ID = "didReceiveDeviceID";
    static final String CHANNEL_METHOD_TOKEN = "didReceiveToken";
    static final String CHANNEL_METHOD_BOTH = "didReceiveTokenAndDeviceID";
    private MethodChannel flutterDeviceChannel;
 
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FirebaseInstanceId.getInstance().getInstanceId().addOnCompleteListener(new OnCompleteListener<InstanceIdResult>() {
            @Override
            public void onComplete(@NonNull Task<InstanceIdResult> task) {
                if (!task.isSuccessful()) {
                    Log.w(this.getClass().getSimpleName(), "Failed to retrieve Firebase Clound Messaging token", task.getException());
                    return;
                }
                
                String token = task.getResult().getToken();
                Log.d(this.getClass().getSimpleName(), "FCM DEVICE TOKEN: " + token);
                if(token == null || token.length() == 0) {
                    Log.w(this.getClass().getSimpleName(), "Received a bad FCM token");
                    return;
                }

                String deviceId = task.getResult().getId();
                if(deviceId == null || deviceId.length() == 0) {
                    Log.w(this.getClass().getSimpleName(), "Received a bad FCM device instance ID");
                    return;
                }
                Log.d(this.getClass().getSimpleName(), "FCM DEVICE INSTANCE ID: " + deviceId);

                try {
                    flutterDeviceChannel.invokeMethod(CHANNEL_METHOD_BOTH, deviceId + "." + token);
                }
                catch (Exception e) {
                    Log.w(this.getClass().getSimpleName(), "Error while sending FCM to Flutter channel" + e.getMessage());
                }
            }
        });
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        this.flutterDeviceChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_NAME);
        this.flutterDeviceChannel.setMethodCallHandler((call, result) -> {
            Log.d(this.getClass().getSimpleName(), "Received an unexpected method call from Flutter: " + call.method);
        });
    }

} 
