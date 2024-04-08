//
//  GHFButton.swift
//  GHFollowers
//
//  Created by António Loureiro on 01/03/2024.
//

import UIKit

class GHFButton: UIButton {

    override init(frame: CGRect) {

        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(backgroundColor: UIColor, title: String) {

        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }

    private func configure() {

        layer.cornerRadius = 10.0
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }

    func set(backroundColor: UIColor, title: String) {

        self.backgroundColor = backroundColor
        setTitle(title, for: .normal)
    }

}
