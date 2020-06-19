
package ai.chatham.alpha.receivers;

import android.content.Intent;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import android.util.Log;

import ai.chatham.alpha.MainActivity;
import io.ably.lib.push.ActivationContext;
import io.ably.lib.types.RegistrationToken;

public class AblyPushMessagingService extends FirebaseMessagingService {
    public static final String PUSH_NOTIFICATION_ACTION = AblyPushMessagingService.class.getName() + ".PUSH_NOTIFICATION_MESSAGE";
    public static final String NEW_TOKEN_ACTION = AblyPushMessagingService.class.getName() + ".NEW_TOKEN_MESSAGE";

    @Override
    public void onMessageReceived(RemoteMessage message) {
        super.onMessageReceived(message);
        Intent intent = new Intent(PUSH_NOTIFICATION_ACTION);
        LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(intent);
    }

    @Override
    public void onNewToken(String s) {
        super.onNewToken(s);
        ActivationContext.getActivationContext(this).onNewRegistrationToken(RegistrationToken.Type.FCM, s);
        Intent intent = new Intent(NEW_TOKEN_ACTION);
        LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(intent);
    }

}