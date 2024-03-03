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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //como não vou usar DynamicType pq quero que o titulo seja sempre grande e não se encolha demasiado
    //então crio um init com font size para predefinir um tamanho
    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {

        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }

    private func configure() {

        textColor = .label
        adjustsFontSizeToFitWidth =  true
        minimumScaleFactor = 0.90
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints =  false
    }
}
