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
        setSearchButtonContraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let searchButton = BigButton(title: "Search for recipe")
}
// MARK: - constraints
extension SearchView {

    private func setSearchButtonContraints() {
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            searchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
