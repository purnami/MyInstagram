//
//  FirestoreManager.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//

import FirebaseFirestore
import Combine
import FirebaseAuth

class FirestoreManager: ObservableObject {
    private var db = Firestore.firestore()
    
    func addPost(url : String, type : String, caption : String, completion: @escaping (Bool) -> Void) {
        let username = getUsername()
        let documentRef = db.collection("data").document(username).collection("posts").document()
        let newPost = Post(
                id: documentRef.documentID,  // Use Firestore's auto-generated ID
                username: username,
                postUrl: url,
                postType: type,
                caption: caption,
                datePost: Date(),
                like: [],
                comment: [:]
            )
        do {
            try documentRef.setData(from: newPost) { error in
                if let error = error {
                    print("Error adding post: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Post added successfully with auto-generated ID: \(newPost.id)")
                    completion(true)
                }
            }
        } catch {
            print("Error encoding post: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func addStory(image: UIImage, completion: @escaping (Bool) -> Void) {
        let username = getUsername()
        
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            print("Failed to convert image to data.")
            completion(false)
            return
        }
        
        let base64ImageString = imageData.base64EncodedString()
        let documentRef = db.collection("data").document(username).collection("stories").document()
        
        let newStory = Story(
            id: documentRef.documentID,
            username: username,
            storyImage: base64ImageString,
            datePost: Date())
        
        do {
            try documentRef.setData(from: newStory) { error in
                if let error = error {
                    print("Error adding story: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("story added successfully with auto-generated ID: \(newStory.id)")
                    completion(true)
                }
            }
        } catch {
            print("Error encoding story: \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    func addFollow(username : String, completion: @escaping (Bool) -> Void) {
        let following = db.collection("data").document(getUsername()).collection("following").document()
        let followers = db.collection("data").document(username).collection("followers").document()
        
        following.setData([
            "following" : username
        ]) { error in
            if let error = error {
                print("Error following: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Success following \(username)")
                followers.setData([
                    "followers" : self.getUsername()
                ]) { error in
                    if let error = error {
                        print("Error add followers: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Success add followers \(self.getUsername())")
                        completion(true)
                    }
                }
            }
        }
    }
    
    func fetchPosts(with username: String, completion: @escaping ([Post]) -> Void) {
        guard !username.isEmpty else {
            print("Error: Username is empty.")
            completion([]) // Return an empty array to avoid crashes.
            return
        }
        db.collection("data").document(username).collection("posts").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                completion([])
                return
            }
            
            if let documents = snapshot?.documents {
                do {
                    let posts = try documents.map { document -> Post in
                        return try document.data(as: Post.self)
                    }
//                    print("Retrieved posts:", posts)
                    completion(posts)
                } catch {
                    print("Error decoding posts: \(error.localizedDescription)")
                    completion([])
                }
            } else {
                print("No posts found")
                completion([])
            }
        }
    }
    
    func fetchStories(with username: String, completion: @escaping ([Story]) -> Void) {
        guard !username.isEmpty else {
            print("Error: Username is empty.")
            completion([]) // Return an empty array to avoid crashes.
            return
        }
        db.collection("data").document(username).collection("stories").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching stories: \(error.localizedDescription)")
                completion([])
                return
            }
            
            if let documents = snapshot?.documents {
                do {
                    let stories = try documents.map { document -> Story in
                        return try document.data(as: Story.self)
                    }
                    print("Retrieved stories:", stories)
                    completion(stories)
                } catch {
                    print("Error decoding stories: \(error.localizedDescription)")
                    completion([])
                }
            } else {
                print("No stories found")
                completion([])
            }
        }
    }
    
    func fetchFollowers(with username: String, completion: @escaping ([String]) -> Void) {
        guard !username.isEmpty else {
            print("Error: Username is empty.")
            completion([])
            return
        }
        db.collection("data").document(username).collection("followers").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching followers: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No followers found")
                completion([])
                return
            }
            
