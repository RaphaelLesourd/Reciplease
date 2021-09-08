//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import UIKit
import Alamofire

class RecipeTableViewCell: UITableViewCell {

    static let reuseIdentifier = "recipeCell"
    private let imageClient = ImageClient()

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
        gradientLayer.locations = [0.2, 1]
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
    //    recipeCardView.recipeImage.image = nil
    }

    // MARK: - Configuration
    func configure(with recipe: RecipeClass?) {
        guard let recipe = recipe else {return}

        recipeCardView.recipeNameLabel.text = recipe.label

        if let rating = recipe.yield, rating > 0 {
            recipeCardView.recipeInfoView.ratingLabel.text = "\(rating)"
        } else {
            recipeCardView.recipeInfoView.ratingStackView.isHidden = true
        }

        if let cookingTime = recipe.totalTime, cookingTime > 0 {
            recipeCardView.recipeInfoView.recipeTimeLabel.text = "\(cookingTime)'"
        } else {
            recipeCardView.recipeInfoView.recipeTimeStackView.isHidden = true
        }

        let ingredients = recipe.ingredientLines?.compactMap({ $0 }).joined(separator: ", ")
        recipeCardView.recipeIngredientsLabel.text = ingredients

        imageClient.getImage(with: recipe.image) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let image):
                    self.recipeCardView.recipeImage.image = image
            case .failure(_):
                    self.recipeCardView.recipeImage.image = UIImage(named: "EmptyStateCellImage")
            }
        }
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