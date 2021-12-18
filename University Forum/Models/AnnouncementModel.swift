//
//  AnnouncementModel.swift
//  University Forum
//
//  Created by Ian Talisic on 10/12/2021.
//


import Foundation
import FirebaseFirestore
import Firebase


//#Mark:- Users model
struct AnnouncementModel {

    var documentID: String
    var title: String
    var description: String
    var imageURL: String
    var postedAt: String
    
   init(snapshot: QueryDocumentSnapshot) {
        documentID = snapshot.documentID
        let snapshotValue = snapshot.data()
       
       title = SharedFunc.getString(snapshotValue["title"])
       description = SharedFunc.getString(snapshotValue["description"])
       imageURL = SharedFunc.getString(snapshotValue["imageURL"])
       postedAt = SharedFunc.getString(snapshotValue["postedAt"])
    }
}
