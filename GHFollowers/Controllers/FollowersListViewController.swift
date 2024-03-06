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

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: FollowerCollectionViewCell.reuseID)
    }

    func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {

        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

        return flowLayout
    }

    func getFollowers() {

        NetworkManager.shared.getFollowers(username: username, page: 1) { result in

            switch result {

                case .success(let followers):

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
