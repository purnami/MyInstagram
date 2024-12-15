//
//  HomeViewModel.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 25/11/24.
//

import SwiftUI
import FirebaseAuth
import PhotosUI

final class HomeViewModel : MainViewModel {
    @Published var postsArrayOthers: [Post] = []
    @Published var storiesArrayOthers: [String : [Story]] = [:]
//    @Published var isLiked: [String: Bool] = [:]
//    @Published var likeCount : [String : Int] = [:]
    @Published var userFollowing: [String] = []
    @Published var storiesArray: [Story] = []
    @Published var photosPickerItem : PhotosPickerItem?
    @Published var isLoadStory = false
    
    override init() {
        super.init()
        fetchUsername()
        fetchPostFromFollowingUser()
        fetchProfileImage(username)
        fetchStories(username)
        fetchStoriesFromFollowingUser()
    }
    
    func fetchPostFromFollowingUser(){
        Task {
            firestoreManager.fetchFollowing(with: username){ following in
                DispatchQueue.main.async {
//                    self.postsArrayOthers = []
                    self.userFollowing = following
                }
                following.forEach { username in
                    self.firestoreManager.fetchPosts(with: username) { posts in
                        DispatchQueue.main.async {
                            // Filter out posts that are already in `postsArrayOthers`
                            let newPosts = posts.filter { newPost in
                                !self.postsArrayOthers.contains { existingPost in
                                    existingPost.id == newPost.id
                                }
                            }
                            
                            // Append only the new posts
                            self.postsArrayOthers.append(contentsOf: newPosts)
                            
                            // Perform additional actions on new posts
                            posts.forEach { post in
                                self.checkIsLiked(postID: post.id, userID: post.username)
                                self.countingLike(postID: post.id, userID: post.username)
                                self.fetchProfileImage(post.username)
                            }
                        }
                    }
                }
//                following.forEach { username in
//                    self.firestoreManager.fetchPosts(with: username) { posts in
//                        DispatchQueue.main.async {
//                            self.postsArrayOthers.append(contentsOf: posts)
//                            posts.forEach { post in
//                                self.checkIsLiked(postID: post.id, userID: post.username)
//                                self.countingLike(postID: post.id, userID: post.username)
//                                self.fetchProfileImage(post.username)
//                            }
//                        }
//                    }
//                }
            }
        }
    }
    
    func fetchStoriesFromFollowingUser(){
        print("fetchStoriesFromFollowingUser")
        Task {
            firestoreManager.fetchFollowing(with: username){ following in
                
                following.forEach { username in
                    print("fetchStoriesFromFollowingUser \(username)")
                    DispatchQueue.main.async {
                        if self.storiesArrayOthers[username] == nil {
                            self.storiesArrayOthers[username] = []
                        }
//                        self.storiesArrayOthers[username] = Story.init(id: <#T##String#>, username: <#T##String#>, storyImage: <#T##String#>, datePost: <#T##Date#>)
//                        self.storiesArrayOthers[username] = []
                    }
                    self.firestoreManager.fetchStories(with: username) { stories in
                        if !stories.isEmpty{
                            DispatchQueue.main.async {
                                let newStories = stories.filter { newStory in
                                    !self.storiesArrayOthers[username]!.contains { existingStory in
                                        existingStory.id == newStory.id
                                    }
                                }
                                
                                // Append only the new stories
                                self.storiesArrayOthers[username]?.append(contentsOf: newStories)

                                // Perform any additional actions on new stories
                                newStories.forEach { story in
                                    // Example actions like loading profile image, etc.
                                    self.fetchProfileImage(story.username)
                                }
//                                self.storiesArrayOthers[username] = (self.storiesArrayOthers[username] ?? []) + stories

//                                self.storiesArrayOthers[username].append(contentsOf: stories)
                                //                            stories.forEach { post in
                                //                                self.checkIsLiked(postID: post.id, userID: post.username)
                                //                                self.countingLike(postID: post.id, userID: post.username)
                                //                                self.fetchProfileImage(post.username)
                                //                            }
                            }
                        }else{
                            print("fetchStoriesFromFollowingUser \(username) empty")
                        }
                    }
                }
            }
        }
    }

//    func likePostClicked(postID: String, userID: String) {
//        // Toggle the local like state
//        let currentState = isLiked[postID] ?? false
//        isLiked[postID] = !currentState
//        
//        // Update the local likeCount immediately
//        if currentState {
//            likeCount[postID, default: 0] -= 1
//        } else {
//            likeCount[postID, default: 0] += 1
//        }
//        
//        // Update the Firestore
//        firestoreManager.likePost(postID: postID, userID: userID) { success in
//            if !success {
//                // Revert the local state if Firestore update failed
//                DispatchQueue.main.async {
//                    self.isLiked[postID] = currentState
//                    if currentState {
//                        self.likeCount[postID, default: 0] += 1
//                    } else {
//                        self.likeCount[postID, default: 0] -= 1
//                    }
//                }
//             
//            }
//        }
//    }
    
//    func checkIsLiked(postID: String, userID: String){
//        firestoreManager.fetchPostLikes(postID: postID, userID: userID) { likes in
//            DispatchQueue.main.async {
//                self.isLiked[postID] = likes
//            }
//        }
//    }
//    
//    func countingLike(postID: String, userID: String){
//        print("countingLike")
//        firestoreManager.countingLike(postID: postID, userID: userID) { likes in
//            DispatchQueue.main.async {
//                print("countingLike \(postID) \(likes)")
//                self.likeCount[postID] = likes
//            }
//        }
//    }
    
    func handleStorySelection(_ newValue: PhotosPickerItem?) async {
        print("handleStorySelection")
        if let newValue,
           let data = try? await newValue.loadTransferable(type: Data.self){
            if let image = UIImage(data: data) {
                addStory(image: image)
            }
        }
        DispatchQueue.main.async {
            self.photosPickerItem = nil
        }
    }
    
    func addStory(image: UIImage?){
        
        DispatchQueue.main.async {
            self.isLoadStory = true
        }
        
        firestoreManager.addStory(image: image!) { isSuccess in
            if isSuccess {
                print("successfully add story")
                self.fetchStories(self.username)
            }else{
                print("failed add story")
                self.isLoadStory = false
            }
        }
        
    }
    
    func fetchStories(_ username : String){
        print("fetchStories")
        firestoreManager.fetchStories(with: username) { stories in
            print("fetchStories \(stories)")
            DispatchQueue.main.async {
                if stories.isEmpty {
                    self.storiesArray = []
                }else {
                    self.storiesArray = stories.sorted { $0.datePost < $1.datePost }
                    self.isLoadStory = false
                }
            }
        }
    }
    
    func changeStringToUIImage(_ imageString : String) -> UIImage? {
        if let imageData = Data(base64Encoded: imageString){
            let image = UIImage(data: imageData)
            return image
        }else {
            return nil
        }
        
    }
    
    func deleteStory(username: String, documentID: String) {
        firestoreManager.deleteStory(username: username, documentID: documentID) { isSuccess in
            if isSuccess {
                print("Successfully deleted story")
                self.fetchStories(self.username) // Refresh stories
            } else {
                print("Failed to delete story")
            }
        }
    }
}
