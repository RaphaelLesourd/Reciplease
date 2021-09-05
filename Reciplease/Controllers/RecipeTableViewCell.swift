//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    static let identifier = "recipeCell"

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subview

    // MARK: - Configuration
    func configure() {

    }
}
// MARK: - Constraints
extension RecipeTableViewCell {

}
