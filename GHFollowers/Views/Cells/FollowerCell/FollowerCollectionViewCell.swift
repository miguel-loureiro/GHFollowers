//
//  FollowerCollectionViewCell.swift
//  GHFollowers
//
//  Created by António Loureiro on 05/03/2024.
//

import UIKit
import SwiftUI

class FollowerCollectionViewCell: UICollectionViewCell {

    static let reuseID = "FollowerCell"

    override init(frame: CGRect) {

        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    func set(follower: Follower) {

        contentConfiguration = UIHostingConfiguration {

            FollowerView(follower: follower)
        }
    }
}
