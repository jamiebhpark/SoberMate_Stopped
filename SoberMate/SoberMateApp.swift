import SwiftUI
import AWSAPIPlugin
import Amplify
import AWSDataStorePlugin
import AWSCognitoAuthPlugin
import UserNotifications

@main
struct SoberMateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var amplifyManager = AmplifyManager()

    var body: some Scene {
        WindowGroup {
            if amplifyManager.isConfigured {
                ContentView()
            } else {
                Text("Configuring Amplify...")
                    .onAppear {
                        amplifyManager.configureAmplify()
                    }
            }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

class AmplifyManager: ObservableObject {
    @Published var isConfigured = false

    func configureAmplify() {
        DispatchQueue.global().async {
            do {
                try Amplify.add(plugin: AWSCognitoAuthPlugin())
                try Amplify.add(plugin: AWSAPIPlugin())
                try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels()))
                try Amplify.configure() // 파일 기반 구성 사용
                
                DispatchQueue.main.async {
                    self.isConfigured = true
                    print("Amplify configured with API, DataStore, and Auth plugins")
                }
            } catch {
                print("An error occurred setting up Amplify: \(error)")
            }
        }
    }
}
