//
//  AfterschoolScheduleModel.swift
//  University Forum
//
//  Created by Ian Talisic on 30/11/2021.
//


import Foundation
import FirebaseFirestore
import Firebase


//#Mark:- Users model
struct AfterschoolScheduleModel {

    var documentID: String
    var group_id: String
    var time: String
    var title: String
    var description: String

   init(snapshot: QueryDocumentSnapshot) {
        documentID = snapshot.documentID
        let snapshotValue = snapshot.data()
       
       group_id = SharedFunc.getString(snapshotValue["group_id"])
       time = SharedFunc.getString(snapshotValue["time"])
       title = SharedFunc.getString(snapshotValue["title"])
       description = SharedFunc.getString(snapshotValue["description"])

    }
}
