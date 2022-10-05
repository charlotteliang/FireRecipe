import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseMessaging
import FirebaseRemoteConfig
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [
                     UIApplication.LaunchOptionsKey: Any
                   ]? = nil) -> Bool {
    FirebaseApp.configure()
                     
    //phoneSignIn()
    anonymousSignIn()
    setupRC()
    return true
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Pass device token to auth
    Auth.auth().setAPNSToken(deviceToken, type: .prod)
    Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
  }

  func application(_ application: UIApplication, open url: URL,
                   options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    if Auth.auth().canHandle(url) {
      return true
    }
    // URL not auth related; it should be handled separately.
    return true
  }

  func application(_ application: UIApplication,
      didReceiveRemoteNotification notification: [AnyHashable : Any],
      fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if Auth.auth().canHandleNotification(notification) {
      completionHandler(.noData)
      return
    }
    // This notification is not auth related; it should be handled separately.
  }

  
  func phoneSignIn() {
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    let phoneNumber = "+16505554567"

    // This test verification code is specified for the given test phone number in the developer console.
    let verificationCode = "123456"
    if (verificationID == nil) {
      PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
      PhoneAuthProvider.provider()
        .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
          if error != nil {
            return
          }
          UserDefaults.standard.set(verificationID, forKey: "authVerificationID")

        }
    } else {
      let credential = PhoneAuthProvider.provider().credential(
        withVerificationID: verificationID!,
        verificationCode: verificationCode
      )

      // Phone Auth
      Auth.auth().signIn(with: credential) { authResult, error in
          if let error = error {
            print(error)
          }
      }
    }
  }
  /// Signs in anonymously
  func anonymousSignIn() {
    if Auth.auth().currentUser == nil {
      Auth.auth().signInAnonymously()
    }
  }
  
  func setupRC() {
    let config = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    settings.minimumFetchInterval = 0
    config.configSettings = settings
  }
}

@main
struct FireRecipeApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .analyticsScreen(name: "ContentView")
    }
  }
}



