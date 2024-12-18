//
//  SearchView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 21/11/24.
//

import SwiftUI
import Kingfisher

struct SearchView: View {
    @StateObject private var pixabayViewModel = PixabayViewModel()
    @StateObject private var viewModel = SearchViewModel()
    @FocusState private var isSearchFieldFocused: Bool
    @State private var showProfileView = false
    @State private var profileUserClicked = ProfileUser()
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            if showProfileView {
                ProfileView(fromSearchView: true, showProfileView: $showProfileView, profileUser: profileUserClicked)
                    .transition(.move(edge: .trailing))
                    .onDisappear {
                        print("profileview disappear")
                        isSearchFieldFocused = true
                    }
            }else {
                VStack{
                    searchBar
                    contentView
                    Spacer()
                }
                .onAppear {
                    pixabayViewModel.fetchImages(page: 2)
                }
            }
        }
    }
    
    private var searchBar : some View {
        HStack {
            backButton
            searchField
        }
        
    }
    
    private var backButton : some View {
        Group {
            if isSearchFieldFocused {
                Image(systemName: "arrow.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(.leading, 20)
                    .onTapGesture {
                        isSearchFieldFocused = false
                        viewModel.keyword = ""
                    }
            }
        }
    }
    
    private var searchField : some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 17, height: 17)
                .foregroundColor(.gray)
                .padding(.horizontal, 10)
            TextField("Search", text: $viewModel.keyword)
                .font(.system(size: 17))
                .textFieldStyle(PlainTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .focused($isSearchFieldFocused)
                .onChange(of: viewModel.keyword) { _ , newValue in
                    viewModel.fetchUsers()
                }
            if !viewModel.keyword.isEmpty {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 8, height: 8)
                    .padding(.trailing, 5)
                    .onTapGesture {
                        viewModel.keyword = ""
                    }
            }
        }
        .padding(10)
        .background(Color(hex: "#f4f5f7"))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private var contentView : some View {
        ZStack {
            if !isSearchFieldFocused {
                imageGrid
//                VStack {
//                    imageGrid
//                    Spacer()
//                }
            }else {
                userSearchResults
            }
            
        }
    }
    
    private var userSearchResults : some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.searchResults, id: \.username) { user in
                    userRow(user : user)
                }
            }
            .padding()
        }
    }
    
    private func userRow(user : ProfileUser) -> some View {
        HStack {
            let profileImage = user.profileImage ?? UIImage(systemName: "person.crop.circle.fill")
            Image(uiImage: profileImage!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(.circle)
                .padding(.trailing, 5)
            
            Text("\(user.username)")
                .font(.system(size: 17))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .onTapGesture {
            print(user.username)
            showProfileView = true
            profileUserClicked = user
        }
    }
    
    private var imageGrid : some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(pixabayViewModel.images) { image in
                    KFImage(URL(string: image.webformatURL))
                        .resizable()
                        .scaledToFill() // Fill the frame and crop if needed
                        .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                        .clipped()
//                        .onTapGesture {
//                            selectedImage = image.webformatURL
//                        }
                }
            }
            
        }
    }
}

#Preview {
    SearchView()
}
