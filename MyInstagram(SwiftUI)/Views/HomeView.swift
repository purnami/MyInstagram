//
//  HomeView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//
import SwiftUI
import Kingfisher

struct HomeView: View {
    @StateObject private var firestoreManager = FirestoreManager()
    var body: some View {
        NavigationView {
//            VStack {
//                Text("Welcome to the Home Page!")
//                    .font(.largeTitle)
//                    .padding()
//                Spacer()
//            }
            List(firestoreManager.contents) { content in
                            VStack(alignment: .leading) {
                                Text(content.userName)
                                    .font(.headline)
                                KFImage(URL(string: content.postUrl))
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
            .onAppear {
                firestoreManager.loadContent()
            }
        }
    }
}

