//
//  AfterschoolScheduleAPI.swift
//  University Forum
//
//  Created by Ian Talisic on 01/12/2021.
//


import Foundation
import FirebaseFirestore
import FirebaseStorage


class AfterschoolScheduleAPI {
    static let shared: AfterschoolScheduleAPI = AfterschoolScheduleAPI()
    let collectionName: String = Collection.AfterschoolSchedule
    
  
    func getAllSchedules(completion: @escaping (_ data: [AfterschoolScheduleModel]) -> ()) {
        let db = Firestore.firestore()
        db.collection(collectionName).getDocuments() { (querySnapshot, err) in
            if let _ = err {
                completion([])
            } else {
                var arr: [AfterschoolScheduleModel] = []
                querySnapshot?.documents.forEach { doc in
                    arr.append(AfterschoolScheduleModel(snapshot: doc))
                }
                completion(arr)
            }
        }
    }
    
    func getSchedules(id: String, completion: @escaping (_ data: [AfterschoolScheduleModel]) -> ()) {
        let db = Firestore.firestore()
        db.collection(collectionName).whereField("group_id", isEqualTo: id) .getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion([])
            } else {
                var arr: [AfterschoolScheduleModel] = []
                querySnapshot?.documents.forEach { doc in
                    arr.append(AfterschoolScheduleModel(snapshot: doc))
                }
                completion(arr)
            }
        }
    }
    
}

