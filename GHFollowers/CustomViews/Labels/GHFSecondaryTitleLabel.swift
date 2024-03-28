//
//  GHFSecondaryTitleLabel.swift
//  GHFollowers
//
//  Created by António Loureiro on 28/03/2024.
//

import UIKit

class GHFSecondaryTitleLabel: UILabel {

    override init(frame: CGRect) {

        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    init(fontSize: CGFloat) {

        super.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        configure()
    }

    private func configure() {
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
