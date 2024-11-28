//
//  LoginViewModel.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 20/11/24.
//
import SwiftUI

final class LoginViewModel : ObservableObject {
    @Published var user : User = User(username: "", password: "")
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var navigateToContentView = false
    
    private let firestoreManager = FirestoreManager()
    
    func checkIsUserLogin(){
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            navigateToContentView = true
        }
    }
    
    func handleLogin() {
        if user.username.isEmpty {
            showAlert(with: "Please enter your username.")
        } else if user.password.isEmpty {
            showAlert(with: "Please enter your password")
        } else {
            isLoading = true
            performLogin()
        }
    }
    
    func showAlert(with message : String){
        alertMessage = message
        showAlert = true
    }
    
    func performLogin() {
        print("Username: \(user.username)")
        print("Password: \(user.password)")
        firestoreManager.signInUser(username: user.username, password: user.password) { [weak self] successLogin in
            if successLogin {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self?.navigateToContentView = true
            }else {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.showAlert(with: "Login Failed")
                }
            }
        }
    }
}
