//
//  UserViewModel.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//

import Foundation
import Combine
import SwiftUI

class ContentViewModel : ObservableObject {
    @Published var profileImage : UIImage?
    
    init(){
        fetchProfileImage()
    }
    
    func fetchProfileImage(){
        if let imageData = UserDefaults.standard.data(forKey: "profileImage") {
            if let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.profileImage = image
                }
                print("Profile image loaded successfully")
            } else {
                print("Failed to convert data to UIImage")
            }
        } else {
            print("No image data found in UserDefaults")
        }
    }
}
