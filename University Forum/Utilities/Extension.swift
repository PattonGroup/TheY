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
    
    func toDate(withFormat format: String = "MMM dd yyyy HH:mm:ss")-> Date?{

         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = format
         let date = dateFormatter.date(from: self)

         return date

     }
}


extension UIViewController {
    var window: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return nil }
               return window
    }
}


extension UIView {
    func makePerfectRounded(){
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
