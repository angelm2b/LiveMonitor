//
//  LiveMonitorApp.swift
//  LiveMonitor
//
//  Created by ANGELM2B on 4/9/24.
//

import SwiftUI
import UserNotifications

@main
struct VideoMonitorApp: App {
    init() {
        requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted.")
            } else if let error = error {
                print("Permission not granted: \(error.localizedDescription)")
            }
        }
    }
}
