//
//  UnviversitiesAPI.swift
//  University Forum
//
//  Created by Ian Talisic on 11/11/2021.
//


import Foundation
import FirebaseFirestore


class UniversitiesAPI {
    static let shared: UniversitiesAPI = UniversitiesAPI()
    
    func createUnviersity(post: Dictionary<String, Any>) {
        let collection = Firestore.firestore().collection(Collection.Universities)
        collection.addDocument(data: post)
    }
    
    
    func getAllUniversity() {
        let db = Firestore.firestore()
        db.collection(Collection.Universities).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func getUnviversity(id: String, completion: @escaping (_ post: NSDictionary) -> Void ) {
        let db = Firestore.firestore()
        db.collection(Collection.Universities).whereField("id", isEqualTo: id) .getDocuments() { (querySnapshot, err) in
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

