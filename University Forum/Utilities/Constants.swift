//
//  Constants.swift
//  University Forum
//
//  Created by Ian Talisic on 28/10/2021.
//

import Foundation

class Constants {
    static let shared: Constants = Constants()
    
    
    let topMenuItems: [TopMenuItem] = [
        TopMenuItem(menuIconName: "augmented-reality-icon", menuTitle: "AR"),
        TopMenuItem(menuIconName: "curriculum-icon", menuTitle: "CURRICULUM"),
        TopMenuItem(menuIconName: "training-icon", menuTitle: "TRAINING"),
        TopMenuItem(menuIconName: "task-icon", menuTitle: "TASK"),
    ]
    
    
    let universityBannersImageNames: [String] = [
        "alabama_crimson_tide",
        "beasley_elementary",
        "culver_elementary",
        "jane_long_elementary",
        "taylor_ray_elementary"
    ]
    
    
    let universityArray: [University] = [
        University(id: "1", name: "Alabama Crimson Tide", imageURL: "", imageName: "alabama_crimson_tide"),
        University(id: "2", name: "Beasley Elementary", imageURL: "", imageName: "beasley_elementary"),
        University(id: "3", name: "Culver Elementary", imageURL: "", imageName: "culver_elementary"),
        University(id: "4", name: "Jane Long Elementary", imageURL: "", imageName: "jane_long_elementary"),
        University(id: "5", name: "Taylor Ray Elementary", imageURL: "", imageName: "taylor_ray_elementary")
    ]
}



