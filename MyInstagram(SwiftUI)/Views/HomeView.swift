//
//  HomeView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//
import SwiftUI
import Kingfisher
import AVKit
//import FirebaseAuth
//import Firebase
//import UIKit

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.postsArrayOthers.sorted(by: { $0.datePost > $1.datePost })) { post in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(uiImage: (viewModel.profileImage[post.username] ?? UIImage(systemName: "person.crop.circle.fill"))!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(.circle)
                                    .overlay(
                                        Circle().stroke(Color(hex: "#EEEDEB"), lineWidth: 1)  // Change Color and lineWidth as needed
                                    )
                                Text(post.username)
                            }
                            if post.postType == "image" {
                                KFImage(URL(string: post.postUrl))
                                    .resizable()
                                    .scaledToFit()
                            } else if post.postType == "video" {
                                VideoPlayerView(videoURL: URL(string: post.postUrl)!)
                                    .frame(height: 250)
                            }
                            
                            HStack(spacing: 20) {
                                Group {
                                    let imageName = viewModel.isLiked[post.id] ?? false ? "like_red" : "like"
                                    Image(imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 22, height: 22)
                                }
                                .onTapGesture {
                                    viewModel.likePostClicked(postID: post.id, userID: post.username)
                                }
                                Image("comment")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 20, height: 20)
                                Image("send")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 22, height: 22)
                                Spacer()
                                Image("bookmark")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 22, height: 22)
                            }
                            
                            HStack(spacing: 5) {
                                if let likeCount = viewModel.likeCount[post.id], likeCount != 0 {
                                    Text("\(likeCount)")
                                    if likeCount == 1 {
                                        Text("like")
                                    }else {
                                        Text("likes")
                                    }
                                }
                            }
                            
                            HStack {
                                if !post.caption.isEmpty {
                                    Text(post.username)
                                    Text(post.caption)
                                }
                                
                            }
                        }
                        .padding(.horizontal)
//                        .onAppear {
//                            viewModel.checkIsLiked(postID: post.id, userID: post.username)
//                        }
                    }
                }
                .padding(.top) 
            }
            .refreshable {
                viewModel.fetchPostFromFollowingUser()
            }
//            .onAppear {
//                viewModel.fetchPostFromFollowingUser()
//                
//            }
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
