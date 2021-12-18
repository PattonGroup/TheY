//
//  AnnouncementAPI.swift
//  University Forum
//
//  Created by Ian Talisic on 10/12/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage


class AnnouncementAPI {
    static let shared: AnnouncementAPI = AnnouncementAPI()
    let collectionName: String = Collection.Announcement
    
  
    func getAllAnnouncements(completion: @escaping (_ data: [AnnouncementModel]) -> ()) {
        let db = Firestore.firestore()
        db.collection(collectionName).getDocuments() { (querySnapshot, err) in
            if let _ = err {
                completion([])
            } else {
                var arr: [AnnouncementModel] = []
                querySnapshot?.documents.forEach { doc in
                    arr.append(AnnouncementModel(snapshot: doc))
                }
                completion(arr)
            }
        }
    }
    
    func getAnnouncement(id: String, completion: @escaping (_ post: NSDictionary) -> Void ) {
        let db = Firestore.firestore()
        db.collection(collectionName).whereField("id", isEqualTo: id) .getDocuments() { (querySnapshot, err) in
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

