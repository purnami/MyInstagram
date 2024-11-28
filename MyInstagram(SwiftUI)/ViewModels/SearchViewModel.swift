//
//  SearchViewModel.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 23/11/24.
//
import SwiftUI

final class SearchViewModel : ObservableObject {
    @Published var keyword = ""
    @Published var searchResults: [ProfileUser] = []
    private let firestoreManager = FirestoreManager()
    
    func fetchAllUsers() {
        firestoreManager.fetchAllUsers { users in
            if users.isEmpty {
                print("No users found.")
            } else {
                print("Users array: \(users)")
            }
        }
    }
    
    func fetchUsers(){
        guard !keyword.isEmpty else {
            print("keyword.isEmpty")
            DispatchQueue.main.async {
                self.searchResults = []
            }
            return
        }
        
        Task {
            let fetchedUsers = await firestoreManager.fetchUsers(with: keyword)
            if fetchedUsers.isEmpty {
                print("No users found.")
            } else {
                print("Users array: \(fetchedUsers)")
            
                DispatchQueue.main.async {
                    self.searchResults = fetchedUsers
                }
            }
//            self.users = fetchedUsers
        }
        
//        firestoreManager.fetchUsers(with: keyword) { users in
//            print("keyword ", self.keyword)
//            if users.isEmpty {
//                print("No users found.")
//            } else {
//                print("Users array: \(users)")
//            
//                DispatchQueue.main.async {
//                    self.searchResults = users
//                }
//            }
//        }
    }
}
