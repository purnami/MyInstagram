//
//  StoryView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 29/11/24.
//

import SwiftUI

struct StoryView: View {
    @ObservedObject var viewModel: HomeViewModel
    let stories: [Story]
    @Environment(\.dismiss) var dismiss
    
    @State private var currentStoryIndex = 0
    @State private var timer: Timer? = nil
    private let storyDuration: Double = 5.0
    @State private var progressValues: [Int:CGFloat] = [:]
    @State private var isTap: [Int:Bool] = [:]

    var body: some View {
        ZStack {
            storyImage
    
            VStack {
                storyProgressBar
                storyInfo
                Spacer()
            }
            
            .padding(.top, 50)
        }
        .onAppear {
            startStoryTimeline()
        }
        .onDisappear {
            stopStoryTimeline()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            handleTapGesture()
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var storyImage: some View{
        Image(uiImage: viewModel.changeStringToUIImage(stories[currentStoryIndex].storyImage) ?? UIImage(systemName: "photo.fill")!)
            .resizable()
            .scaledToFit()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .clipped()
    }
    
    private var storyProgressBar: some View{
        HStack(spacing: 2) {
            ForEach(0..<stories.count, id: \.self) { index in
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(isTap[index] ?? false ? Color.black : Color.gray.opacity(0.3))
                            .frame(height: 2)
                        
                        if index <= currentStoryIndex {
                            Capsule()
                                .fill(Color.black)
                                .frame(width: geometry.size.width * (progressValues[index] ?? 0), height: 2)
                                .animation(.linear(duration: storyDuration), value: progressValues[index])
                        }
                    }
                }
                .frame(height: 3)
            }
        }
        .padding(.horizontal, 20)
        .onChange(of: currentStoryIndex) { oldIndex, newIndex in
            if newIndex < stories.count {
                progressValues[newIndex] = 1.0
            }
        }
        .onAppear {
            if currentStoryIndex < stories.count {
                progressValues[currentStoryIndex] = 1.0
            }
        }
    }
    
    private var storyInfo : some View {
        HStack{
            profileImage(uiImage: (viewModel.profileImage[stories[currentStoryIndex].username] ?? UIImage(systemName: "person.crop.circle.fill"))!)
            Text(stories[currentStoryIndex].username)
                .padding(.leading, 10)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private func handleTapGesture(){
        if currentStoryIndex < stories.count - 1 {
            isTap[currentStoryIndex] = true
            currentStoryIndex += 1
            stopStoryTimeline()
            startStoryTimeline()
        } else {
            dismiss()
        }
    }
    private func startStoryTimeline() {
        timer = Timer.scheduledTimer(withTimeInterval: storyDuration, repeats: true) { _ in
            print("timer")
            if currentStoryIndex < stories.count - 1 {
                currentStoryIndex += 1
            } else {
                dismiss()
            }
        }
    }
    
    private func stopStoryTimeline() {
        timer?.invalidate()
        timer = nil
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

}

