//
//  PostView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 28/11/24.
//

import SwiftUI
import Kingfisher

struct PostView: View {
    var post : Post
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            userHeaderView
            postContentView
            postActionsView
            likeCountView
            captionView
        }
    }
    
    private var userHeaderView : some View {
        HStack {
            Image(uiImage: (viewModel.profileImage[post.username] ?? UIImage(systemName: "person.crop.circle.fill"))!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color(hex: "#EEEDEB"), lineWidth: 1)
                )
            Text(post.username)
        }
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
        
    }
    
    private var likeButton : some View {
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
    }
    
    private var likeCountView : some View {
        HStack(spacing: 5) {
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

