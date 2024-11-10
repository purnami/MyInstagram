//
//  Content.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//

import Foundation
import FirebaseCore

struct Content:Identifiable {
    let id: UUID
    var userName : String
    var postUrl : String
    var datePost : Timestamp
}
