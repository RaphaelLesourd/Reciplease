//
//  RecipeTableViewHeader.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import Foundation
import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {

    static let reuseIdentifier: String = String(describing: self)

    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setStackViewConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Subview
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Text.ingredientListTitle
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.textAlignment = .left
        return label
    }()

    let deleteAllIngredientsButton: CustomButton = {
        let button = CustomButton(color: .mainTintColor, title: Text.clearButtonTitle)
        button.backgroundColor = .clear
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}
// MARK: - Constraints
extension SectionHeaderView {

    private func setStackViewConstraints() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(deleteAllIngredientsButton)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

}
