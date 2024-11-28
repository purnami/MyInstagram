//
//  RegisterViewModel.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 20/11/24.
//
import SwiftUI

final class RegisterViewModel: ObservableObject {
    @Published var user: User = User(username: "", password: "")
    @Published var isEnteringPassword = false
    @Published var navigateToContentView = false
    @Published var showCheckMark = false
    
    private let firestoreManager = FirestoreManager()
    
    func checkUsernameAvailability(){
        
        print("user.username : \(user.username)")
        if user.username.isEmpty{
            print("username is empty")
            DispatchQueue.main.async {
                self.showCheckMark = false
            }
        }else{
            firestoreManager.checkIfUsernameExists(username: user.username) { [weak self] isExists in
                DispatchQueue.main.async {
                    print(isExists)
                    self?.showCheckMark = !isExists
                }
            }
        }
        
    }
    
    func registerUser() {
        firestoreManager.registerUser(username: user.username, password: user.password) { [weak self] success in
            guard let self = self else { return }
            if success {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                ProfileViewModel.shared.saveProfileImage(username: user.username, image: UIImage(systemName: "person.crop.circle.fill"))
                DispatchQueue.main.async {
                    self.navigateToContentView = true
                }
            } else {
                print("Registration failed.")
            }
        }
    }
}
