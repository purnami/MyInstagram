//
//  PixabayAPI.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 20/11/24.
//

import Foundation

// Model for decoding the Pixabay API response
struct PixabayResponse: Codable {
    let hits: [PixabayImage]
}

struct PixabayImage: Codable, Identifiable {
    let id: Int
    let webformatURL: String // URL for the image
    let largeImageURL: String // URL for the full-size image
}
