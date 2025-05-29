import UIKit
import Flutter
import FirebaseCore
import FirebaseAnalytics

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
      GeneratedPluginRegistrant.register(with: self)
     
      // Log an event to confirm analytics is working
      Analytics.logEvent("app_started", parameters: nil)

      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
