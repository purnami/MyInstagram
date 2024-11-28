//
//  RegisterView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 16/11/24.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                headerView()
                
                if viewModel.isEnteringPassword {
                    passwordInputSection()
                } else {
                    usernameInputSection()
                }
                
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 30)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $viewModel.navigateToContentView) {
                ContentView()
            }
        }
    }
    
    private func headerView() -> some View {
        VStack(alignment: .center, spacing: 20) {
            if viewModel.isEnteringPassword {
                text(text1: "Craete Password", text2: "For security reasons, passwords must consist of 6 characters or more")
            } else {
                text(text1: "Select Username", text2: "You can always change it later")
            }
        }
    }
    
    private func usernameInputSection() -> some View {
        VStack(spacing: 20) {
            UserNameTextField(userName: $viewModel.user.username, placeholder: "Username", showPlaceholder: false, showCheckMark: viewModel.showCheckMark)
                .onChange(of: viewModel.user.username) { 
                    viewModel.checkUsernameAvailability()
                }
            
            nextButton(action: { viewModel.isEnteringPassword = true }, isDisable: !viewModel.showCheckMark)
        }
    }
    
    private func passwordInputSection() -> some View {
        VStack(spacing: 20) {
            PasswordTextField(password: $viewModel.user.password, placeholder: "Password", showPlaceholder: false)
            nextButton(action: {
                viewModel.registerUser()
            }, isDisable: viewModel.user.password.isEmpty)
        }
    }
    
    private func nextButton(action: @escaping () -> Void, isDisable : Bool) -> some View {
        Button(action: action) {
            Text("Next")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(isDisable ? Color.blue.opacity(0.5) : Color.blue)
                .cornerRadius(10)
        }
        .disabled(isDisable)
    }
    
    private func text(text1 : String, text2 : String) -> some View {
        VStack(alignment: .center, spacing: 20) {
            Text(text1)
                .font(.system(size: 35))
                .padding(.top)
            Text(text2)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    RegisterView()
}
