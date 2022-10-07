//
// FireRecipeApp.swift
// FireRecipe
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

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

class NavigationRouter: ObservableObject {
  @Published var path = NavigationPath()
}

@main
struct FireRecipeApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject private var router = NavigationRouter()
  
  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $router.path) {
        RecipeListView()
          .environmentObject(router)
          .analyticsScreen(name: "Recipe List")
      }
    }
  }
}



