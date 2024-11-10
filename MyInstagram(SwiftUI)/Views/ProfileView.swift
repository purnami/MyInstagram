//
//  ProfileView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("User Profile Page")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
}
