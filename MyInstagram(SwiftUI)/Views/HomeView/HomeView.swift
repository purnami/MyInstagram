//
//  HomeView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//
import SwiftUI
import Kingfisher
import AVKit

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.postsArrayOthers.sorted(by: { $0.datePost > $1.datePost })) { post in
                        PostView(post: post, from : "HomeView")
                            .padding(.horizontal)
                    }
                }
                .padding(.top) 
            }
            .refreshable {
                viewModel.fetchPostFromFollowingUser()
            }
        }
    }
    
}

#Preview {
    HomeView()
}

struct VideoPlayerView: View {
    let videoURL: URL
    @State private var player: AVPlayer?
    
    var body: some View {
        VideoPlayer(player: player)
//            .frame(width: UIScreen.main.bounds.width, height: 250)
//            .cornerRadius(12)
//            .shadow(radius: 5)
            .onAppear {
                // Initialize the player and play the video
                player = AVPlayer(url: videoURL)
                player?.play()
                print("Playing video from URL: \(videoURL)")
            }
            .onDisappear {
                // Stop the player when view disappears
                player?.pause()
                player = nil
            }
    }
}
