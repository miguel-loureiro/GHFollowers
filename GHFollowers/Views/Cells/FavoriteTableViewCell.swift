//
//  FavoriteTableViewCell.swift
//  GHFollowers
//
//  Created by António Loureiro on 08/04/2024.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    static let reuseId = "FavoriteCell"
    let avatarImageView = GHFAvatarImageView(frame: .zero)
    let usernameLabel = GHFTitleLabel(textAlignment: .left, fontSize: 26)


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(favorite: Follower) {

        usernameLabel.text = favorite.login

        NetworkManager.shared.downloadImage(from: favorite.avatarUrl) { [weak self] image in

            guard let self = self else { return }

            DispatchQueue.main.async {

                self.avatarImageView.image = image
            }
        }
    }

    private func configure() {

        addSubview(avatarImageView)
        addSubview(usernameLabel)

        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12

        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),

            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
