//
//  AddView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//

import SwiftUI
import Kingfisher

struct AddView: View{
    @StateObject private var pixabayViewModel = PixabayViewModel()
    
    @State private var selectedImage: String?
    @State private var isImageSelected = false
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            VStack {
                postHeader()
                postImage()
                imageGrid()
            }
            .sheet(isPresented: $isImageSelected) {
                if let selectedImage {
                    SelectedImageView(imageUrl: selectedImage)
                }
            }
            .onAppear {
                pixabayViewModel.fetchImages(page: 1)
            }
        }
    }
    
    private func postHeader() -> some View {
        HStack {
            Spacer()
            
            Text("Next")
                .foregroundColor(.blue)
                .padding()
                .onTapGesture {
                    isImageSelected = true
                }
            
        }
    }
    
    private func postImage() -> some View {
        Group {
            if let selectedImage {
                KFImage(URL(string: selectedImage))
                    .resizable()
                    .scaledToFit()
                    .frame(height: 270)
            }
            else if let firstImage = pixabayViewModel.images.first {
                KFImage(URL(string: firstImage.webformatURL))
                    .resizable()
                    .scaledToFit()
                    .frame(height: 270)
                    .onAppear {
                        selectedImage = firstImage.webformatURL
                    }
            }
            else {
                Text("Loading first image...")
                    .foregroundColor(.gray)
            }
        }
    }
    
    private func imageGrid() -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(pixabayViewModel.images) { image in
                    KFImage(URL(string: image.webformatURL))
                        .resizable()
                        .scaledToFill() // Fill the frame and crop if needed
                        .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
                        .clipped()
                        .onTapGesture {
                            selectedImage = image.webformatURL
                        }
                }
            }
            
        }
    }
}

#Preview {
    AddView()
}

struct SelectedImageView: View {
    let imageUrl: String
    
    @State private var caption: String = ""
    @StateObject private var firestoreManager = FirestoreManager()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            postHeader()
            Divider()
            postOption()
            Spacer()
            HStack {
                actionButton(title: "Save Draft", textColor: .black, backgroundColor: Color(hex: "#f4f5f7")) {
                    print("Save Draft clicked")
                }
                actionButton(title: "Share", textColor: .white, backgroundColor: Color(hex: "#0195f7")) {
                    print("Share clicked \(imageUrl)")
                    
                    firestoreManager.addPost(url: imageUrl, type: "image", caption: caption) { isSuccess in
                        if isSuccess {
                            dismiss()
                        }else {
                            //show alert failed
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private func postHeader() -> some View {
        Group {
            HStack {
                Text("New Post")
                    .font(.title3)
                    .padding(.leading, 40)
                    .padding(.vertical, 20)
                Spacer()
            }
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            TextField("Write a caption...", text: $caption)
                .padding()
            
        }
    }
    
    private func postOption() -> some View {
        VStack {
            optionRow(iconName: "location", title: "Add location")
            optionRow(iconName: "people", title: "Tag people")
            optionRow(iconName: "music", title: "Add music")
            optionRow(iconName: "eye", title: "Audience", trailingText: "Followers")
        }
    }
    
    private func optionRow(iconName: String, title: String, trailingText: String? = nil) -> some View {
        HStack {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
            Text(title)
            Spacer()
            if let trailingText {
                Text(trailingText).foregroundColor(.gray)
            }
            Image(systemName: "chevron.right")
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    private func actionButton(title: String, textColor: Color, backgroundColor: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
        }
        .background(backgroundColor)
        .cornerRadius(7)
    }
}
