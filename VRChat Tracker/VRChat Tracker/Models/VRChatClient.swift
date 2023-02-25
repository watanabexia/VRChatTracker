//
//  VRChatClient.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/22/23.
//

import Foundation
import SwiftVRChatAPI

class VRChatClient: ObservableObject {
    
    // LoginView
    @Published var isLoggedIn = false
    @Published var is2FA = false
    @Published var isAutoLoggingIn = false
    
    // ProfileTabView
    @Published var user: User?
    
    // FriendTabView
    @Published var onlineFriends: [Friend]?
    @Published var activeFriends: [Friend]?
    @Published var offlineFriends: [Friend]?
    
    @Published var followedUserIDs:[String]?
    
    var apiClient = APIClient()
    
    let defaults = UserDefaults.standard
    
    init(autoLogin: Bool = true) {
        // Fetch the currently available cookies
        apiClient.updateCookies()
        
        if (autoLogin) {
            isAutoLoggingIn = true
            // Try to login with available cookies
            loginUserInfo()
        }
    }
    
    //
    // MARK: Authentication
    //
    
    func loginUserInfo() {
        AuthenticationAPI.loginUserInfo(client: self.apiClient) { user in
            DispatchQueue.main.async {
                self.user = user
                
                // If already successfully logged in
                if (self.user?.displayName != nil) {
                    self.isLoggedIn = true
                    self.readFollowedUserIDs()
                } else if (self.user?.requiresTwoFactorAuth == ["emailOtp"]) {
                    self.isLoggedIn = false
                    self.is2FA = true
                }
                
                self.isAutoLoggingIn = false
            }
            
            //Debug
            print("** loginUserInfo() **")
            print(self.isLoggedIn)
            print(self.is2FA)
            //Debug End
        }
    }
    
    func email2FALogin(emailOTP: String) {
        AuthenticationAPI.verify2FAEmail(client: self.apiClient, emailOTP: emailOTP) { verify in
            guard let verify = verify else { return }
            
            //Debug
            print("** email2FALogin() **")
            print(verify)
            //Debug End
            
            if (verify) {
                self.loginUserInfo()
            }
        }
    }
    
    func clear() {
        self.isLoggedIn = false
        self.is2FA = false
        self.isAutoLoggingIn = false
        self.user = nil
        self.followedUserIDs = nil
    }
    
    //
    // MARK: User
    //
    
    func updateFriends() {
        self.onlineFriends = []
        self.activeFriends = []
        self.offlineFriends = []
        
        if let user = user {
            for userID in user.onlineFriends! {
                UserAPI.getUser(client: apiClient, userID: userID) { user in
                    guard let user = user else { return }
                    
                    let worldID = user.worldId!
                    let instanceID = user.instanceId!
            
                    if (worldID != "private") {
                        InstanceAPI.getInstance(client: self.apiClient, worldID: worldID, instanceID: instanceID) { instance in
                            WorldAPI.getWorld(client: self.apiClient, worldID: worldID) { world in
                                DispatchQueue.main.sync {
                                    self.onlineFriends?.append(Friend(user: user, world: world, instance: instance))
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.onlineFriends?.append(Friend(user: user))
                        }
                    }
                    
    //                print("** onlineFriends() **")
    //                print(self.onlineFriends)
                    
                }
            }
            
            for userID in user.activeFriends! {
                UserAPI.getUser(client: apiClient, userID: userID) { user in
                    guard let user = user else { return }

                    DispatchQueue.main.async {
                        self.activeFriends?.append(Friend(user: user))
                    }
                }
            }
            
            for userID in user.offlineFriends! {
                UserAPI.getUser(client: apiClient, userID: userID) { user in
                    guard let user = user else { return }

                    DispatchQueue.main.async {
                        self.offlineFriends?.append(Friend(user: user))
                    }
                }
            }
        }
    }
    
    //
    // MARK: Followed Friends
    //
    
    func readFollowedUserIDs() {
        defaults.register(defaults: ["followedUsersID-\(self.user!.id!)":[]])
        self.followedUserIDs = (defaults.object(forKey: "followedUsersID-\(self.user!.id!)") as! [String])
    }
    
    func addFollowedUserID(user: User) {
        followedUserIDs!.append(user.id!)
        defaults.set(followedUserIDs, forKey: "followedUsersID-\(self.user!.id!)")
        
        //Debug
//        print("** add follow **")
//        print(followedUserIDs)
        //Debug Ends
    }
    
    func removeFollowedUserID(user: User) {
        if let idx = followedUserIDs!.firstIndex(where: {$0 == user.id}) {
            followedUserIDs!.remove(at: idx)
        }
        defaults.set(followedUserIDs, forKey: "followedUsersID-\(self.user!.id!)")
        
        //Debug
//        print("** remove follow **")
//        print(followedUserIDs)
        //Debug Ends
    }
    
    func isFollowed(user: User) -> Bool {
        return followedUserIDs!.contains(user.id!)
    }
    
    /**
     Create a sample `VRChatClient` instance for preview.
     */
    static func createPreview() -> VRChatClient {
        let client_preview = VRChatClient(autoLogin: false)
        
        client_preview.user = PreviewData.load(name: "UserPreview")
        
        client_preview.isLoggedIn = true
        
        client_preview.onlineFriends = [Friend(user: client_preview.user!,
                                               world: PreviewData.load(name: "WorldPreview"),
                                               instance: PreviewData.load(name: "InstancePreview"))]
        
        return client_preview
    }
}

func nothing() {
    
}
