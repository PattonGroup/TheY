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
    static let collectionName: String = Collection.Universities
    
    func createUnviersity(university: Dictionary<String, Any>) {
        var name: String = ""
        if let value = university["name"] as? String {
            name = value
        }
        
        let db = Firestore.firestore()
        db.collection(UsersAPI.collectionName).whereField("name", isEqualTo: name) .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot!.documents.count > 0 {
                    SharedFunc.showError(title: "Saving error!", errMsg: "This user already exists.")
                }else{
                    
                    Firestore.firestore().collection(UsersAPI.collectionName).addDocument(data: university) { err in
                        if let err = err {
                            SharedFunc.showError(title: "Error", errMsg: err.localizedDescription)
                        } else {
                            SharedFunc.showSuccess(title: "Success", message: "You have successfully created a university.")
                        }
                    }
                    
                }
            }
        }
    }
    
    func getAllUniversity(completion: @escaping (_ data: [Any]) -> ()) {
        let db = Firestore.firestore()
        db.collection(Collection.Universities).getDocuments() { (querySnapshot, err) in
            if let _ = err {
                completion([])
            } else {
                completion(querySnapshot!.documents)
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

