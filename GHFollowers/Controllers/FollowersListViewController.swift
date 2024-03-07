//
//  FollowersListviewControllerViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 02/03/2024.
//

import UIKit

class FollowersListViewController: UIViewController {

    enum Section {

        case main
    }

    var username: String!
    var followers: [Follower] = []

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {

        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers()
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureViewController() {

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureCollectionView() {

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: FollowerCollectionViewCell.reuseID)
    }

    func getFollowers() {

        NetworkManager.shared.getFollowers(username: username, page: 1) { [weak self] result in

            guard let self = self else { return }

            switch result {

                case .success(let followers):

                    //como aqui existe uma strong reference entre o NetworkManager e o proprio View controller deve-se
                    //evitar isso colocando uma weak reference no self (isso faz-se colocando [weak self] antes de result in
                    self.followers = followers
                    self.updateData()

                case .failure(let error):

                    self.presentGHFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    func configureDataSource() {

        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> FollowerCollectionViewCell? in

            //tem que se fazer o cast pois cell é uma collection view cell genérica. ao fazer o cast digo que o seu tipo é FollowerCollectionViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCollectionViewCell.reuseID, for: indexPath) as! FollowerCollectionViewCell
            cell.usernameLabel.text = follower.login
            return cell
        })
    }

    func updateData() {

        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {

            self.dataSource.apply(snapshot, animatingDifferences: true)
        }

    }
}
