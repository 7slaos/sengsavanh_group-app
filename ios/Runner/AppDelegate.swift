import Flutter
import UIKit
import FirebaseCore
import GoogleMaps
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Use same direct key wiring as the working Pathana build so Google Maps renders
    GMSServices.provideAPIKey("AIzaSyCEwurhgatlx8OZDWVrQ1WzGRvXegtd1ew")
    GeneratedPluginRegistrant.register(with: self)
//     FirebaseApp.configure()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
