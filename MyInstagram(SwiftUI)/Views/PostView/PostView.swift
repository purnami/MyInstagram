//
//  PostView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 28/11/24.
//

import SwiftUI
import Kingfisher

struct PostView: View {
    @ObservedObject var viewModel: MainViewModel
//    @ObservedObject var homeViewModel: HomeViewModel
//    @ObservedObject var profileViewModel = ProfileViewModel
    var post : Post
    var from : String
    var fromSearchView = false
//    @StateObject private var homeViewModel = HomeViewModel()
//    @StateObject private var profileViewModel = ProfileViewModel()
    var profileUser = ProfileUser()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            userHeaderView
            postContentView
            postActionsView
            likeCountView
            captionView
        }
        .onAppear {
            if from == "DetailPostView" {
//                homeViewModel.countingLike(postID: post.id, userID: post.username)
//                homeViewModel.checkIsLiked(postID: post.id, userID: post.username)
                viewModel.countingLike(postID: post.id, userID: post.username)
                viewModel.checkIsLiked(postID: post.id, userID: post.username)
            }
        }
    }
    
    private var userHeaderView : some View {
        HStack {
            if from == "HomeView" {
                profileImage(uiImage: (viewModel.profileImage[post.username] ?? UIImage(systemName: "person.crop.circle.fill"))!)
//                profileImage(uiImage: (homeViewModel.profileImage[post.username] ?? UIImage(systemName: "person.crop.circle.fill"))!)
            } else if from == "DetailPostView"{
                if fromSearchView {
                    profileImage(uiImage: (profileUser.profileImage ?? UIImage(systemName: "person.crop.circle.fill"))!)
                } else {
                    profileImage(uiImage: (viewModel.profileImage[viewModel.username] ?? UIImage(systemName: "person.crop.circle.fill"))!)
//                    profileImage(uiImage: (profileViewModel.profileImage[profileViewModel.username] ?? UIImage(systemName: "person.crop.circle.fill"))!)
                }
            }
            
            Text(post.username)
        }
    }
    
    private func profileImage(uiImage: UIImage?) -> some View {
        Image(uiImage: uiImage!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color(hex: "#EEEDEB"), lineWidth: 1)
            )
    }
    
    private var postContentView : some View {
        Group {
            if post.postType == "image" {
                KFImage(URL(string: post.postUrl))
                    .resizable()
                    .scaledToFit()
            }
            //            else if post.postType == "video" {
            //                VideoPlayerView(videoURL: URL(string: post.postUrl)!)
            //                    .frame(height: 250)
            //            }
        }
    }
    
    private var postActionsView : some View {
        HStack(spacing: 20) {
            likeButton
            imageButton("comment", size: 20)
            imageButton("send", size: 22)
            Spacer()
            imageButton("bookmark", size: 22)
        }
        
    }
    
    private func imageButton(_ imageName: String, size : CGFloat) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
    }
    
    private var likeButton : some View {
        Group {
//            let imageName = homeViewModel.isLiked[post.id] ?? false ? "like_red" : "like"
            let imageName = viewModel.isLiked[post.id] ?? false ? "like_red" : "like"
            imageButton(imageName, size: 22)
        }
        .onTapGesture {
            print("postID: \(post.id), userID: \(post.username)")
//            homeViewModel.likePostClicked(postID: post.id, userID: post.username)
            viewModel.likePostClicked(postID: post.id, userID: post.username)
        }
    }
    
    private var likeCountView : some View {
        HStack(spacing: 5) {
//            if let likeCount = homeViewModel.likeCount[post.id], likeCount != 0 {
            if let likeCount = viewModel.likeCount[post.id], likeCount != 0 {
                Text("\(likeCount)")
                Text(likeCount == 1 ? "like" : "likes")
            }
        }
    }
    
    private var captionView : some View {
        HStack {
            if !post.caption.isEmpty {
                Text(post.username)
                Text(post.caption)
            }
            
        }
    }
}

