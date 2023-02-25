//
//  FriendTabView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/22/23.
//

import SwiftUI
import SwiftVRChatAPI

struct FriendTabView: View {
    @ObservedObject var client: VRChatClient
    
    @State private var searchName = ""
    
    let refreshableToggle = true
    
    var body: some View {
        NavigationStack {
            List {
                if let onlineFriends = client.onlineFriends {
                    Section("Online Friends") {
                        FriendRowView(client: client, friends: onlineFriends)
                    }
                }
                if let activeFriends = client.activeFriends {
                    Section("Active Friends") {
                        FriendRowView(client: client, friends: activeFriends)
                    }
                }
                if let offlineFriends = client.offlineFriends {
                    Section("Offline Friends") {
                        FriendRowView(client: client, friends: offlineFriends)
                    }
                }
            }
            .navigationTitle("Friends")
        }
        .searchable(text: $searchName, prompt: "Search for friends...") {
            ScrollView {
                LazyVStack {
                    ForEach(searchResults) { friend in
                        NavigationLink {
                            UserDetailView(client: client, user: friend.user)
                        } label: {
                            UserView(user: friend.user, world: friend.world, instance: friend.instance)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .refreshable {
            client.updateFriends()
        }
        .onAppear {
            client.updateFriends()
        }
    }
    
    var searchResults: [Friend] {
        if searchName.isEmpty {
            return []
        } else {

            var friends:[Friend] = []

            if let onlineFriends = client.onlineFriends {
                friends += onlineFriends
            }
            if let activeFriends = client.activeFriends {
                friends += activeFriends
            }
            if let offlineFriends = client.offlineFriends {
                friends += offlineFriends
            }

            return friends.filter{ $0.user.displayName!.localizedCaseInsensitiveContains(searchName) }
        }
    }
}

struct FriendRowView: View {
    @ObservedObject var client: VRChatClient
    let friends: [Friend]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 5) {
                ForEach(friends.sorted{ $0.user.displayName! < $1.user.displayName! }) { friend in
                    NavigationLink {
                        UserDetailView(client: client, user: friend.user)
                    } label: {
                        UserView(user: friend.user, world: friend.world, instance: friend.instance)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

struct FriendTabView_Previews: PreviewProvider {
    static var previews: some View {
        FriendTabView(client: VRChatClient.createPreview())
    }
}
