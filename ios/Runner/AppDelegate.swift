import UIKit
import Flutter
import Ably
import UserNotifications

let apiKey = ""
let myClientId = "foo"
let ablyClientOptions = ARTClientOptions()
let myPushChannel = "push"

let lifeCycleDelegate = FlutterPluginAppLifeCycleDelegate();

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, ARTPushRegistererDelegate {
    var realtime: ARTRealtime! = nil
    var channel: ARTRealtimeChannel!
    var myDeviceToken = ""
    var myDeviceId = ""

    private var eventSink: FlutterEventSink?
    private var _tokenChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, err) in
            DispatchQueue.main.async() {
                UIApplication.shared.registerForRemoteNotifications()
                print("[LOCALLOG] Request to show notifications successful")
            }
        }
    } else {
        // Fallback on earlier versions
    }

    self.realtime = self.getAblyRealtime()
    self.realtime.push.activate()

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    _tokenChannel = FlutterMethodChannel(name: "chatham.ai/push_token",
                                              binaryMessenger: controller.binaryMessenger)
    _tokenChannel?.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // Note: this method is invoked on the UI thread.
      // Handle battery messages.
    })

    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("[LOCALLOG] Registration for remote notifications successful")
        self.myDeviceToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("received device token: " + self.myDeviceToken)
        ARTPush.didRegisterForRemoteNotifications(withDeviceToken: deviceToken, realtime: self.getAblyRealtime())
        _tokenChannel?.invokeMethod("tokenReceived", arguments: self.myDeviceToken)
    }

    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("[LOCALLOG] Error registering for remote notifications")
        ARTPush.didFailToRegisterForRemoteNotificationsWithError(error, realtime: self.getAblyRealtime())
    }

    func didActivateAblyPush(_ error: ARTErrorInfo?) {
        if let error = error {
            // Handle error
            print("[LOCALLOG] Push activation failed, err=\(String(describing: error))")
            return
        }
        print("[LOCALLOG] Push activation successful")

        self.channel = self.realtime.channels.get(myPushChannel)
        self.channel.push.subscribeDevice { (err) in
            if(err != nil){
                print("[LOCALLOG] Device Subscription on push channel failed with err=\(String(describing: err))")
                return
            }
            self.myDeviceId = self.realtime.device.id
            print("[LOCALLOG] Client ID: " + myClientId)
            print("[LOCALLOG] Device Token: " + self.myDeviceToken)
            print("[LOCALLOG] Device ID: " + self.myDeviceId)
            print("[LOCALLOG] Push channel: " + myPushChannel)
        }
    }

    func didDeactivateAblyPush(_ error: ARTErrorInfo?) {
        print("[LOCALLOG] push deactivated")
    }

    private func getAblyRealtime() -> ARTRealtime {
        if(realtime == nil){
            ablyClientOptions.clientId = myClientId
            ablyClientOptions.key = apiKey
            realtime = ARTRealtime(options: ablyClientOptions)
        }
        return realtime
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
