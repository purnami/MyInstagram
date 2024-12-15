//
//  HomeView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//
import SwiftUI
import Kingfisher
import AVKit
import PhotosUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                storiesHeader
                postsFeed
            }
            .onAppear {
                viewModel.fetchProfileImage(viewModel.username)
                viewModel.fetchPostFromFollowingUser()
                viewModel.fetchStoriesFromFollowingUser()
            }
        }
    }
    
    // MARK: - Stories Header
    private var storiesHeader: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                storyItem(for: viewModel.username, stories: viewModel.storiesArray)
                
                ForEach(viewModel.userFollowing, id: \.self) { username in
                    
                    if let stories = viewModel.storiesArrayOthers[username], !stories.isEmpty {
                        navigationLinkForStory(username: username, stories: stories)
                            .padding(.horizontal, 10)
                    }
                    
                }
            }
            .padding(.vertical, 20)
            .padding(.leading, 20)
        }
    }
    
    // MARK: - Story Item View
    private func storyItem(for username: String, stories: [Story]) -> some View {
        ZStack{
            if stories.isEmpty {
                photosPickerButton
                .zIndex(0)
                
                Image("add")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                .zIndex(1) // Ensure the button is above the image
                .frame(width: 90, height: 90, alignment: .bottomTrailing)
            }else {
                navigationLinkForStory(username: username, stories: stories)
                .zIndex(0)
                
                PhotosPicker(selection: $viewModel.photosPickerItem, matching: .images) {
                    Image("add")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                }
                .zIndex(1) // Ensure the button is above the image
                .frame(width: 90, height: 90, alignment: .bottomTrailing)
            }
            
            if viewModel.isLoadStory {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.trailing, 10)
        .frame(width: 80, height: 80)
        .onChange(of: viewModel.photosPickerItem) { _, newValue in
            Task {
                if let newValue = newValue {
                    print("PhotosPicker triggered with selection: \(newValue)")
                    await viewModel.handleStorySelection(newValue)
                } else {
                    print("No image selected or operation canceled.")
                }
            }
        }
    }
    
    // MARK: - Photos Picker Button
    private var photosPickerButton: some View {
        PhotosPicker(selection: $viewModel.photosPickerItem, matching: .images){
            Image(uiImage : viewModel.profileImage[viewModel.username] ?? UIImage(systemName: "person.crop.circle.fill")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color(hex: "#EEEDEB"), lineWidth: 1)
                )
                
        }
    }
    
    // MARK: - Navigation Link for Story
    private func navigationLinkForStory(username: String, stories : [Story]) -> some View {
        NavigationLink(destination: StoryView(viewModel: viewModel, stories: stories)) {
            Image(uiImage: viewModel.profileImage[username] ?? UIImage(systemName: "person.crop.circle.fill")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.red, Color.orange, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .topTrailing
                            ),
                            lineWidth: 4
                        )
                        .padding(-6)
                )
                
        }
    }
    
    private var postsFeed: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.postsArrayOthers.sorted(by: { $0.datePost > $1.datePost })) { post in
                    PostView(viewModel: viewModel, post: post, from : "HomeView")
                        .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .refreshable {
            viewModel.fetchPostFromFollowingUser()
            viewModel.fetchStoriesFromFollowingUser()
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
