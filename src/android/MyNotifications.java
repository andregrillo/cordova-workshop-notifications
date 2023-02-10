package outsystems.plugin.mynotifications;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Build;
import android.os.Handler;

import androidx.annotation.RequiresApi;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import io.cordova.hellocordova.R;


/**
 * This class echoes a string called from JavaScript.
 */
public class MyNotifications extends CordovaPlugin {

    private final String ACTION_SEND_NOTIFICATION = "sendNotification";

    private NotificationManager notificationManager;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals(ACTION_SEND_NOTIFICATION)) {

            String title = (String) args.get(0);
            String message = (String) args.get(1);
            Integer seconds = (Integer) args.get(2);

            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    notificationManager = (NotificationManager) this.cordova.getActivity().getSystemService(Context.NOTIFICATION_SERVICE);
                    createNotificationChannel(title, message, seconds, callbackContext);
                }
            } catch (Exception ex) {
                callbackContext.error(ex.getMessage());
            }
            return true;
        }
        return false;
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    protected void createNotificationChannel(String title, String message, Integer seconds, CallbackContext callbackContext) {
        int notificationID = 101;
        String channelID = cordova.getActivity().getPackageName();

        Notification notification =
                new Notification.Builder(this.cordova.getContext(), channelID)
                        .setContentTitle(title)
                        .setContentText(message)
                        .setSmallIcon(R.drawable.ic_cdv_splashscreen)
                        .setChannelId(channelID)
                        .build();

        final Handler handler = new Handler();
        handler.postDelayed(() -> {
            notificationManager.notify(notificationID, notification);
            callbackContext.success();
        }, seconds * 1000);
    }
}