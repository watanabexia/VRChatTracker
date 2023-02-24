//
//  PreviewData.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/23/23.
//

import Foundation
import SwiftVRChatAPI

class PreviewData {
    
    static func load<T: Codable>(name: String) -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: ".json") {
            do {
                let data = try Data(contentsOf: URL(filePath: path))
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            } catch {
                
            }
        }
        
        return nil
    }
}
