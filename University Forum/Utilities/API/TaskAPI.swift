//
//  TaskAPI.swift
//  University Forum
//
//  Created by Ian Talisic on 01/12/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage


class TaskAPI {
    static let shared: TaskAPI = TaskAPI()
    let collectionName: String = Collection.Task
    
  
    func getAllTasks(completion: @escaping (_ data: [TaskModel]) -> ()) {
        let db = Firestore.firestore()
        db.collection(collectionName).getDocuments() { (querySnapshot, err) in
            if let _ = err {
                completion([])
            } else {
                var arr: [TaskModel] = []
                querySnapshot?.documents.forEach { doc in
                    arr.append(TaskModel(snapshot: doc))
                }
                completion(arr)
            }
        }
    }
    
    func updateTaskStatus(status: String, task: TaskModel) {
        let db = Firestore.firestore()
        db.collection(collectionName).document(task.documentID).setData([
            "status": status,
            "title": task.title
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}

