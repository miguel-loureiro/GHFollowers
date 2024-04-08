//
//  GHFTabBarController.swift
//  GHFollowers
//
//  Created by António Loureiro on 08/04/2024.
//

import UIKit

class GHFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        self.viewControllers = [createSearchNavigationController(), createFavoritesListNavigationController()]
    }

    func createSearchNavigationController() -> UINavigationController {

        let searchViewController = SearchViewController()
        searchViewController.title = "Search"
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        return UINavigationController(rootViewController: searchViewController)
    }

    func createFavoritesListNavigationController() -> UINavigationController {

        let favoritesListViewController = FavoritesListViewController()
        favoritesListViewController.title = "Favorites"
        favoritesListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)

        return UINavigationController(rootViewController: favoritesListViewController)
    }
}
