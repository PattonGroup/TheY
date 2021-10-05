//
//  Feed.swift
//  University Forum
//
//  Created by Ian Talisic on 14/09/2021.
//

import Foundation
class Feed {
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
