//
//  TrainingModel.swift
//  University Forum
//
//  Created by Ian Talisic on 30/11/2021.
//

import Foundation
import FirebaseFirestore
import Firebase


//#Mark:- Users model
struct TrainingModel {

    var documentID: String
    var title: String
    var description: String
    var location: String
    var registration_url: String
    
   init(snapshot: QueryDocumentSnapshot) {
        documentID = snapshot.documentID
        let snapshotValue = snapshot.data()
       
       title = SharedFunc.getString(snapshotValue["title"])
       description = SharedFunc.getString(snapshotValue["description"])
       location = SharedFunc.getString(snapshotValue["location"])
       registration_url = SharedFunc.getString(snapshotValue["registration_url"])
    }
}
