//
//  SearchView.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import Foundation
import UIKit

class SearchView: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let addIngredientView = IngredientsFromFridgeView()
    let searchButton = CustomButton(title: "Search for recipe")
    let emptyStateView = RecipeTableViewEmptyStateView()

    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(SectionHeaderView.self,
                       forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fill
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func layoutSubviews() {
        setStackViewConstraints()
        setAddIngredientContraints()
        setSearchButtonContraints()
        setTableViewContraints()
        setEmptyStateViewConstraints()
    }
}
// MARK: - constraints
extension SearchView {

    private func setAddIngredientContraints() {
        addIngredientView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addIngredientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            addIngredientView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setTableViewContraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setSearchButtonContraints() {
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    private func setStackViewConstraints() {
        stackView.addArrangedSubview(addIngredientView)
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(searchButton)
        addSubview(stackView)
        stackView.setCustomSpacing(0, after: addIngredientView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setEmptyStateViewConstraints() {
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyStateView)
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStateView.heightAnchor.constraint(equalToConstant: 100),
            emptyStateView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}
