//
//  GHFRepoItemViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 02/04/2024.
//

import UIKit

protocol RepoItemViewControllerDelegate: AnyObject {

    func didTapGitHubProfile(for user: User)
}

class GHFRepoItemViewController: GHFItemInfoViewController {

    weak var delegate: RepoItemViewControllerDelegate!

    init(user: User, delegate: RepoItemViewControllerDelegate) {

        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        configureItems()
    }

    private func configureItems() {

        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backroundColor: .systemPurple, title: "GitHub Profile")
    }

    override func actionButtonTapped() {

        delegate.didTapGitHubProfile(for: user)
    }
}
