//
//  RecipeCellInfos.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import Foundation
import UIKit

class RecipeInfoView: UIView {

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subviews

    // Create common views
    private func infoLabel() -> UILabel {
        let label = UILabel()
        label.text = Text.noData
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }

    private func stackView(spacing: CGFloat = 5,
                           distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = spacing
        stack.distribution = distribution
        stack.alignment = .fill
        return stack
    }

    private func infoIconView(image: UIImage?) -> UIImageView {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.image = image
        icon.tintColor = .white
        icon.translatesAutoresizingMaskIntoConstraints = true
        icon.widthAnchor.constraint(equalToConstant: 17).isActive = true
        return icon
    }

    // Initialise views
    lazy var ratingLabel = infoLabel()
    lazy var ratingStackView = stackView()
    private lazy var ratingIcon = infoIconView(image: Icons.favorite)

    lazy var recipeTimeLabel = infoLabel()
    lazy var recipeTimeStackView = stackView()
    private lazy var recipeTimeIcon = infoIconView(image: Icons.timer)

    private lazy var mainStackView = stackView(spacing: 20, distribution: .fillProportionally)

    override func layoutSubviews() {
        roundCorners(radius: 7)
        addBlurEffect(blurStyle: .systemUltraThinMaterialDark, transparency: 0.5)
        setRatingStackView()
        setRecipeTimeStackView()
        setMainStackView()
    }
}
// MARK: - Constraints
extension RecipeInfoView {

    private func setRatingStackView() {
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(ratingIcon)
    }

    private func setRecipeTimeStackView() {
        recipeTimeStackView.addArrangedSubview(recipeTimeLabel)
        recipeTimeStackView.addArrangedSubview(recipeTimeIcon)
    }

    private func setMainStackView() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(ratingStackView)
        mainStackView.addArrangedSubview(recipeTimeStackView)
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
