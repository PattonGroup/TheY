//
//  Feed.swift
//  University Forum
//
//  Created by Ian Talisic on 14/09/2021.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore


class Feed: Encodable {
    var id: String?
    var postedBy: String?
    var post: String?
    var imageURLs: [String]
    var videoURL: String?
    
    init(){
        self.id = ""
        self.postedBy = ""
        self.post = ""
        self.imageURLs = []
        self.videoURL = ""
    }
    
    init(id: String, postedBy: String, post: String, imageURLs: [String], videoURL: String) {
        self.id = id
        self.postedBy = postedBy
        self.post = post
        self.imageURLs = imageURLs
        self.videoURL = videoURL
    }
}

//#Mark:- Users model
struct PostResponseModel {

    var photoURLPath: String
    var postAt: String
    var postDescription: String
    var status: String
    var universityID: String
    var universityName: String
    var userID: String
    var videoURLPath: String

   init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data()
       photoURLPath = SharedFunc.getString(snapshotValue["photoURLPath"])
       postAt = SharedFunc.getString(snapshotValue["postAt"])
       postDescription = SharedFunc.getString(snapshotValue["postDescription"])
       status = SharedFunc.getString(snapshotValue["status"])
       universityID = SharedFunc.getString(snapshotValue["universityID"])
       userID = SharedFunc.getString(snapshotValue["userID"])
       videoURLPath = SharedFunc.getString(snapshotValue["videoURLPath"])
       universityName = SharedFunc.getString(snapshotValue["universityName"])
    }
}
