//
//  GHFBodyLabel.swift
//  GHFollowers
//
//  Created by António Loureiro on 02/03/2024.
//

import UIKit

class GHFBodyLabel: UILabel {

    override init(frame: CGRect) {

        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //como vou usar DynamicType pq quero que o texto se ajuste ao tamanho do ecran para ser melhor lido
    init(textAlignment: NSTextAlignment) {

        super.init(frame: .zero)
        self.textAlignment = textAlignment
    }

    private func configure() {

        textColor = .secondaryLabel
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth =  true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints =  false
    }
}