            let followers = documents.compactMap { document in
//                print("document.documentID: \(document.documentID)")
                if let value = document.data()["followers"] as? String {
//                    print("Field value: \(value)")
                    return value
                }
                return nil
            }
            print("Retrieved followers:", followers)
            completion(followers)
        
        }
    }
    
    func fetchFollowing(with username: String, completion: @escaping ([String]) -> Void) {
        guard !username.isEmpty else {
            print("Error: Username is empty.")
            completion([])
            return
        }
        db.collection("data").document(username).collection("following").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching following: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No following found")
                completion([])
                return
            }
            
            let following = documents.compactMap { document in
//                print("document.documentID: \(document.documentID)")
                if let value = document.data()["following"] as? String {
//                    print("Field value: \(value)")
                    return value
                }
                return nil
            }
            print("Retrieved following:", following)
            completion(following)
            
            
        }
    }
    
    func registerUser(username: String, password: String, completion: @escaping (Bool) -> Void) {
        let email = "\(username)@example.com"
        print("email : \(email)")
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Registration Error: \(error.localizedDescription)")
                completion(false)
            } else {
                print("User created successfully")
                self.db.collection("users").document(username).setData([
                    "email": email
                ]) { error in
                    if let error = error {
                        print("Error saving username: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Username saved successfully")
                        completion(true)
                    }
                }
            }
        }
    }
    
    func signInUser(username: String, password: String, completion: @escaping (Bool) -> Void) {
        let email = "\(username)@example.com" // Simulate an email using the username
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login Error: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Login Successful")
                completion(true)
            }
        }
    }
    
    func signOutUser(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut() // Sign out from Firebase Auth
            UserDefaults.standard.removeObject(forKey: "isLoggedIn")
            completion(true)
        } catch let signOutError as NSError {
            print("SignOut Error: \(signOutError.localizedDescription)")
            completion(false)
        }
    }
    
    func checkIfUsernameExists(username: String, completion: @escaping (Bool) -> Void) {
        
        guard !username.isEmpty else {
            completion(false)
            return
        }

        let db = Firestore.firestore()
        
        db.collection("users").document(username).getDocument { snapshot, error in
            if let error = error {
                print("Error checking username: \(error.localizedDescription)")
                completion(false)
            } else {
                if let snapshot = snapshot, snapshot.exists {
                    completion(true) // Username already exists
                } else {
                    completion(false) // Username is available
                }
            }
        }
    }
    
    func getUsername() -> String {
        if let email = Auth.auth().currentUser?.email {
            let username = String(email.split(separator: "@").first ?? "")
            return username
        }
        print("Error: Username not found in UserDefaults.")
        return ""
    }
    
    func searchUsers(completion: @escaping ([String]) -> Void) {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                completion([])
                return
            }
                    
            guard let documents = snapshot?.documents else {
                print("No users found")
                completion([])
                return
            }
            
            let userNames = documents.map { $0.documentID }
                    
            print("Retrieved users: \(userNames)")
            completion(userNames)
        }
    }

    func fetchAllUsers(completion: @escaping ([String]) -> Void) {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No users found")
                completion([])
                return
            }
            
            // Extract document IDs (usernames)
            let userNames = documents.map { $0.documentID }
            
            print("Retrieved users: \(userNames)")
            completion(userNames)
        }
    }
    
//    func fetchUsers(with keyword: String, completion: @escaping ([ProfileUser]) -> Void) {
//        let userLogin = getUsername()
//        let searchKeyword = keyword.lowercased()
//
//    }

    func fetchUsers(with keyword: String) async -> [ProfileUser] {
        print(keyword)
        let userLogin = getUsername()
        let searchKeyword = keyword.lowercased()

        do {
            // Fetch the documents asynchronously
            let snapshot = try await db.collection("users").getDocuments()

            // Directly access `snapshot.documents` without conditional binding
            let documents = snapshot.documents
            
            if documents.isEmpty {
                print("No users found")
                return []
            }

            var profileUsers: [ProfileUser] = []

            // Create a task group to fetch images concurrently
            await withTaskGroup(of: (String, UIImage?).self) { group in
                for document in documents {
                    let username = document.documentID
                    print("usernameee \(username)")
                    
                    group.addTask {
                        let image = await self.fetchImage(username: username)
                        return (username, image)
                    }
                }

                // Wait for all tasks to complete and add users to the profileUsers array
                for await (username, profileImage) in group {
                    let profileUser = ProfileUser()
                    profileUser.username = username
                    profileUser.profileImage = profileImage
                    profileUsers.append(profileUser)
                }
            }

            // Filter users based on the search keyword
            let filteredUsers = profileUsers.filter { profileUser in
                print("filteredUsers \(profileUser.username)")
                return profileUser.username.lowercased().contains(searchKeyword) && profileUser.username != userLogin
            }

            return filteredUsers
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
            return []
        }
    }

