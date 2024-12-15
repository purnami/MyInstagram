//
//  Story.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 29/11/24.
//

import Foundation
import FirebaseCore
import SwiftUI

struct Story : Identifiable, Codable{
    var id: String
    var username : String
    var storyImage : String
    var datePost : Date
}
