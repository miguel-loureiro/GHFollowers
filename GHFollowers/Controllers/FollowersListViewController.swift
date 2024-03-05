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

        NetworkManager.shared.getFollowers(username: username, page: 1) { result in

            switch result {

                case .success(let followers):

                    print(followers)

                case .failure(let error):

                    self.presentGHFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
