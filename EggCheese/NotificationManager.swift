//
//  NotificationManager.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import Foundation
import UserNotifications
import UIKit

class NotificationManager: ObservableObject {
    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    init() {
        checkAuthorizationStatus()
    }
    
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.authorizationStatus = .authorized
                } else {
                    self.authorizationStatus = .denied
                }
            }
        }
    }
    
    func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    var isAuthorized: Bool {
        return authorizationStatus == .authorized
    }
    
    var canRequestPermission: Bool {
        return authorizationStatus == .notDetermined
    }
    
    var shouldShowSettingsButton: Bool {
        return authorizationStatus == .denied
    }
}
