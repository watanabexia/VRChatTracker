//
//  VRChat_TrackerApp.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/16/23.
//

import SwiftUI
import SwiftVRChatAPI
import BackgroundTasks

@main
struct VRChat_TrackerApp: App {
    @Environment(\.scenePhase) private var phase
    
    @StateObject var client = VRChatClient()
    
    init() {
        registerNotification()
        registerBackgroundFetch()
    }
    
    var body: some Scene {
        WindowGroup {
            if (client.isLoggedIn) {
                NavigationView(client: client)
            } else if (!client.isAutoLoggingIn) {
                LoginView(client: client)
            }
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .background: scheduleBackgroundFetch()
            default: break
            }
        }
        .backgroundTask(.appRefresh("fetchFriendsStatus")) {
            await backgroundFetch()
        }
    }
    
    func registerBackgroundFetch() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "fetchFriendStatus", using: DispatchQueue.main) { task in
        }
    }
    
    
    func scheduleBackgroundFetch() {
        let request = BGAppRefreshTaskRequest(identifier: "fetchFriendStatus")
//        request.earliestBeginDate = Calendar.current.date(byAdding: .second, value: 30, to: Date())
        do {
            try BGTaskScheduler.shared.submit(request)
            print("** background task scheduled! **")
        } catch(let error) {
            print("** background task schedule ERROR: \(error.localizedDescription)**")
        }
    }
    
    func backgroundFetch() {
        
        scheduleBackgroundFetch()

        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        
        if (client.isLoggedIn) {
            
            //Debug
            content.title = "Debug: Starting to fetch followed status"
            content.subtitle = "let's gooo!"
            //Debug Ends
            
            do {
                client.updateFriends()
                
                var onlineFollowedCount = 0
                
                for friend in client.onlineFriends! {
                    if client.isFollowed(user: friend.user) {
                        onlineFollowedCount += 1
                    }
                }
                
                if (onlineFollowedCount > 0) {
                    content.title = "\(onlineFollowedCount) of your followed users are online!"
                    content.subtitle = "Let's go and say hi!"
                } else {
                    //Debug
                    content.title = "\(onlineFollowedCount) of your followed users are online."
                    content.subtitle = "That's what I call lonely."
                    //Debug Ends
                }
            }
            
        } else {
            content.title = "Unable to fetch the friend status"
            content.subtitle = "Please try to login again in the app"
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
