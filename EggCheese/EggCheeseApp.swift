//
//  EggCheeseApp.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

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
                    // Проверяем, первый ли это запуск приложения
                    if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
                        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                        // Не запрашиваем разрешение автоматически - пользователь может включить в настройках
                    }
                }
        }
    }
}
