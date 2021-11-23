//
//  University.swift
//  University Forum
//
//  Created by Ian Talisic on 07/09/2021.
//

import Foundation
import FirebaseFirestore
import Firebase

class University: Decodable {
    var id: String
    var name: String
    var imageURL: String
    var imageName: String
    
    init(id: String, name: String, imageURL: String, imageName: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.imageName = imageName
    }
}



//#Mark:- Users model
struct UniversityResponseModel {

    var documentID: String
    var id: String
    var name: String
    var memberCount: String
    var bannerURLPath: String
    var videoURLPath: String

    var dictionary : [String:Any] {
        return [
            "asdfa": ""
        ]
    }

    init(){
        self.documentID = ""
        self.id = ""
        self.name = ""
        self.memberCount = ""
        self.bannerURLPath = ""
        self.videoURLPath = ""
    }
    
   init(snapshot: QueryDocumentSnapshot) {
        documentID = snapshot.documentID
        let snapshotValue = snapshot.data()
       
       id = SharedFunc.getString(snapshotValue["id"])
       name = SharedFunc.getString(snapshotValue["name"])
       memberCount = SharedFunc.getString(snapshotValue["memberCount"])
       bannerURLPath = SharedFunc.getString(snapshotValue["bannerURLPath"])
       videoURLPath = SharedFunc.getString(snapshotValue["videoURLPath"])
    }
}
