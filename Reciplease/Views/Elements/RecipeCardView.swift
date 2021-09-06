//
//  RecipeCardView.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import UIKit

class RecipeCardView: UIView {
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subviews
    let recipeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "EmptyStateCellImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.5
        label.textAlignment = .left
        return label
    }()

    let recipeIngredientsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    let titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let recipeInfoView = RecipeInfoView()

    override func layoutSubviews() {
        setRecipeImageContraints()
        setTitleStackViewConstraints()
        setRecipeInfoViewConstraints()
    }
}
// MARK: - Constraints
extension RecipeCardView {

    private func setRecipeImageContraints() {
        addSubview(recipeImage)
        NSLayoutConstraint.activate([
            recipeImage.topAnchor.constraint(equalTo: topAnchor),
            recipeImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            recipeImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setTitleStackViewConstraints() {
        addSubview(titleStackView)
        titleStackView.addArrangedSubview(recipeNameLabel)
        titleStackView.addArrangedSubview(recipeIngredientsLabel)
        NSLayoutConstraint.activate([
            titleStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    private func setRecipeInfoViewConstraints() {
        recipeInfoView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(recipeInfoView)
        NSLayoutConstraint.activate([
            recipeInfoView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            recipeInfoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            recipeInfoView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
