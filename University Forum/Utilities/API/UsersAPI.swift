//
//  UsersAPI.swift
//  University Forum
//
//  Created by Ian Talisic on 11/11/2021.
//


import Foundation
import FirebaseFirestore


class UsersAPI {
    static let shared: UsersAPI = UsersAPI()
    
    func createUser(post: Dictionary<String, Any>) {
        let collection = Firestore.firestore().collection(Collection.Users)
        collection.addDocument(data: post)
    }
    
    
    func getAllUsers() {
        let db = Firestore.firestore()
        db.collection(Collection.Users).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func getUser(id: String, completion: @escaping (_ post: NSDictionary) -> Void ) {
        let db = Firestore.firestore()
        db.collection(Collection.Users).whereField("id", isEqualTo: id) .getDocuments() { (querySnapshot, err) in
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

