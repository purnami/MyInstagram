//
//  ContentView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: Int = 0

        var body: some View {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(0)
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                    }
                    .tag(1)
                
                AddView()
                    .tabItem {
                        Image(systemName: "plus.app")
                    }
                    .tag(2)
                
//                ProfileView(showProfileView: .constant(false), profileUser: .constant(ProfileUser()))
                ProfileView(showProfileView: .constant(false))
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                    }
                    .tag(3)
            }
            .accentColor(.black)
            .navigationBarBackButtonHidden(true)
        }
}

#Preview {
    ContentView()
}
