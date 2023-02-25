//
//  UserDetailView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/24/23.
//

import SwiftUI
import SwiftVRChatAPI

struct UserDetailView: View {
    @ObservedObject var client: VRChatClient
    
    let user:User
    
    init(client: VRChatClient, user: User) {
        
        self.client = client
        self.user = user
        
        // https://stackoverflow.com/questions/69325928/swiftui-size-to-fit-or-word-wrap-navigation-title
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
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
                    if (user.userIcon ?? "" != "") {
                        AsyncImage(url: URL(string: user.userIcon!)) { image in
                                image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(.white, lineWidth: 4)
                                }
                                .shadow(radius: 7)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    Text("\(user.displayName!)")
                        .font(.title)
                        .bold()
                    
                    Text("\(user.statusDescription!)")
                        .padding(.top, -10)
                    
                    HStack {
                        Text("\(user.state!)")
                        
                        Text("\(user.status!)")
                    }
                    .padding(.top)
  
                    HStack {
                        ForEach(user.tags!, id: \.self) { tag in
                            if (tag.starts(with: "language")) {
                                Button(action: nothing) {
                                    Text(tag.suffix(3).uppercased())
                                }
                            }
                        }
                    }
                    .padding(.top, -7)
                    
                    HStack {
                        Text(user.bio!)
                            .multilineTextAlignment(.leading)
                        .padding(.top)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Button(action: {
                            if client.isFollowed(user: user) {
                                client.removeFollowedUserID(user: user)
                            } else {
                                client.addFollowedUserID(user: user)
                            }
                        }, label: {
                            if client.isFollowed(user: user) {
                                Text("Unfollow")
                                    .bold()
                            } else {
                                Text("Follow")
                            }
                        })
                        .padding()
                        .foregroundColor(.white)
                        .background(client.isFollowed(user: user) ? Color.red : Color.blue)
                        .clipShape(Capsule())
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 10.0)
                .offset(y: ((user.userIcon ?? "") == "") ? 0 : -100)
            }
//            .navigationBarBackButtonHidden(true)
            .scrollIndicators(.hidden)
            .ignoresSafeArea()
//            .navigationTitle(user.displayName!)
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(client: VRChatClient.createPreview(), user: PreviewData.load(name: "UserPreview")!)
    }
}
