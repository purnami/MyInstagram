//
//  FirestoreManager.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//

import FirebaseFirestore
import Combine

class FirestoreManager: ObservableObject {
    private var db = Firestore.firestore()
    
//    @Published var items: [Item] = []
    
//    func fetchData() {
//        db.collection("items").addSnapshotListener { querySnapshot, error in
//            if let error = error {
//                print("Error getting documents: \(error.localizedDescription)")
//            } else {
//                self.items = querySnapshot?.documents.compactMap { document in
//                    try? document.data(as: Item.self)
//                } ?? []
//            }
//        }
//    }
    
    @Published var contents: [Content] = []
    
    func addContent() async {
//        let newItem = Item(name: name, price: price)
//        
//        do {
//            _ = try db.collection("items").addDocument(from: newItem)
//        } catch {
//            print("Error adding document: \(error.localizedDescription)")
//        }
        do {
            let ref = try await db.collection(K.FStore.collectionContent).addDocument(data: [
              K.FStore.userName : "laksmiee",
              K.FStore.postUrl : "https://cdn.pixabay.com/photo/2024/10/13/07/48/leaves-9116635_1280.png",
              K.FStore.datePost : Timestamp(date: Date())
          ])
          print("Document added with ID: \(ref.documentID)")
        } catch {
          print("Error adding document: \(error)")
        }

    }
    
    func loadContent(){
        
        db.collection(K.FStore.collectionContent)
            .order(by: K.FStore.datePost, descending: false)
            .addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data from firestore. \(e)")
            }else{
                self.contents=[]
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        print(data[K.FStore.userName])
                        if let userName = data[K.FStore.userName] as? String, let postUrl = data[K.FStore.postUrl] as? String, let datePost = data[K.FStore.datePost] as? Timestamp {
                            
                            let newContent = Content(id:UUID(), userName: userName, postUrl: postUrl, datePost: datePost)
                            self.contents.append(newContent)
                            
                        }
                    }
                }
            }
        }
    }
}
