//
//  HomeView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the Home Page!")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            .navigationTitle("Home") // Set the navigation title
        }
    }
}

