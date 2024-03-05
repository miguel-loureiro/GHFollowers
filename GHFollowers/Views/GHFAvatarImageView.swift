//
//  GHFAvatarImageView.swift
//  GHFollowers
//
//  Created by António Loureiro on 05/03/2024.
//

import UIKit

class GHFAvatarImageView: UIImageView {

    let placeholderImage = UIImage(named: "avatar-placeholder")! //aqui fiz o force unwrap porque sei que tenho esta imagem nos assets

    override init(frame: CGRect) {

        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {

        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
}
