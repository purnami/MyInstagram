//
//  Content.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//

import Foundation
import FirebaseCore

struct Post : Identifiable, Codable {
    var id: String
    var username : String
    var postUrl : String
    var postType : String
    var caption : String
    var datePost : Date
    var like : [String]
    var comment : [String: String]
}

//enum PostType {
//    case image
//    case video
//}
