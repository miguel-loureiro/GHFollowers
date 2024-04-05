//
//  FollowersListviewControllerViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 02/03/2024.
//

import UIKit

protocol FollowerListViewControlerDelegate: AnyObject {

    func didRequestFollowers(for username: String)
}

class FollowersListViewController: UIViewController {

    enum Section { case main }

    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var pageNumber = 1
    var hasMoreFollowers = true
    var isSearching = false

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {

        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: pageNumber)
        configureDataSource()
        configureSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureViewController() {

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    func configureCollectionView() {

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: FollowerCollectionViewCell.reuseID)
    }

    func configureSearchController() {

        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func getFollowers(username: String, page: Int) {

        showloadingView()
        //como aqui existe uma strong reference entre o NetworkManager e o proprio View controller deve-se
        //evitar isso colocando uma weak reference no self (isso faz-se colocando [weak self] antes de result in
        NetworkManager.shared.getFollowers(username: username, page: pageNumber) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()

            switch result {

                case .success(let followers):
                    if followers.count < 100 { self.hasMoreFollowers = false }
                    self.followers.append(contentsOf: followers)

                    if self.followers.isEmpty {

                        let message = "This user doesn't have any followers"
                        DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                        return
                    }

                    self.updateData(on: self.followers)

                case .failure(let error):
                    self.presentGHFAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    func configureDataSource() {

        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in

            //tem que se fazer o cast pois cell é uma collection view cell genérica. ao fazer o cast digo que o seu tipo é FollowerCollectionViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCollectionViewCell.reuseID, for: indexPath) as! FollowerCollectionViewCell
            cell.set(follower: follower)
            return cell
        })
    }

    func updateData(on folowers: [Follower]) {

        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(folowers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }

    @objc func addButtonTapped() {
        
        print("Add Button tapped !!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    }

}

extension FollowersListViewController: UICollectionViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {

            guard hasMoreFollowers else { return }
            pageNumber += 1
            getFollowers(username: username, page: pageNumber)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]

        let destinationViewController = UserInfoViewController()
        // é o UserInfoViewController que vai "informar" que o botão foi tapped , pois é neste VC que está
        // o GHFFollowerItemViewController e terá que colocar um delegate para informar o parent VC (UserInfoViewController)
        // de que o botão foi tapped. Ou seja o FollowerListVC está a "escutar" o UserInfoVC
        destinationViewController.delegate =  self
        destinationViewController.username = follower.login
        let navigationController = UINavigationController(rootViewController: destinationViewController)

        present(navigationController, animated: true)
    }
}

extension FollowersListViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {

        guard let filterString = searchController.searchBar.text, !filterString.isEmpty else { return }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filterString.lowercased()) }
        updateData(on: filteredFollowers)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        isSearching = false
        updateData(on: followers)
    }
}

extension FollowersListViewController: FollowerListViewControlerDelegate {
    
    func didRequestFollowers(for username: String) {
      
        self.username = username
        title = username
        pageNumber = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: pageNumber)
    }
}

