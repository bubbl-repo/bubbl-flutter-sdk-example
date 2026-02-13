import Bubbl
import FirebaseCore
import FirebaseMessaging
import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, MessagingDelegate {
  private var firebaseConfigured = false

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    firebaseConfigured = configureFirebaseIfPossible()

    UNUserNotificationCenter.current().delegate = NotificationManager.shared
    if firebaseConfigured {
      Messaging.messaging().delegate = self
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func configureFirebaseIfPossible() -> Bool {
    if FirebaseApp.app() != nil {
      return true
    }

    guard let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
      NSLog("[BubblExample] GoogleService-Info.plist not found. Skipping Firebase configure.")
      return false
    }

    guard let options = FirebaseOptions(contentsOfFile: filePath) else {
      NSLog("[BubblExample] GoogleService-Info.plist is invalid. Skipping Firebase configure.")
      return false
    }

    FirebaseApp.configure(options: options)
    return true
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    if firebaseConfigured {
      Messaging.messaging().apnsToken = deviceToken
    }
    BubblPlugin.updateAPNsToken(deviceToken)
  }

  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    guard let token = fcmToken else {
      return
    }
    BubblPlugin.updateFCMToken(token)
  }
}
