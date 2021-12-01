//
//  TaskModel.swift
//  University Forum
//
//  Created by Ian Talisic on 01/12/2021.
//

import Foundation
import FirebaseFirestore
import Firebase

//#Mark:- Users model
struct TaskModel {

    var documentID: String
    var title: String
    var status: String
    
   init(snapshot: QueryDocumentSnapshot) {
        documentID = snapshot.documentID
        let snapshotValue = snapshot.data()
       
       title = SharedFunc.getString(snapshotValue["title"])
       status = SharedFunc.getString(snapshotValue["status"])
    }
}
