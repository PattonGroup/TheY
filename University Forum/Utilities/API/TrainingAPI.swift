//
//  TrainingAPI.swift
//  University Forum
//
//  Created by Ian Talisic on 30/11/2021.
//
import Foundation
import FirebaseFirestore
import FirebaseStorage


class TrainingAPI {
    static let shared: TrainingAPI = TrainingAPI()
    let collectionName: String = Collection.Trainings
    
  
    func getAllTrainings(completion: @escaping (_ data: [TrainingModel]) -> ()) {
        let db = Firestore.firestore()
        db.collection(collectionName).getDocuments() { (querySnapshot, err) in
            if let _ = err {
                completion([])
            } else {
                var arr: [TrainingModel] = []
                querySnapshot?.documents.forEach { doc in
                    arr.append(TrainingModel(snapshot: doc))
                }
                completion(arr)
            }
        }
    }
    
    func getTraining(id: String, completion: @escaping (_ post: NSDictionary) -> Void ) {
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

