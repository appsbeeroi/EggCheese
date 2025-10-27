import SwiftUI
import UserNotifications

@main
struct EggCheeseApp: App {
    @StateObject private var notificationManager = NotificationManager()
    @State private var showingNotificationAlert = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notificationManager)
                .onAppear {
                    if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
                        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                        showingNotificationAlert = true
                    }
                }
                .alert("Enable Notifications", isPresented: $showingNotificationAlert) {
                    Button("Not Now", role: .cancel) { }
                    Button("Enable") {
                        notificationManager.requestPermission()
                    }
                } message: {
                    Text("Would you like to receive notifications for batch reminders and cheese making alerts?")
                }
        }
    }
}
