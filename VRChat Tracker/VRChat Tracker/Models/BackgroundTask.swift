//
//  BackgroundTask.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/24/23.
//

import Foundation
import UserNotifications

func registerNotification() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in }
}
