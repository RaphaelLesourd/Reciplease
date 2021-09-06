//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    static let reuseIdentifier = "recipeCell"

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subview
    private let recipeCardView = RecipeCardView()

    private func addFadeGradientToRecipeImage() {
        let gradientLayer = CAGradientLayer()
        recipeCardView.recipeImage.layer.sublayers?.removeAll()
        gradientLayer.removeFromSuperlayer()
        gradientLayer.type = .axial
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0).cgColor,
                                UIColor.black.withAlphaComponent(0.5).cgColor]
        gradientLayer.locations = [0.2, 1.1]
        gradientLayer.frame = contentView.bounds
        recipeCardView.recipeImage.layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        setRecipeImageContraints()
        addFadeGradientToRecipeImage()
    }

    override func prepareForReuse() {
        recipeCardView.recipeNameLabel.text = nil
        recipeCardView.recipeIngredientsLabel .text  = nil
        recipeCardView.recipeInfoView.ratingLabel.text = nil
        recipeCardView.recipeInfoView.recipeTimeLabel.text = nil
    }

    // MARK: - Configuration
    func configure(with recipe: RecipeClass?) {
        guard let recipe = recipe else {return}
        recipeCardView.recipeNameLabel.text = recipe.label
        if let rating = recipe.yield {
            recipeCardView.recipeInfoView.ratingLabel.text = "\(rating)"
        }
        if let cookingTime = recipe.totalTime {
            recipeCardView.recipeInfoView.recipeTimeLabel.text = "\(cookingTime)"
        }
        let ingredients = recipe.ingredients?.compactMap({
            $0.text
        }).joined(separator: ", ")
        recipeCardView.recipeIngredientsLabel.text = ingredients
    }
}
// MARK: - Constraints
extension RecipeTableViewCell {

    private func setRecipeImageContraints() {
        recipeCardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(recipeCardView)
        NSLayoutConstraint.activate([
            recipeCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            recipeCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
