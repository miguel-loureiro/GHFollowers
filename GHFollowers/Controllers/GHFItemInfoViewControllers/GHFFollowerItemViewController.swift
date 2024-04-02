//
//  GHFFollowerItemViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 02/04/2024.
//

import UIKit

class GHFFollowerItemViewController: GHFItemInfoViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
        configureItems()
    }

    private func configureItems() {

        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backroundColor: .systemGreen, title: "Get Followers")
    }
}