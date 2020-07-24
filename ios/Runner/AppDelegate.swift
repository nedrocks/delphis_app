import UIKit
import Flutter
import UserNotifications
import Firebase

let apiKey = ""
let myClientId = "foo"
let myPushChannel = "push"

let lifeCycleDelegate = FlutterPluginAppLifeCycleDelegate();

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var myDeviceToken = ""
    var myDeviceId = ""

    private var eventSink: FlutterEventSink?
    private var _tokenChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    _tokenChannel = FlutterMethodChannel(name: "chatham.ai/push_token",
                                              binaryMessenger: controller.binaryMessenger)

    GeneratedPluginRegistrant.register(with: self)

    self.myDeviceId = UIDevice.current.identifierForVendor!.uuidString;

    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, err) in
            DispatchQueue.main.async() {
                UIApplication.shared.registerForRemoteNotifications()
                print("[LOCALLOG] Request to show notifications successful")
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
    } else {
        // Fallback on earlier versions
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.myDeviceToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        DispatchQueue.main.async {
            self._tokenChannel?.invokeMethod("didReceiveTokenAndDeviceID", arguments:"\(self.myDeviceId).\(self.myDeviceToken)")
        }
    }

    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        DispatchQueue.main.async {
            self._tokenChannel?.invokeMethod("didReceiveTokenAndDeviceID", arguments:"\(self.myDeviceId).")
        }
    }

    override func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        print("here")
        // Get URL components from the incoming user activity
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
            return false
        }

        // Check for specific URL components that you need
        guard let path = components.path,
        let params = components.queryItems else {
            return false
        }
        print("path = \(path)")

        return true
    }
}

extension AppDelegate {

    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Tell the app that we have finished processing the user's action (eg: tap on notification banner) / response
        // Handle received remoteNotification: 'response.notification.request.content.userInfo'
        // response.notification.request.content.userInfo
        print(response.notification.request.content.userInfo)
        completionHandler()
    }

    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("[LOCALLOG] Your device just received a notification!")
        // Show the notification alert in foreground
        completionHandler([.alert, .sound])
    }
}
