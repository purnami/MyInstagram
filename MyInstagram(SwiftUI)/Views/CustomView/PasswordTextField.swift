//
//  PasswordTextField.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 14/11/24.
//

import SwiftUI

struct PasswordTextField: View {
    @Binding var password: String
    @State private var isPasswordVisible: Bool = false
    var placeholder: String
    var showPlaceholder : Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if !password.isEmpty && showPlaceholder {
                Text(placeholder)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .transition(.opacity)
            }
            HStack{
                if isPasswordVisible {
                    TextField("Enter your password", text: $password)
                        .autocapitalization(.none)
                        .textContentType(.password)
                        .onChange(of: password) {
                            if !password.isEmpty && password.first?.isUppercase == true {
                                password = password.lowercased()
                            }
                        }
                } else {
                    SecureField("Enter your password", text: $password)
                        .autocapitalization(.none)
                        .textContentType(.password)
                }
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 37)
        }
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.2), value: password.isEmpty)
    }
}

#Preview {
    PasswordTextField(password: .constant(""), placeholder: "Password")
}
