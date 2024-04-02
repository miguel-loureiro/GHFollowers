//
//  GHFRepoItemViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 02/04/2024.
//

import UIKit

class GHFRepoItemViewController: GHFItemInfoViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
        configureItems()
    }

    private func configureItems() {

        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backroundColor: .systemPurple, title: "GitHub Profile")
    }
}