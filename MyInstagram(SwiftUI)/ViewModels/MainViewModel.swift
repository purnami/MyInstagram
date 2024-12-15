//
//  MainViewModel.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 25/11/24.
//

import SwiftUI
import FirebaseAuth

class MainViewModel : ObservableObject {
    @Published var username: String = ""
    @Published var profileImage: [String: UIImage] = [:]
    @Published var isLiked: [String: Bool] = [:]
    @Published var likeCount : [String : Int] = [:]
    
    var firestoreManager = FirestoreManager()
    
    func fetchUsername() {
        if let email = Auth.auth().currentUser?.email {
            username = String(email.split(separator: "@").first ?? "")
        }
    }
    
    func fetchProfileImage(_ username: String) {
        firestoreManager.fetchImage(username: username) { image in
            DispatchQueue.main.async {
                self.profileImage[username] = image
            }
        }
    }
    
    func checkIsLiked(postID: String, userID: String){
        firestoreManager.fetchPostLikes(postID: postID, userID: userID) { likes in
            DispatchQueue.main.async {
                self.isLiked[postID] = likes
            }
        }
    }
    
    func countingLike(postID: String, userID: String){
        print("countingLike")
        firestoreManager.countingLike(postID: postID, userID: userID) { likes in
            DispatchQueue.main.async {
                print("countingLike \(postID) \(likes)")
                self.likeCount[postID] = likes
            }
        }
    }
    
    func likePostClicked(postID: String, userID: String) {
        // Toggle the local like state
        let currentState = isLiked[postID] ?? false
        isLiked[postID] = !currentState
        
        // Update the local likeCount immediately
        if currentState {
            likeCount[postID, default: 0] -= 1
        } else {
            likeCount[postID, default: 0] += 1
        }
        
        // Update the Firestore
        firestoreManager.likePost(postID: postID, userID: userID) { success in
            if !success {
                // Revert the local state if Firestore update failed
                DispatchQueue.main.async {
                    self.isLiked[postID] = currentState
                    if currentState {
                        self.likeCount[postID, default: 0] += 1
                    } else {
                        self.likeCount[postID, default: 0] -= 1
                    }
                }
             
            }
        }
    }
}
