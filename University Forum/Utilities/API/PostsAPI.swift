//
//  PostsAPI.swift
//  University Forum
//
//  Created by Ian Talisic on 11/11/2021.
//

import Foundation
import FirebaseFirestore


class PostsAPI {
    static let shared: PostsAPI = PostsAPI()
    
    func createPost(post: Dictionary<String, Any>) {
        let collection = Firestore.firestore().collection(Collection.Posts)
        collection.addDocument(data: post)
    }
    
    
    func getAllPosts() {
        let db = Firestore.firestore()
        db.collection(Collection.Posts).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func getPost(id: String, completion: @escaping (_ post: NSDictionary) -> Void ) {
        let db = Firestore.firestore()
        db.collection(Collection.Posts).whereField("id", isEqualTo: id) .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
}

