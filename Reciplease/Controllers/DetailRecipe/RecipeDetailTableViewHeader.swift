//
//  RecipeDetailTableViewHeader.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import Foundation
import UIKit

class RecipeDetailHeaderView: UITableViewHeaderFooterView {

    static let reuseIdentifier: String = String(describing: self)

    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private let gradientLayer = CAGradientLayer()
    let recipeCardView = RecipeCardView()

    // MARK: - Fade gradient
    private func addFadeGradientToRecipeImage() {
        gradientLayer.removeFromSuperlayer()
        gradientLayer.type = .axial
        gradientLayer.colors = [UIColor.secondarySystemBackground.withAlphaComponent(0).cgColor,
                                UIColor.secondarySystemBackground.cgColor]
        gradientLayer.locations = [0.5, 0.9]
        gradientLayer.frame = recipeCardView.recipeImage.bounds
        recipeCardView.recipeImage.layer.addSublayer(gradientLayer)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        gradientLayer.colors = [UIColor.secondarySystemBackground.withAlphaComponent(0).cgColor,
                                UIColor.secondarySystemBackground.cgColor]
    }

    override func layoutSubviews() {
        setStackViewConstraints()
        addFadeGradientToRecipeImage()
    }
}
// MARK: - Constraints
extension RecipeDetailHeaderView {
    private func setStackViewConstraints() {
        recipeCardView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(recipeCardView)
        NSLayoutConstraint.activate([
            recipeCardView.topAnchor.constraint(equalTo: topAnchor),
            recipeCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            recipeCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeCardView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
