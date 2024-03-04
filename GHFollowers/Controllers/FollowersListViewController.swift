//
//  FollowersListviewControllerViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 02/03/2024.
//

import UIKit

class FollowersListViewController: UIViewController {

    var username: String!

    override func viewDidLoad() {

        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        NetworkManager.shared.getFollowers(username: username, page: 1) { (followers, errorMessage) in

            guard let followers = followers else {

                self.presentGHFAlertOnMainThread(title: "Bad stuff happened", message: errorMessage!, buttonTitle: "Ok")
                return
            }

            print("Followers count : \(followers.count)")
            print(followers)
        }
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
