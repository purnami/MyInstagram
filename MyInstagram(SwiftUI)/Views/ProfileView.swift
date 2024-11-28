//
//  ProfileView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//

import SwiftUI
import FirebaseAuth
import Kingfisher
import PhotosUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    var fromSearchView = false
    @Binding var showProfileView: Bool
    @Binding var profileUser: ProfileUser
    
    let columns: [GridItem] = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    private let tabItems = [
        ("square.grid.3x3.fill"),
        ("play.rectangle"),
        ("person.crop.square.fill")
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                headerView()
                
                HStack() {
                    profileImageView()
                    statsView().padding(.leading, 20)
                }
                .padding(.horizontal, 20)
                
                actionButtonsView()
                
                tabSelectionView()
                
                TabView(selection: $viewModel.selectedTab) {
                    postGridView().tag(0)
                    Text("Search Content").tag(1)
                    Text("Profile Content").tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                Spacer()
            }
            .onChange(of: viewModel.photosPickerItem) { oldValue, newValue in
                Task {
                    await viewModel.handlePhotoSelection(newValue)
                }
            }
            .sheet(isPresented: $viewModel.menuButtonClicked) {
                MenuView(viewModel: viewModel)
            }
                    
            .navigationDestination(isPresented: $viewModel.navigateToLoginView) {
                LoginView()
                    .navigationBarBackButtonHidden(true)
            }
            .onAppear {
                viewModel.fetchProfileData(fromSearchView, username: profileUser.username)
            }
        }
    }
    
    private func headerView() -> some View {
        HStack {
            if fromSearchView {
                backButton
                HStack {
                    Text(profileUser.username)
                        .font(.system(size: 25, weight: .medium))
                    Spacer()
                    Image(systemName: "paperplane")
                        .imageScale(.large)
                        .padding(.horizontal, 10)
                    Image("more")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 27, height: 27)
                }
                .padding()
            }else{
                HStack {
                    Text(viewModel.username)
                        .font(.system(size: 25, weight: .medium))
                    Spacer()
                    Image(systemName: "plus.app")
                        .imageScale(.large)
                        .padding(.horizontal, 10)
                    Image("menu")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 27, height: 27)
                        .onTapGesture {
                            viewModel.menuButtonClicked = true
                        }
                }
                .padding()
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
                showProfileView = false
            }
    }
    
    private func profileImageView() -> some View {
        ZStack{
            if fromSearchView {
                profileImage(
                    uiImage: profileUser.profileImage ?? UIImage(systemName: "person.crop.circle.fill")
                )
            }else{
                PhotosPicker(selection: $viewModel.photosPickerItem, matching: .images){
                    ZStack{
                        profileImage(uiImage: viewModel.profileImage ?? UIImage(systemName: "person.crop.circle.fill"))
                        if viewModel.isLoadImage {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(width: 20, height: 20)
                        }
                        
                    }
                }
            }
        }
        
    }
    
    private func profileImage(uiImage: UIImage?) -> some View {
        Image(uiImage: uiImage!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color(hex: "#EEEDEB"), lineWidth: 1)
            )
    }
    
    private func statsView() -> some View {
        let stats = [
            ("posts", fromSearchView ? viewModel.postsArrayOthers.count : viewModel.postsArray.count),
            ("followers", fromSearchView ? viewModel.followersArrayOthers.count : viewModel.followersArray.count),
            ("following", fromSearchView ? viewModel.followingArrayOthers.count : viewModel.followingArray.count)
        ]

        return HStack {
            ForEach(stats, id: \.0) { stat in
                VStack {
                    Text("\(stat.1)") // Count
                    Text(stat.0)     // Label
                }
//                Spacer()
                if stat.0 != "following" { Spacer() } // Add space between items, except after "following"
            }
        }
    }

    private func actionButtonsView() -> some View {
        HStack {
            if fromSearchView {
                followButton()
                messageButton()
            }else{
                editProfileButton()
                shareProfileButton()
            }
            addFriendButton()
        }
        .padding()
    }
    
    private func followButton() -> some View {
        let title = viewModel.isFollowing ? "Following" : "Follow"
        let bgColor = viewModel.isFollowing ? Color(hex: "#f4f5f7") : Color(hex: "#0195f7")
        let txtColor: Color = viewModel.isFollowing ? .black : .white
            
        return button(title: title, bgColor: bgColor, txtColor: txtColor) {
            print("following clicked")
            if !viewModel.isFollowing {
                viewModel.fetchFollow(username: profileUser.username)
            }
        }
    }
    
    private func messageButton() -> some View {
        button(title: "Message", bgColor: Color(hex: "#f4f5f7"), txtColor: .black) {
            print("Message clicked")
        }
    }
    
    private func editProfileButton() -> some View {
        button(title: "Edit profile", bgColor: Color(hex: "#f4f5f7"), txtColor: .black) {
            print("edit profile clicked")
        }
    }
    
    private func shareProfileButton() -> some View {
        button(title: "Share profile", bgColor: Color(hex: "#f4f5f7"), txtColor: .black) {
            print("share profile clicked")
        }
    }
    
    private func button(title : String, bgColor: Color, txtColor: Color, action: @escaping () -> Void) -> some View {
        Button (action : action) {
            Text(title)
                .foregroundColor(txtColor)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 35)
        .frame(maxWidth: .infinity)
        .background(bgColor)
        .cornerRadius(7)
    }
    
    private func addFriendButton() -> some View {
        Button {
        } label: {
            Image("invite")
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                .padding(.horizontal, 10)
        }
        .frame(height: 35)
        .background(Color(hex: "#f4f5f7"))
        .cornerRadius(7)
    }
    
    private func tabSelectionView() -> some View {
        HStack(spacing: 0) {
            ForEach(0..<tabItems.count, id: \.self) { index in
                Button(action: {
                    withAnimation {
                        viewModel.selectedTab = index
                    }
                }) {
                    VStack(alignment: .center) {
                        Image(systemName: tabItems[index])
                            .foregroundColor(.black)
                            .font(.system(size: 24))
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .frame(width: 60, height: 2)
                            .foregroundColor(viewModel.selectedTab == index ? .black : .clear)
                            .padding(.top, -10)
                    }
                }
            }
        }
    }
    
    private func postGridView() -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                let posts = fromSearchView ? viewModel.postsArrayOthers : viewModel.postsArray

                ForEach(posts.sorted(by: { $0.datePost > $1.datePost })) { post in
                    KFImage(URL(string: post.postUrl))
                        .resizable()
                        .scaledToFill() // Fill the frame and crop if needed
                        .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                        .clipped()
                        .onTapGesture {
                            print("post clicked")
                        }
                }
            }
        }
    }
}

