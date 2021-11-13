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
    static let collectionName: String = Collection.Users
    
    
    func createUser(user: Dictionary<String, Any>) {
        var email: String = ""
        if let value = user["email"] as? String {
            email = value
        }
        
        let db = Firestore.firestore()
        db.collection(UsersAPI.collectionName).whereField("email", isEqualTo: email) .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                       
                if querySnapshot!.documents.count > 0 {
                    SharedFunc.showError(title: "Saving error!", errMsg: "This user already exists.")
                }else{
                    
                    var ref: DocumentReference? = nil
                    ref = Firestore.firestore().collection(UsersAPI.collectionName).addDocument(data: user) { err in
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
    
    
    func getAllUsers() {
        let db = Firestore.firestore()
        db.collection(Collection.Users).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func getUser(id: String, completion: @escaping (_ post: NSDictionary) -> Void ) {
        let db = Firestore.firestore()
        db.collection(Collection.Users).whereField("id", isEqualTo: id) .getDocuments() { (querySnapshot, err) in
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

