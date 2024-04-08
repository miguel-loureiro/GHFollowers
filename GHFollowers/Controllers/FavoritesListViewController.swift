//
//  FavoritesViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 01/03/2024.
//

import UIKit

class FavoritesListViewController: UIViewController {

    let tableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        //coloca-se o getFavorites aqui pois o viewDidLoad só é chamado na 1ª vez e este é chamado sempre que a view
        //volta a ser apresentada, ou seja foi adicionado um Favorite de seguida há um reload e vai voltar a ser apresentada
        //a view
        getFavorites()
    }

    func configureViewController() {

        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles =  true
    }

    func configureTableView() {
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.reuseId)
    }

    func getFavorites() {

        PersistenceManager.retrieveFavorites { [weak self] result in

            guard let self = self else {
                return
            }

            switch result {
                case .success(let favorites):

                    if favorites.isEmpty {

                        showEmptyStateView(with: "No favorites.\nAdd one on the follower screen", in: self.view)
                    } else {

                        self.favorites = favorites

                        DispatchQueue.main.async {

                            self.tableView.reloadData()
                            //faz-se isto para garantir que a table view fica à frente da view de empty state
                            self.view.bringSubviewToFront(self.tableView)
                        }
                    }

                case .failure(let error):
                    self.presentGHFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

extension FavoritesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseId) as! FavoriteTableViewCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let favorite = favorites[indexPath.row]
        let destinationViewController = FollowersListViewController()
        destinationViewController.username = favorite.login
        destinationViewController.title = favorite.login

        navigationController?.pushViewController(destinationViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        guard editingStyle == .delete else { return }

        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)

        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in

            guard let self = self else { return }

            guard let error = error else { return }

            self.presentGHFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}
