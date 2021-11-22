//
//  UnviversitiesAPI.swift
//  University Forum
//
//  Created by Ian Talisic on 11/11/2021.
//


import Foundation
import FirebaseFirestore
import FirebaseStorage


class UniversityAPI {
    static let shared: UniversityAPI = UniversityAPI()
    let collectionName: String = Collection.Universities
    
    func createUnviersity(university: Dictionary<String, Any>) {
        var name: String = ""
        if let value = university["name"] as? String {
            name = value
        }
        
        let db = Firestore.firestore()
        db.collection(collectionName).whereField("name", isEqualTo: name) .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot!.documents.count > 0 {
                    SharedFunc.showError(title: "Saving error!", errMsg: "This user already exists.")
                }else{
                    
                    Firestore.firestore().collection(self.collectionName).addDocument(data: university) { err in
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
    
    func getAllUniversity(completion: @escaping (_ data: [UniversityResponseModel]) -> ()) {
        let db = Firestore.firestore()
        db.collection(collectionName).getDocuments() { (querySnapshot, err) in
            if let _ = err {
                completion([])
            } else {
                var arr: [UniversityResponseModel] = []
                querySnapshot?.documents.forEach { doc in
                    arr.append(UniversityResponseModel(snapshot: doc))
                }
                
                completion(arr)
            }
        }
    }
    
    func getUnviversity(id: String, completion: @escaping (_ post: NSDictionary) -> Void ) {
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

