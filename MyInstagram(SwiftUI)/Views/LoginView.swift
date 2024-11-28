//
//  LoginView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 11/11/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                logoView()
                
                Spacer()
                
                inputFields()
                loginButton()
                forgotPassword()
                
                Spacer()
                
                createAccountButton()
            }
            .padding()
            .background(Color(hex: "#eef7fe"))
            .alert(isPresented: $viewModel.showAlert, content: {
                Alert(title: Text("Input Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            })
            .onAppear {
                // Check if the user is already logged in
                viewModel.checkIsUserLogin()
            }
            .navigationDestination(isPresented: $viewModel.navigateToContentView) {
                ContentView()
            }
        }
    }
    
    private func logoView() -> some View {
        Image("instagram_logo")
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 60)
            .padding(.top)
    }
    
    private func inputFields() -> some View {
        VStack(spacing: 20) {
            UserNameTextField(userName: $viewModel.user.username, placeholder: "Username, Email, or Phone Number")
            PasswordTextField(password: $viewModel.user.password, placeholder: "Password")
        }
        .padding(.horizontal)
    }
    
    private func loginButton() -> some View {
        Button(action: viewModel.handleLogin) {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(width: 20, height: 20)
            } else {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 45)
                    .frame(maxWidth: .infinity)
            }
            
        }
        .frame(height: 45)
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(25)
        .padding(.horizontal)
    }
    
    private func forgotPassword() -> some View {
        Text("Forgot Password?")
    }
    
    private func createAccountButton() -> some View {
        NavigationLink(destination: RegisterView()) {
            Text("Create New Account")
                .font(.headline)
                .foregroundColor(.blue)
                .frame(height: 45)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#eef7fe"))
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.blue, lineWidth: 2)
                )
        }
        .padding(.horizontal)
        .disabled(viewModel.isLoading)
    }
}

#Preview {
    LoginView()
}




