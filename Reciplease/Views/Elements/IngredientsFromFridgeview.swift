//
//  AddIngredientFromFridgeview.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import Foundation
import UIKit

class IngredientsFromFridgeView: UIView {

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subviews
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What's in your fridge?"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.textAlignment = .left
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "You can add several ingredients by separating them with a comma."
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.5
        label.textAlignment = .left
        return label
    }()

    let addIngredientButton: CustomButton = {
        let button = CustomButton(color: .systemGreen, title: "ADD")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Lemon,Cheese,Sausages..."
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.adjustsFontSizeToFitWidth = true
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.textAlignment = .left
        textField.textColor = .label
        textField.autocorrectionType = .yes
        textField.keyboardType = .default
        textField.returnKeyType = .continue
        textField.clearButtonMode = .whileEditing
        textField.roundCorners(radius: 11)
        textField.backgroundColor = .quaternarySystemFill
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return textField
    }()

    private let textFieldStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        return stack
    }()

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func layoutSubviews() {
        backgroundColor = .secondarySystemGroupedBackground
        addShadow(opacity: 0.1)
        setTextFieldStackView()
        setMainStackViewConstraints()
    }
}
// MARK: - Constraints
extension IngredientsFromFridgeView {

    private func setTextFieldStackView() {
        textFieldStackView.addArrangedSubview(textField)
        textFieldStackView.addArrangedSubview(addIngredientButton)
    }

    private func setMainStackViewConstraints() {
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subtitleLabel)
        mainStackView.addArrangedSubview(textFieldStackView)
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
