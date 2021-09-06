//
//  UIView+Extension.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import Foundation
import UIKit

extension UIView {

    /// Add rounded corners to a view.
    /// - Parameters:
    ///   - radius: Corner radius, by default 13.
    ///   - maskToBounds: Set if the content of the view is limited to its bounds , true by default.
    func roundCorners(radius: CGFloat = 13, maskToBounds: Bool = true) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = maskToBounds
        self.layer.cornerCurve = .continuous
    }
    /// Add a fading gradient to a view.
    /// - Parameters:
    ///   - view: View to add the gradient to.
    ///   - color: Color of the gradient ending.
    func addGradient(to view: UIView,
                     color: UIColor = .black,
                     topLocation: NSNumber = 0.4,
                     bottomLocation: NSNumber = 1) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.colors = [color.withAlphaComponent(0).cgColor, color.withAlphaComponent(0.7).cgColor]
        gradientLayer.locations = [topLocation, bottomLocation]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
    }
    /// Adds a blur effet to a view.
    func addBlurEffect(blurStyle: UIBlurEffect.Style = .prominent,
                       transparency: CGFloat = 0.7) {
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.alpha = transparency
        blurredEffectView.frame = self.bounds
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurredEffectView)
    }
    /// Add a shadow to a view.
    /// - Parameters:
    ///   - opacity: Opacity of the shadow, by default 0.3
    ///   - verticalOffset: height the shadiw, 10 by default
    ///   - radius: Shadow spread, by default 20
    ///   - color: Shadow color, black by default
    func addShadow(opacity: Float = 0.3,
                   verticalOffset: CGFloat = 10,
                   radius: CGFloat = 20,
                   color: UIColor = .black) {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 1, height: verticalOffset)
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
