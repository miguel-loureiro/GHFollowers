//
//  GHFTitleLabel.swift
//  GHFollowers
//
//  Created by António Loureiro on 02/03/2024.
//

import UIKit

class GHFTitleLabel: UILabel {

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {

        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }

    private func configure() {
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
