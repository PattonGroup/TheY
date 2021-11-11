//
//  Extension.swift
//  University Forum
//
//  Created by Ian Talisic on 23/10/2021.
//

import Foundation
import UIKit

extension String {
    func trim() -> String {
       return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
