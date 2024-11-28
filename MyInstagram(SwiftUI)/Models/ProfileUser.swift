//
//  UserLogin.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 22/11/24.
//
import Foundation
import SwiftUI

class ProfileUser: Hashable, Identifiable {
    var username: String = ""
//    var profileImage: Data?
    var profileImage: UIImage?
    
    // Conform to Identifiable
    var id: String { username } // or another unique identifier

    // Conform to Hashable
    static func ==(lhs: ProfileUser, rhs: ProfileUser) -> Bool {
        return lhs.username == rhs.username
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(username)
    }
}
