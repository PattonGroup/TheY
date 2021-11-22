//
//  GlobalCache.swift
//  University Forum
//
//  Created by Ian Talisic on 11/09/2021.
//

import Foundation
import UIKit

protocol GlobalCacheDelegate {
    func didSelectUniversity(university: UniversityResponseModel)
}

class GlobalCache {
    static let shared = GlobalCache()
    var delegate: GlobalCacheDelegate?
    
    
}
