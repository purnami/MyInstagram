//
//  AddView.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//

import SwiftUI

struct AddView: View {
    @StateObject private var firestoreManager = FirestoreManager()
    var body: some View {
        NavigationView {
            VStack {
                Text("Add view")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            .onAppear {
                Task {
                    await firestoreManager.addContent()
                }
            }
            .navigationTitle("Add")
        }
    }
}
