//
//  FollowersListviewControllerViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 02/03/2024.
//

import UIKit

class FollowersListViewController: GHFDataLoadingViewController{

    enum Section { case main }

    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var pageNumber = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    init(username: String) {

        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func getFollowers(username: String, page: Int) {

        showloadingView()
        isLoadingMoreFollowers = true

//        //old way - using completion handler
//        NetworkManager.shared.getFollowers(username: username, page: pageNumber) { [weak self] result in
//            guard let self = self else { return }
//            self.dismissLoadingView()
//
//            switch result {
//            case .success(let followers):
//                self.updateUI(with: followers)
//
//            case .failure(let error):
//                self.presentGHFAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
//            }
//
//            self.isLoadingMoreFollowers = false
//        }

        //new way - using async await
        
        //como aparece um erro a indicar que a func não suporta concurrency, então coloca-se Task
        //para colocar a func num contexto de concurrency
        Task {

            do {

                let followers = try await NetworkManager.shared.getFollowers(username: username, page: page)
                updateUI(with: followers)
                dismissLoadingView()
                isLoadingMoreFollowers = false
            } catch  {

                //handle errors (podemos ter um erro do tipo GHFError ou erro genérico de Swift que é o default error
                if let ghfError = error as? GHFError {

                    presentGHFAlert(title: "Bad stuff happened", message: ghfError.rawValue, buttonTitle: "Ok")
                } else {

                    presentDefaultError()
                }
                
                isLoadingMoreFollowers = false
                dismissLoadingView()
            }
        }

        //forma resumida: se fizer o try optional então ou temos o nosso array de Followers ou temos um nil
        //se tiver um array de Follower então faço updateUI, se tiver nil então apresento o erro genérico
//        Task {
//
//            guard let followers = try? await NetworkManager.shared.getFollowers(username: username, page: page) else {
//
//                presentDefaultError()
//                dismissLoadingView()
//            }
//
//            updateUI(with: followers)
//            dismissLoadingView()
//        }
    }

    func updateUI(with followers: [Follower]) {
        
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)

        if self.followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them 😀."
            DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
            return
        }

        self.updateData(on: self.followers)
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

        showloadingView()
        
        Task {

            do {

                let user = try await NetworkManager.shared.getUserInfo(username: username)
                addUserToFavorites(user: user)
                dismissLoadingView()
            } catch {

                if let ghfError = error as? GHFError {

                    presentGHFAlert(title: "Something went wrong", message: ghfError.rawValue, buttonTitle: "Ok")
                } else {

                    presentDefaultError()
                }
            }
        }
    }

    func addUserToFavorites(user: User) {

        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)

        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {

                DispatchQueue.main.async {

                    self.presentGHFAlert(title: "Success!", message: "You have successfully favorited this user 🎉", buttonTitle: "Hooray!")
                }

                return
            }

            DispatchQueue.main.async {

                self.presentGHFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }

            dismissLoadingView()
        }
    }
}

extension FollowersListViewController: UICollectionViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {

            guard hasMoreFollowers, !isLoadingMoreFollowers else { return } //apenas fazemos a proxima network call quando tivermos recebido os followers senão estava a fazer pedidos concurrentes e isso é mau
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

extension FollowersListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

        guard let filterString = searchController.searchBar.text, !filterString.isEmpty else {
            
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching =  false
            return
        }

        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filterString.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

extension FollowersListViewController: UserInfoViewControlerDelegate {
    
    func didRequestFollowers(for username: String) {
      
        self.username = username
        title = username
        pageNumber = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: pageNumber)
    }
}

