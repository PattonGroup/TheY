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
        TopMenuItem(menuIconName: "perks-icon", menuTitle: "Menu 1"),
        TopMenuItem(menuIconName: "perks-icon", menuTitle: "Menu 2"),
        TopMenuItem(menuIconName: "perks-icon", menuTitle: "Menu 3"),
        TopMenuItem(menuIconName: "perks-icon", menuTitle: "Menu 4"),
        TopMenuItem(menuIconName: "perks-icon", menuTitle: "Menu 5"),
        TopMenuItem(menuIconName: "perks-icon", menuTitle: "Menu 6")
    ]
    
    
    let universityBannersImageNames: [String] = [
        "alabama_crimson_tide",
        "beasley_bobcats",
        "home_of_the_culver",
        "jane_long_elementary",
        "taylor_ray_elementary"
    ]
    
}
