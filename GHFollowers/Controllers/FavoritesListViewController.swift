//
//  FavoritesViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 01/03/2024.
//

import UIKit

class FavoritesListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue

        PersistenceManager.retrieveFavorites { [weak self] result in

            guard let self = self else {
                return
            }

            switch result {
                case .success(let favorites):
                    print(favorites)
                case .failure(let error):
                    break
            }

        }
    }
}
