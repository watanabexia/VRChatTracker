//
//  AvatarTabView.swift
//  VRChat Tracker
//
//  Created by Jintao Hu on 3/3/23.
//

import SwiftUI

struct AvatarTabView: View {
    
    // search bar text
    @State private var searchText = ""
    @ObservedObject var client: VRChatClient
    
    var avatarExamples: [VRAvatar] = [avatarExample1, avatarExample2, avatarExample3]
    
    var body: some View {
        let avatarList = client.avatarList != nil ? client.avatarList! : avatarExamples
        NavigationStack {
            SearchBarView(text: $searchText)
                .padding([.leading, .trailing, .bottom], 16)
            List (avatarList.filter({ searchText.isEmpty ? true : $0.name?.localizedCaseInsensitiveContains(searchText) ?? false })) { item in
                NavigationLink {
                    AvatarDetailView(avatar: item)
                } label: {
                    VStack{
                        Divider()
                        Text(item.name!)
                            .foregroundColor(.white)
                            .bold()
                        AsyncImage(url: URL(string: item.imageUrl!)) { image in
                            image
                                .resizable()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .scaledToFit()
                                .overlay {
                                    Rectangle().stroke(.black, lineWidth: 0.1)
                                }
                        } placeholder: {
                            // placeholder while the image is loading
                            Image("cat")
                                .resizable()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .scaledToFit()
                                .overlay {
                                    Rectangle().stroke(.black, lineWidth: 0.1)
                                }
                        }
                    }
                    .background(Color("BackgroundColor"))
                }
            }
            .navigationTitle("Favorite Avatars")
        }
        .refreshable {
            client.getAvatars()
        }
    }
}

struct AvatarTabView_Previews: PreviewProvider {
    static var previews: some View {
//        let avatarList: [VRAvatar] = [avatarExample1, avatarExample2, avatarExample3]
//        AvatarTabView(avatarList: avatarList)
        AvatarTabView(client: VRChatClient.createPreview())
    }
}
