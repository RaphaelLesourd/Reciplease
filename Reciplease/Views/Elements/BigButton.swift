//
//  bigButton.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import UIKit

class BigButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        self.roundCorners()
    }

    convenience init(color: UIColor = .systemGreen, title: String) {
        self.init()
        backgroundColor = color
        setTitle(title, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
