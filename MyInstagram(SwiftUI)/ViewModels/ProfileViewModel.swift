//
//  ProfileViewModel.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 21/11/24.
//
import SwiftUI
import FirebaseAuth
import PhotosUI

final class ProfileViewModel : MainViewModel {
    static let shared = ProfileViewModel()
    
    @Published var selectedTab = 0
    @Published var photosPickerItem : PhotosPickerItem?
    @Published var postsArray: [Post] = []
    @Published var postsArrayOthers: [Post] = []
    @Published var followersArray: [String] = []
    @Published var followersArrayOthers: [String] = []
    @Published var followingArray: [String] = []
    @Published var followingArrayOthers: [String] = []
    @Published var menuButtonClicked = false
    @Published var navigateToLoginView = false
    @Published var isFollowing = false
    @Published var isLoadImage = false
    
    override init() {
        super.init()
        fetchUsername()
        fetchProfileImage(username)
        fetchPosts()
        
    }
    
    func fetchPosts(){
        Task {
            firestoreManager.fetchPosts(with: username) { posts in
                DispatchQueue.main.async {
                    self.postsArray = posts
                }
            }
        }
    }
    
    func fetchPosts(username : String){
        Task {
            firestoreManager.fetchPosts(with: username) { posts in
                DispatchQueue.main.async {
                    self.postsArrayOthers = posts
                }
            }
        }
    }
    
    func fetchFollowers(){
        Task {
            firestoreManager.fetchFollowers(with: username, completion: { followers in
                DispatchQueue.main.async {
                    self.followersArray = followers
                }
            })
        }
    }
    
    func fetchFollowers(username : String){
        Task {
            firestoreManager.fetchFollowers(with: username, completion: { followers in
                DispatchQueue.main.async {
                    self.followersArrayOthers = followers
                    
                    self.isFollowing = followers.contains(self.username)
                    followers.forEach { user in
                        print("followers.forEach ",user)
                    }
                    print(self.isFollowing)
                }
            })
        }
    }
    
    func fetchFollowing(){
        Task {
            firestoreManager.fetchFollowing(with: username, completion: { following in
                DispatchQueue.main.async {
                    self.followingArray = following
                }
            })
        }
    }
    
    func fetchFollowing(username : String){
//        print("fetchFollowing(username : String)")
        Task {
            firestoreManager.fetchFollowing(with: username, completion: { following in
                DispatchQueue.main.async {
                    self.followingArrayOthers = following
                }
            })
        }
    }
    
    func handlePhotoSelection(_ newValue: PhotosPickerItem?) async {
        if let newValue,
           let data = try? await newValue.loadTransferable(type: Data.self){
            if let image = UIImage(data: data) {
                saveProfileImage(image: image)
//                DispatchQueue.main.async {
////                    self.profileImage = image
//                    self.saveProfileImage(image: image)
//                }
            }
        }
        DispatchQueue.main.async {
            self.photosPickerItem = nil
        }
    }
    
    func saveProfileImage(image: UIImage?){
//        guard let imageData = image?.jpegData(compressionQuality: 0.8) else {
//            print("Failed to convert image to data.")
//            return
//        }
        
        DispatchQueue.main.async {
            self.isLoadImage = true
        }
        
        firestoreManager.saveImage(image: image!) { isSuccess in
            if isSuccess {
                self.fetchImage(self.username)
            }else{
                self.isLoadImage = false
            }
        }
        
//        let profileUser = ProfileUser()
//        profileUser.username = self.username
//        profileUser.profileImage = imageData
        
//        saveProfileUser(profileUser)
    }
    
    func saveProfileImage(username: String, image: UIImage?){
//        guard let imageData = image?.jpegData(compressionQuality: 0.8) else {
//            print("Failed to convert image to data.")
//            return
//        }
        
//        let profileUser = ProfileUser()
//        profileUser.username = username
//        profileUser.profileImage = imageData
        
        
        
//        saveProfileUser(profileUser)
    }
    
    //Save or Update Function: Create a function to add a new ProfileUser or update an existing one.
//    func saveProfileUser(_ newProfileUser: ProfileUser) {
//        // Fetch current list
//        var profileUsers: [ProfileUser] = fetchProfileUsers()
//
//        // Check if the user already exists
//        if let index = profileUsers.firstIndex(where: { $0.username == newProfileUser.username }) {
//            // Update the existing user's profile image
//            profileUsers[index] = newProfileUser
//        } else {
//            // Add the new user
//            profileUsers.append(newProfileUser)
//        }
//
//        // Save back to UserDefaults
//        do {
//            let encodedData = try JSONEncoder().encode(profileUsers)
//            UserDefaults.standard.set(encodedData, forKey: "ProfileUsers")
//            print("ProfileUser \(newProfileUser.username) saved successfully!!")
//            
//        } catch {
//            print("Error encoding ProfileUsers: \(error)")
//        }
//    }
//
//    //Fetch All Profile Users: Add a helper function to fetch the list.
//    func fetchProfileUsers() -> [ProfileUser] {
//        guard let savedData = UserDefaults.standard.data(forKey: "ProfileUsers") else {
//            return []
//        }
//        do {
//            return try JSONDecoder().decode([ProfileUser].self, from: savedData)
//        } catch {
//            print("Error decoding ProfileUsers: \(error)")
//            return []
//        }
//    }
//    
//    //Get Specific User Profile: Add a function to fetch the profile of a specific user.
//    func getProfileUser(for username: String) -> ProfileUser? {
//        let profileUsers = fetchProfileUsers()
//        return profileUsers.first(where: { $0.username == username })
//    }
//    
//    func fetchProfileImage(_ username: String){
//        if let profileUser = getProfileUser(for: username) {
//            if let imageData = profileUser.profileImage {
//                self.profileImage = UIImage(data: imageData)
//                print("Profile image loaded.")
//            }
//        }
//    }
    
    func signOut(){
        firestoreManager.signOutUser { isSuccess in
            if isSuccess {
                print("User logged out successfully")
                DispatchQueue.main.async {
                    self.navigateToLoginView = true
                }
            } else {
                print("Failed to log out")
            }
        }
    }
    
    func fetchFollow(username: String){
        firestoreManager.addFollow(username: username) { isSuccess in
            if isSuccess {
                print("Follow successfully")
                self.fetchFollowers(username: username)
                DispatchQueue.main.async {
                    self.isFollowing = true
                }
            } else {
                print("Failed to follow")
            }
        }
    }
    
//    override func fetchProfileImage(_ username: String) {
//        firestoreManager.fetchImage(username:username) { image in
//            DispatchQueue.main.async {
//                self.profileImage[username] = image
//                self.isLoadImage = false
//            }
//        }
//    }
    func fetchImage(_ username: String){
        firestoreManager.fetchImage(username:username) { image in
            DispatchQueue.main.async {
                self.profileImage[username] = image
                self.isLoadImage = false
            }
        }
    }
    
    func fetchProfileData(_ fromSearchView : Bool, username : String){
        if fromSearchView {
//            print("viewModel.fetchPosts(username: \(username))")
            fetchPosts(username: username)
            fetchFollowers(username: username)
            fetchFollowing(username: username)
        }else{
            fetchPosts()
            fetchFollowers()
            fetchFollowing()
        }
    }
}
