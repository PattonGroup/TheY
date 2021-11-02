//
//  FireStoreAPICall.swift
//  University Forum
//
//  Created by Ian Talisic on 02/11/2021.
//

import Foundation
import FirebaseFirestore

enum Collection {
    static let FEED: String = ""
    static let USER: String = ""
}


class FireStoreAPICall {
    static let shared: FireStoreAPICall = FireStoreAPICall()
    
    func writeDataTo(collection: String, feed: Dictionary<String, Any>) {
        let collection = Firestore.firestore().collection(collection)
        collection.addDocument(data: feed)
    }
    

    func getAllFeeds() {
        let db = Firestore.firestore()
        
//        let docRef = db.collection(Collection.FEED).document("SF")
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
//        }
        
        db.collection(Collection.FEED).whereField("universityID", isEqualTo: "1") //1 is the university id
            .getDocuments() { (querySnapshot, err) in
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