#Preview {
//    ProfileView(viewModel: ProfileViewModel())
    ProfileView(showProfileView: .constant(false), profileUser: .constant(ProfileUser()))
}

struct MenuView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    @State private var showPopup = false
    @State private var message = "Log out of your account?"
    
    @StateObject private var firestoreManager = FirestoreManager()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                Button {
                    print("logout button")
                    showPopup = true
                } label: {
                    Text("Log out")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.red)
                }
                .padding()
                Spacer()
            }
            
            if showPopup {
                Color.black.opacity(0.4) // Background dimming
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showPopup = false
                        }
                    }
                            
                    popupDialog
                        .transition(.scale.combined(with: .opacity)) // Animations
            }
        }
        
        
    }
    
    private var popupDialog: some View {
        VStack(spacing: 20) {
            Text(message)
                .font(.system(size: 15))
                .fontWeight(.semibold)
                .padding(.top, 30)
                .padding(.bottom, 10)
            Divider()
            Button(action: {
                dismiss()
                viewModel.signOut()
                withAnimation {
                    showPopup = false
                }
            }) {
                Text("Log out")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.red)
            }
            Divider()
            Button(action: {
                withAnimation {
                    showPopup = false
                }
            }) {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 20)
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(.horizontal, 75)
//        .onChange(of: viewModel.navigateToLoginView) { oldValue, newValue in
//            if newValue {
//                dismiss()
//            }
//        }
//        .navigationDestination(isPresented: $viewModel.navigateToLoginView) {
//            LoginView()
//        }
    }
}

