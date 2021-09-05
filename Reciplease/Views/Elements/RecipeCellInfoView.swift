//
//  RecipeCellInfos.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import Foundation
import UIKit

class RecipeCellInfoView: UIView {

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
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }

    private func infoStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }

    private func infoIconView(systemImageName: String) -> UIImageView {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.image = UIImage(systemName: systemImageName)
        icon.tintColor = .white
        icon.translatesAutoresizingMaskIntoConstraints = true
        icon.widthAnchor.constraint(equalToConstant: 15).isActive = true
        return icon
    }

    // Initialise views
    lazy var ratingLabel = infoLabel()
    private lazy var ratingIcon = infoIconView(systemImageName: "star.fill")
    private lazy var ratingStackView = infoStackView()

    lazy var  recipeTimeLabel = infoLabel()
    private lazy var recipeTimeIcon = infoIconView(systemImageName: "timer")
    private lazy var recipeTimeStackView = infoStackView()

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func layoutSubviews() {
        roundCorners(radius: 7)
        addBlurEffect(blurStyle: .systemUltraThinMaterialDark, transparency: 0.5)
        setRatingStackView()
        setRecipeTimeStackView()
        setMainStackView()
    }
}
// MARK: - Constraints
extension RecipeCellInfoView {

    private func setRatingStackView() {
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(ratingIcon)
    }

    private func setRecipeTimeStackView() {
        recipeTimeStackView.addArrangedSubview(recipeTimeLabel)
        recipeTimeStackView.addArrangedSubview(recipeTimeIcon)
    }

    private func setMainStackView() {
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
