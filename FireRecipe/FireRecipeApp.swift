import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseRemoteConfig
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [
                     UIApplication.LaunchOptionsKey: Any
                   ]? = nil) -> Bool {
    FirebaseApp.configure()
                     
    setupAnonymousAuth()
    setupRC()
    return true
  }
  
//  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//    // Pass device token to auth
//    Auth.auth().setAPNSToken(deviceToken, type: .prod)
//
//    // Further handling of the device token if needed by the app
//    // ...
//  }
//
//  func application(_ application: UIApplication, open url: URL,
//                   options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//    if Auth.auth().canHandle(url) {
//      return true
//    }
//    // URL not auth related; it should be handled separately.
//    return true
//  }
//
//  func application(_ application: UIApplication,
//      didReceiveRemoteNotification notification: [AnyHashable : Any],
//      fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//    if Auth.auth().canHandleNotification(notification) {
//      completionHandler(.noData)
//      return
//    }
//    // This notification is not auth related; it should be handled separately.
//  }

  
  func setupPhoneAuth() {
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    let phoneNumber = "+16505554567"

    // This test verification code is specified for the given test phone number in the developer console.
    let verificationCode = "123456"
    if (verificationID == nil) {
      PhoneAuthProvider.provider()
        .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
          if error != nil {
           // self.showMessagePrompt(error.localizedDescription)
            return
          }
          UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
          
          // Sign in using the verificationID and the code sent to the user
          // ...
        }
    } else {
      let credential = PhoneAuthProvider.provider().credential(
        withVerificationID: verificationID!,
        verificationCode: verificationCode
      )

      
      // Phone Auth
      Auth.auth().signIn(with: credential as! PhoneAuthCredential) { authResult, error in
          if let error = error {
            let authError = error as! NSError
            if authError.code == AuthErrorCode.secondFactorRequired.rawValue {
              // The user is a multi-factor user. Second factor challenge is required.
//              let resolver = error.userInfo?[AuthUpdatedCredentialKey] as! MultiFactorResolver
//                      if resolver.hints[0].factorId == TotpMultiFactorID {
//                          // Show hints resolver.multiFactorInfo to user for selection.
//                          let assertion = TotpMultiFactorGenerator.assertionForSignIn(withEnrollmentId: hints[0].uid, oneTimePassword: oneTimePassword)
//                          resolver.resolveSignIn(
//                              withAssertion: assertion) { authResult, error in
//                              if error != nil {
//                                  // Error occurred.
//                              } else {
//                                  // Successfully signed in.
//                              }
//                          }
//                      } else {
//                          // Some other error.
//                      }

            } else {
              return
            }
            // ...
            return
          }
           
      }
    }
  }
  
  func setupAnonymousAuth() {
    Auth.auth().signInAnonymously { authResult, error in
      // ...
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
        }
    }
}
