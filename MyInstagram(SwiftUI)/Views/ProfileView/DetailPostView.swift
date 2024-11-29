//
//  DetailPostView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 28/11/24.
//

import SwiftUI
import Kingfisher

struct DetailPostView: View {
//    @StateObject private var viewModel = ProfileViewModel()
    @ObservedObject var viewModel : ProfileViewModel
    @Binding var showDetailPost: Bool
    let selectedPost: Post?
    var fromSearchView = false
    var profileUser = ProfileUser()
    
    var body: some View {
        VStack {
            HStack {
                backButton
                Text("Posts")
                    .font(.system(size: 25, weight: .medium))
                    .padding(.leading, 20)
                Spacer()
            }
            ScrollViewReader { proxy in
                ScrollView {
                    let posts = fromSearchView ? viewModel.postsArrayOthers : viewModel.postsArray
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(posts.sorted(by: { $0.datePost > $1.datePost })) { post in
                            PostView(post: post, from: "DetailPostView", fromSearchView: fromSearchView, profileUser: profileUser)
                                .padding(.horizontal)
                                .id(post.id)
                        }
                    }
                    .padding(.top)
                }
                
                .onAppear {
                    print("Selected Post: \(String(describing: selectedPost))")
                    guard let selectedPost = selectedPost else {
                        print("Selected Post is nil")
                        return
                    }

                    let posts = fromSearchView ? viewModel.postsArrayOthers : viewModel.postsArray
                    
                    if let postToScrollTo = posts.first(where: {
                        $0.id == selectedPost.id
                    }) {
                        DispatchQueue.main.async {
                            print("Scrolling to Post: \(postToScrollTo.id)")
                            proxy.scrollTo(postToScrollTo.id, anchor: .top)
                        }
                    } else {
                        print("Post not found in postsArray")
                    }
                }
                
            }
        }
    }
    
    private var backButton : some View {
        Image(systemName: "arrow.left")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .padding(.leading, 20)
            .onTapGesture {
                showDetailPost = false
            }
        
    }
    
}
