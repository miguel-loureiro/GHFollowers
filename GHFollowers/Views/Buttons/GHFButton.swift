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

    convenience init(color: UIColor, title: String, systemImageName: String) {

        self.init(frame: .zero)
        set(color: color, title: title, systemImageName: systemImageName)
    }

    private func configure() {

        configuration = .tinted()

        configuration?.cornerStyle = .medium

        translatesAutoresizingMaskIntoConstraints = false
    }

    func set(color: UIColor, title: String, systemImageName: String) {

        configuration?.baseBackgroundColor =  color
        configuration?.baseForegroundColor =  color
        configuration?.title = title
        
        configuration?.image = UIImage(systemName: systemImageName)
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
}

#Preview() {

    return GHFButton(color: .blue, title: "Test Button", systemImageName: "pencil")
}
