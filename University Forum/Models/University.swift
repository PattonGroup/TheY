//
//  University.swift
//  University Forum
//
//  Created by Ian Talisic on 07/09/2021.
//

import Foundation

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
