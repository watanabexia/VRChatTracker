//
//  ProfileTabView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/19/23.
//

import SwiftUI
import SwiftVRChatAPI

struct ProfileTabView: View {
    @ObservedObject var client: VRChatClient
    
    let user:User
    
    init(client: VRChatClient) {
        self.client = client
        
        self.user = client.user!
        
        // https://stackoverflow.com/questions/69325928/swiftui-size-to-fit-or-word-wrap-navigation-title
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                AsyncImage(url: URL(string: user.currentAvatarImageUrl!)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                
                VStack {
                    AsyncImage(url: URL(string: user.userIcon!)) { image in
                            image
                            .resizable()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(.white, lineWidth: 4)
                            }
                            .shadow(radius: 7)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Text("\(user.state!)")
                    
                    HStack {
                        ForEach(user.tags!, id: \.self) { tag in
                            if (tag.starts(with: "language")) {
                                Button(action: nothing) {
                                    Text(tag.suffix(3).uppercased())
                                }
                            }
                        }
                        if (user.tags!.count < 4) {
                            Button(action: nothing) {
                                Image(systemName: "plus.circle")
                            }
                        }
                    }
                    
                    HStack {
                        Text(user.bio!)
                            .multilineTextAlignment(.leading)
                        .padding(.top)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .offset(y: -100)
            }
            .padding(.horizontal, 10.0)
            .navigationTitle(user.displayName!)
            
        }
    }
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView(client: VRChatClient.createPreview())
    }
}
