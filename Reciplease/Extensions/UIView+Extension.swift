//
//  UIView+Extension.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import Foundation
import UIKit

extension UIView {

    func roundCorners(radius: CGFloat = 13, maskToBounds: Bool = true) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = maskToBounds
        self.layer.cornerCurve = .continuous
    }
}
