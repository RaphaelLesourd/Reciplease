//
//  Colors.swift
//  Reciplease
//
//  Created by Birkyboy on 25/09/2021.
//

import Foundation
import UIKit

extension UIColor {
    
    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha:CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static let appTintColor = rgbColor(red: 186, green: 201, blue: 45, alpha: 1)
    static let favoriteColor = rgbColor(red: 255, green: 165, blue: 0, alpha: 1)
}
