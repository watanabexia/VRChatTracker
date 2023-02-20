//
//  NavigationView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/19/23.
//

import SwiftUI

struct NavigationView: View {
    var body: some View {
        TabView(selection: .constant(3)) {
            Text("WorldTabView")
                .tabItem {
                    Image(systemName: "globe")
                    Text("World")
                }
                .tag(1)
            Text("AvatarTabView")
                .tabItem {
                    Image(systemName: "theatermasks")
                    Text("Avatar")
                }
                .tag(2)
            Text("ProfileTabView")
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(3)
            Text("FriendsTabView")
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Friends")
                }
                .tag(4)
            Text("SettingTabView")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }
                .tag(4)
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}