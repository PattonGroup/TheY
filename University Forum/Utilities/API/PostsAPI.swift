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
    static let collectionName: String = Collection.Posts
    
    func createPost(post: Dictionary<String, Any>) {
        Firestore.firestore().collection(UsersAPI.collectionName).addDocument(data: post) { err in
            if let err = err {
                SharedFunc.showError(title: "Error", errMsg: err.localizedDescription)
            } else {
                SharedFunc.showSuccess(title: "Success", message: "You have successfully created a university.")
            }
        }
    }
    
    
    func getAllPosts(completion: @escaping (_ data: [Any]) -> ()) {
        let db = Firestore.firestore()
        db.collection(Collection.Posts).getDocuments() { (querySnapshot, err) in
            if let _ = err {
                completion([])
            } else {
                completion(querySnapshot!.documents)
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

