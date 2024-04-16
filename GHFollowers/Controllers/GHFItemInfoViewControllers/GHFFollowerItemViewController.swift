//
//  GHFFollowerItemViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 02/04/2024.
//

import UIKit

protocol FollowerItemViewControllerDelegate: AnyObject {

    func didTapGetFollowers(for user: User)
}

class GHFFollowerItemViewController: GHFItemInfoViewController {

    weak var delegate: FollowerItemViewControllerDelegate!

    init(user: User, delegate: FollowerItemViewControllerDelegate) {

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

        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")
    }

    override func actionButtonTapped() {

        delegate.didTapGetFollowers(for: user)
    }
}
