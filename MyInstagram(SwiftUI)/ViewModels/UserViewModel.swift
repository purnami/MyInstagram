//
//  UserViewModel.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//

import Foundation
import Combine

class UserViewModel : ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    
    
//    func fetchUsers() {
//            self.isLoading = true
//            self.errorMessage = nil
//            
//            // Simulated API call (fake delay and response)
//        Dispatch.DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
//                let fetchedUsers = [
//                    User(id: 1, name: "John Doe", email: "john.doe@example.com"),
//                    User(id: 2, name: "Jane Smith", email: "jane.smith@example.com"),
//                    User(id: 3, name: "Sam Johnson", email: "sam.johnson@example.com")
//                ]
//                
//                DispatchQueue.main.async {
//                    self.users = fetchedUsers
//                    self.isLoading = false
//                }
//            }
//        }
//    
//    let workItem = DispatchWorkItem {
//        print("This is the delayed work item being executed.")
//    }
//
//    // Execute the work item after a 2-second delay
//    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: workItem)
}
