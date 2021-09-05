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
    private let recipeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "EmptyStateCellImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.5
        label.textAlignment = .left
        return label
    }()

    private let recipeIngredientsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    private let titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let recipeInfoView = RecipeCellInfoView()

    override func layoutSubviews() {
        setRecipeImageContraints()
        addGradient(to: contentView)
        setTitleStackViewConstraints()
        setRecipeInfoViewConstraints()
    }

    override func prepareForReuse() {
        recipeNameLabel.text = nil
        recipeIngredientsLabel .text  = nil
        recipeInfoView.ratingLabel.text = nil
        recipeInfoView.recipeTimeLabel.text = nil
        imageView?.image = nil
    }

    // MARK: - Configuration
    func configure() {
        recipeNameLabel.text = "Green curry"
        recipeIngredientsLabel .text  = "Toffu, Thaï aubergines, green curry paste"
        recipeInfoView.ratingLabel.text = "2,5K"
        recipeInfoView.recipeTimeLabel.text = "345'"
    }
}
// MARK: - Constraints
extension RecipeTableViewCell {

    private func setRecipeImageContraints() {
        contentView.addSubview(recipeImage)
        NSLayoutConstraint.activate([
            recipeImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            recipeImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            recipeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setTitleStackViewConstraints() {
        contentView.addSubview(titleStackView)
        titleStackView.addArrangedSubview(recipeNameLabel)
        titleStackView.addArrangedSubview(recipeIngredientsLabel)
        NSLayoutConstraint.activate([
            titleStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    private func setRecipeInfoViewConstraints() {
        recipeInfoView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(recipeInfoView)
        NSLayoutConstraint.activate([
            recipeInfoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            recipeInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            recipeInfoView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
