//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 27/03/2024.
//

import UIKit

protocol UserInfoViewControllerDelegate: AnyObject {

    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoViewController: UIViewController {

    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GHFBodyLabel(textAlignment: .center)

    var username: String!
    var itemViews: [UIView] = []
    weak var delegate: FollowerListViewControlerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo()
    }

    func configureViewController() {

        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

    func getUserInfo() {

        NetworkManager.shared.getUserInfo(username: username) { [weak self] result in

            guard let self = self else { return }

            switch result {

                case .success(let user):
                    DispatchQueue.main.async {

                        self.configureUIElements(with: user)
                    }

                case .failure(let error):
                    self.presentGHFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    func configureUIElements(with user: User) {

        let repoItemViewController = GHFRepoItemViewController(user: user)
        repoItemViewController.delegate = self

        let followerItemViewController = GHFFollowerItemViewController(user: user)
        followerItemViewController.delegate = self

        self.addVCToContainer(childViewController: GHFUserInfoHeaderViewController(user: user), to: self.headerView)
        self.addVCToContainer(childViewController: repoItemViewController, to: self.itemViewOne)
        self.addVCToContainer(childViewController: followerItemViewController, to: self.itemViewTwo)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToDisplayFormat())"
    }

    func layoutUI() {

        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]

        for itemView in itemViews {

            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints =  false

            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }

        headerView.translatesAutoresizingMaskIntoConstraints = false
        itemViewOne.translatesAutoresizingMaskIntoConstraints = false
        itemViewTwo.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),

            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)

        ])
    }

    //criar uma func para adicionar um child vc a um container view, vao existir várias adicoes e por isso é melhor uma func para isso
    func addVCToContainer(childViewController: UIViewController, to containerView: UIView) {
        
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds // para ocupar todo o espaço do container view
        childViewController.didMove(toParent: self)
    }

    @objc func dismissVC() {

        dismiss(animated: true)
       }
}

extension UserInfoViewController: UserInfoViewControllerDelegate {

    func didTapGitHubProfile(for user: User) {

        guard let url = URL(string: user.htmlUrl) else {

            presentGHFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid", buttonTitle: "Ok")
            return
        }

        presentSafariViewController(with: url)
    }
    
    func didTapGetFollowers(for user: User) {

        //dismissVC
        //tell follower list screen the new user

        guard user.followers != 0 else {

            presentGHFAlertOnMainThread(title: "No followers", message: "This user has 0 followers", buttonTitle: "Ok")
            return
        }

        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
}
