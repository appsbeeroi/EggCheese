import SwiftUI
import UserNotifications

@main
struct EggCheeseApp: App {
    @StateObject private var notificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notificationManager)
                .onAppear {
                    
                    if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
                        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                        
                    }
                }
        }
    }
}