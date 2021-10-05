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
    
    init(id: String, name: String, imageURL: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
    }
}
