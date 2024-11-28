//
//  HomeViewModel.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 25/11/24.
//

import SwiftUI
import FirebaseAuth
final class HomeViewModel : ObservableObject {
    @Published var postsArrayOthers: [Post] = []
    @Published var isLiked: [String: Bool] = [:]
    private var isLikedCache: [String: Bool] = [:]
    @Published var profileImage : [String : UIImage] = [:]
    @Published var likeCount : [String : Int] = [:]
    
    private var firestoreManager = FirestoreManager()
    
    init(){
        fetchPostFromFollowingUser()
    }
    
    func fetchPostFromFollowingUser(){
        Task {
            firestoreManager.fetchFollowing(with: firestoreManager.getUsername(), completion: { following in
                DispatchQueue.main.async {
                    self.postsArrayOthers = []
                }
                following.forEach { username in
                    self.firestoreManager.fetchPostsFromSubCollection(with: username) { posts in
                        DispatchQueue.main.async {
                            self.postsArrayOthers.append(contentsOf: posts)
                            posts.forEach { post in
                                self.checkIsLiked(postID: post.id, userID: post.username)
                                self.countingLike(postID: post.id, userID: post.username)
                                self.fetchProfileImage(post.username)
                            }
                        }
                    }
                }
                
            })
        }
    }
    
//    func fetchProfileImage(_ username: String) -> UIImage?{
//        if let profileUser = ProfileViewModel.shared.getProfileUser(for: username) {
//            if let imageData = profileUser.profileImage {
//                return UIImage(data: imageData)
//            }
//        }
//        return nil
//    }
    
    func fetchProfileImage(_ username: String){
        firestoreManager.fetchImage(username: username) { image in
            DispatchQueue.main.async {
                self.profileImage[username] = image
            }
        }
//        if let profileUser = ProfileViewModel.shared.getProfileUser(for: username) {
//            if let imageData = profileUser.profileImage {
//                return UIImage(data: imageData)
//            }
//        }
//        return nil
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
    
    func checkIsLiked(postID: String, userID: String){
//        let currentState = isLiked[postID] ?? false
//        isLiked[postID] = !currentState
//        DispatchQueue.global().async {
//            self.firestoreManager.fetchPostLikes(postID: postID, userID: userID) { likes in
//                print("userID \(userID) likes \(likes)")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Slight delay to batch updates
//                    // Check if current user has liked the post
//                    //                let userID = self.firestoreManager.getUsername()
//                    self.isLiked[postID] = likes
//                }
//            }
//        }
        
        firestoreManager.fetchPostLikes(postID: postID, userID: userID) { likes in
            print("userID \(userID) likes \(likes)")
            DispatchQueue.main.async {
                self.isLiked[postID] = likes
            }
        }
    }
    
    func countingLike(postID: String, userID: String){
        firestoreManager.countingLike(postID: postID, userID: userID) { likes in
            DispatchQueue.main.async {
                self.likeCount[postID] = likes
            }
        }
    }
}
