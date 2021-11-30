//
//  GradientColorClass.swift
//  University Forum
//
//  Created by Ian Talisic on 30/11/2021.
//

import Foundation
import UIKit

enum GradiantDirection {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
    }
    
class  GradientColorClass {
    static func setGradiantColor(view : UIView, topColor : UIColor, bottomColor:UIColor, cornerRadius : CGFloat = 0.0,gradiantDirection : GradiantDirection = .topToBottom )
    {
        
        view.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [topColor.cgColor,bottomColor.cgColor]
        gradient.frame = view.bounds
        
        switch gradiantDirection {
        case .topToBottom:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        
        gradient.masksToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = cornerRadius
        gradient.rasterizationScale = 100
        view.layer.insertSublayer(gradient, at: 0)
    }
}