//    func fetchUsers(with keyword: String, completion: @escaping ([ProfileUser]) -> Void) {
//        print(keyword)
//        let userLogin = getUsername()
//        let searchKeyword = keyword.lowercased()
//
//        db.collection("users")
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error fetching users: \(error.localizedDescription)")
//                    completion([])
//                    return
//                }
//                
//                guard let documents = snapshot?.documents else {
//                    print("No users found")
//                    completion([])
//                    return
//                }
//                
//                var profileUsers: [ProfileUser] = []
//                    
//                // Loop through each document and fetch the images asynchronously
//                for document in documents {
//                    let username = document.documentID
//                    print("usernameee \(username)")
//                    
//                    // Fetch the image asynchronously
////                    if let profileImage = await self.fetchImage(username: username, completion: { image in
////                        <#code#>
////                    })
//                    if let profileImage = await fetchImage(username: username) {
//                        let profileUser = ProfileUser()
//                        profileUser.username = username
//                        profileUser.profileImage = profileImage
//                        profileUsers.append(profileUser)
//                    }
//                }
//                
////                let profileUsers = documents.compactMap { document -> ProfileUser? in
////                    let username = document.documentID
////                    print("usernameee \(username)")
//////                    let profileUser = ProfileViewModel.shared.getProfileUser(for: username)
////                    var profileImage : UIImage?
////                    self.fetchImage(username: username) { image in
////                        print("fetchImage ", image)
////                        profileImage = image
////                    }
////                    let profileUser = ProfileUser()
////                    profileUser.username = username
////                    profileUser.profileImage = profileImage
//////                    print("profileUser \(profileUser?.username)")
////                    return profileUser
////                }
//                
//                let filteredUsers = profileUsers.filter { profileUser in
//                    print("filteredUsers \(profileUser.username)")
//                    return profileUser.username.lowercased().contains(searchKeyword) && profileUser.username != userLogin
//                }
//                
//                completion(filteredUsers)
//            }
//    }

    func likePost(postID: String, userID: String, completion: @escaping (Bool) -> Void) {
        let documentRef = db.collection("data").document(userID).collection("posts").document(postID)
        let username = getUsername()
        // Fetch the current document to check if the user has already liked the post
        documentRef.getDocument { document, error in
            if let document = document, document.exists {
                var likes = document.data()?["like"] as? [String] ?? []
                
                if likes.contains(username) {
                    // If user already liked, remove the like
                    likes.removeAll { $0 == username }
                } else {
                    // Otherwise, add the like
                    likes.append(username)
                }
                
                // Update the Firestore document
                documentRef.updateData(["like": likes]) { error in
                    if let error = error {
                        print("Error updating likes: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Likes updated successfully")
                        completion(true)
                    }
                }
            } else {
                print("Document does not exist or error fetching document: \(error?.localizedDescription ?? "")")
                completion(false)
            }
        }
    }
    
    func fetchPostLikes(postID: String, userID: String, completion: @escaping (Bool) -> Void) {
//        let postRef = db.collection("data").document(postID)
        let documentRef = db.collection("data").document(userID).collection("posts").document(postID)
        let username = getUsername()
        
        documentRef.getDocument { document, error in
            if let document = document, document.exists {
                let likes = document.data()?["like"] as? [String] ?? []
//                likes.forEach { like in
//                    print("like \(userID) ",like)
//                }
                if likes.contains(username) {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }
    
    func countingLike(postID: String, userID: String, completion: @escaping (Int) -> Void) {
        let documentRef = db.collection("data").document(userID).collection("posts").document(postID)
        let username = getUsername()
        
        documentRef.getDocument { document, error in
            if let document = document, document.exists {
                let likes = document.data()?["like"] as? [String] ?? []
                completion(likes.count)
            } else {
                print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                completion(0)
            }
        }
    }

//    func trySaveImage(image: Data){
//        print("trySaveImage")
//        db.collection("try").document(getUsername()).collection("image").document().setData([
//            "imagee": image
//        ]) { error in
//            print("trySaveImage 1")
//            if let error = error {
//                print("Error trySaveImage: \(error.localizedDescription)")
////                completion(false)
//            } else {
//                print("trySaveImage successfully")
////                completion(true)
//            }
//        }
////        db.collection("try").document("image")
//            
//    }
    
    func trySaveImage(image: UIImage) {
        print("trySaveImage")
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            print("Failed to convert image to data.")
            return
        }
        let base64ImageString = imageData.base64EncodedString()

        let documentRef = db.collection("try").document(getUsername()).collection("image").document("profileImage")
        documentRef.setData([
            "imageData": base64ImageString
        ]) { error in
            if let error = error {
                print("Error saving image: \(error.localizedDescription)")
            } else {
                print("Image saved successfully.")
            }
        }
    }
    
    func saveImage(image: UIImage, completion: @escaping (Bool) -> Void) {
        print("saveImage")
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            print("Failed to convert image to data.")
            completion(false)
            return
        }
        let base64ImageString = imageData.base64EncodedString()
        
//        let following = db.collection("data").document(getUsername()).collection("following").document()
        let documentRef = db.collection("data").document(getUsername())
        documentRef.setData([
            "profileImage": base64ImageString
        ]) { error in
            if let error = error {
                print("Error saving image: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Image saved successfully.")
                completion(true)
            }
        }
    }
    
    func tryFetchImage(completion: @escaping (UIImage?) -> Void) {
        db.collection("try").document(getUsername()).collection("image").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                completion(nil)
            } else if let document = snapshot?.documents.first,
                      let base64ImageString = document.data()["imageData"] as? String,
                      let imageData = Data(base64Encoded: base64ImageString) {
                let image = UIImage(data: imageData)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchImage(username: String) async -> UIImage? {
//        print("fetchImage username ", username)
        let snapshot = try? await db.collection("data").document(username).getDocument()
        
        if let snapshot = snapshot, snapshot.exists,
           let data = snapshot.data(),
           let base64String = data["profileImage"] as? String,
           let imageData = Data(base64Encoded: base64String),
           let image = UIImage(data: imageData) {
            // Successfully decoded the image
            return image
        } else {
            print("Image data not found or invalid.")
            return nil
        }
    }
    
    func fetchImage(username: String, completion: @escaping (UIImage?) -> Void) {
//        print("fetchImage username ", username)
        db.collection("data").document(username).getDocument { snapshot, error in
            
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                completion(nil)
            }
            else if let snapshot = snapshot, snapshot.exists,
                let data = snapshot.data(),
                let base64String = data["profileImage"] as? String,
                let imageData = Data(base64Encoded: base64String),
                let image = UIImage(data: imageData) {
                // Successfully decoded the image
                completion(image)
            }
            else {
                print("Image data not found or invalid.")
                completion(nil)
            }
        }
    }
    
    func deleteAllStories(completion: @escaping (Bool) -> Void) {
        let storiesCollection = db.collection("stories")
        
        storiesCollection.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching stories: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(true) // No documents to delete, so it's a success
                return
            }
            
            let batch = self.db.batch()
            
            for document in documents {
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { error in
                if let error = error {
                    print("Error deleting all stories: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }

    func deleteStory(username: String, documentID: String, completion: @escaping (Bool) -> Void) {
        let documentRef = db.collection("data").document(getUsername()).collection("stories").document(documentID)
        documentRef.delete { error in
            if let error = error {
                print("Error deleting story: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}



