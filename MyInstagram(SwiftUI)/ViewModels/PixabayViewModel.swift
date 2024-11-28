//
//  PixabayViewModel.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 20/11/24.
//

import SwiftUI

final class PixabayViewModel: ObservableObject {
    @Published var images: [PixabayImage] = []

    private let apiKey = "47185366-d3934844f4e3dd783f916711d" 

    func fetchImages(query: String) {
        let urlString = "https://pixabay.com/api/?key=\(apiKey)&q=\(query)&image_type=photo&pretty=true"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(PixabayResponse.self, from: data)
                DispatchQueue.main.async {
                    self.images = decodedResponse.hits
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func fetchImages(page: Int) {
        let urlString = "https://pixabay.com/api/?key=\(apiKey)&image_type=photo&pretty=true&page=\(page)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(PixabayResponse.self, from: data)
                DispatchQueue.main.async {
                    self.images = decodedResponse.hits
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
