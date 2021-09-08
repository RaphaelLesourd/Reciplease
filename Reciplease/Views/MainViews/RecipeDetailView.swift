//
//  RecipeDetailView.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import Foundation
import UIKit

class RecipeDetailView: UIView {

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subviews
    let directionButton = CustomButton(title: "Get directions")

    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.allowsSelection = false
        table.estimatedRowHeight = 50
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(RecipeDetailHeaderView.self,
                       forHeaderFooterViewReuseIdentifier: RecipeDetailHeaderView.reuseIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func layoutSubviews() {
        setDirectionButtonConstraints()
        setTableViewConstraints()
    }
}
// MARK: - Constraints
extension RecipeDetailView {

    private func setDirectionButtonConstraints() {
        directionButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(directionButton)
        NSLayoutConstraint.activate([
            directionButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            directionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            directionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            directionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setTableViewConstraints() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: directionButton.topAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
