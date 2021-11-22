//
//  UsersAPI.swift
//  University Forum
//
//  Created by Ian Talisic on 11/11/2021.
//


import Foundation
import FirebaseFirestore


class UsersAPI {
    static let shared: UsersAPI = UsersAPI()
    let collectionName: String = Collection.Users
    
    
    func createUser(user: Dictionary<String, Any>) {
        var email: String = ""
        if let value = user["email"] as? String {
            email = value
        }
        
        let db = Firestore.firestore()
        db.collection(self.collectionName).whereField("email", isEqualTo: email) .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                       
                if querySnapshot!.documents.count > 0 {
                    SharedFunc.showError(title: "Saving error!", errMsg: "This user already exists.")
                }else{
                    
                    var ref: DocumentReference? = nil
                    ref = Firestore.firestore().collection(self.collectionName).addDocument(data: user) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                            SharedFunc.showSuccess(title: "Success", message: "You have successfully created a user.")
                        }
                    }
                    
                }
            }
        }
        

    }
    
    func getAllUsers(completion: @escaping (_ data: [Any]) -> ()) {
        let db = Firestore.firestore()
        db.collection(self.collectionName).getDocuments() { (querySnapshot, err) in
            if let _ = err {
                completion([])
            } else {
                completion(querySnapshot!.documents)
            }
        }
    }
    
    func getUser(id: String, completion: @escaping (_ post: NSDictionary) -> Void ) {
        let db = Firestore.firestore()
        db.collection(self.collectionName).whereField("id", isEqualTo: id) .getDocuments() { (querySnapshot, err) in
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

