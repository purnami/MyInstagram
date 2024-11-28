//
//  UserNameTextField.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 14/11/24.
//

import SwiftUI

struct UserNameTextField: View {
    @Binding var userName: String
    var placeholder: String
    var showPlaceholder : Bool = true
    var showCheckMark : Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if !userName.isEmpty && showPlaceholder {
                Text(placeholder)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .transition(.opacity)
            }
            
            HStack {
                TextField(userName.isEmpty ? placeholder : "", text: $userName)
                    .background(Color.clear)
                    .frame(height: 37)
                    .onChange(of: userName) {
                        if !userName.isEmpty && userName.first?.isUppercase == true {
                            userName = userName.lowercased()
                        }
                    }
                if showCheckMark {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                }
            }
        }
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.2), value: userName.isEmpty)
    }
}

#Preview {
    UserNameTextField(userName: .constant(""), placeholder: "Username, Email, or Phone Number")
}
