//
//  ContentView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userViewModel = UserViewModel()
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                }
            AddView()
                .tabItem {
                    Image(systemName: "plus")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
