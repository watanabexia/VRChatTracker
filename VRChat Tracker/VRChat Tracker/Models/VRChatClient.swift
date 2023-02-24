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
    @Published var friends: [User]?
    
    
    var apiClient = APIClient()
    
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
    // MARK: Authentication APIs
    //
    
    func loginUserInfo() {
        AuthenticationAPI.loginUserInfo(client: self.apiClient) { user in
            DispatchQueue.main.async {
                self.user = user
                
                // If already successfully logged in
                if (self.user?.displayName != nil) {
                    self.isLoggedIn = true
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
        self.friends = nil
    }
    
    //
    // MARK: User APIs
    //
    
    /**
     Create a sample `VRChatClient` instance for preview.
     */
    static func createPreview() -> VRChatClient {
        let client_preview = VRChatClient(autoLogin: false)
        
        client_preview.user = PreviewData.load(name: "UserPreview")
        
        return client_preview
    }
}

func nothing() {
    
}
