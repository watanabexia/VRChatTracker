//
//  SettingTabView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/22/23.
//

import SwiftUI

struct SettingTabView: View {
    @ObservedObject var client: VRChatClient
    
    
    var body: some View {
        NavigationStack {
            List {
                Section(content: {
                    Button(action: logout, label: {
                        Text("logout")
                    })
                }, header: {
                    Text("system")
                })
                
                Section(content: {
                    Button(action: nothing, label: {
                        Text("contribute on GitHub")
                    })
                    Button(action: nothing, label: {
                        Text("support us!")
                    })
                }, header: {
                    Text("about")
                })
            }
            .navigationTitle("Setting")
        }
    }
    
    func logout() {
        client.clear()
    }
}

struct SettingTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingTabView(client: VRChatClient.createPreview())
    }
}
