//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 27/03/2024.
//

import UIKit

protocol UserInfoViewControlerDelegate: AnyObject {

    func didRequestFollowers(for username: String)
}

class UserInfoViewController: GHFDataLoadingViewController {

    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GHFBodyLabel(textAlignment: .center)

    var username: String!
    var itemViews: [UIView] = []
    weak var delegate: UserInfoViewControlerDelegate!

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

        Task {

            do {

                let user =  try await NetworkManager.shared.getUserInfo(username: username)
                configureUIElements(with: user)
            } catch {

                if let ghfError = error as? GHFError {

                    presentGHFAlert(title: "Something wrong", message: ghfError.rawValue, buttonTitle: "Ok")
                } else {

                    presentDefaultError()
                }
            }
        }
    }

    func configureUIElements(with user: User) {

        self.addVCToContainer(childViewController: GHFUserInfoHeaderViewController(user: user), to: self.headerView)
        self.addVCToContainer(childViewController: GHFRepoItemViewController(user: user, delegate: self), to: self.itemViewOne)
        self.addVCToContainer(childViewController: GHFFollowerItemViewController(user: user, delegate: self), to: self.itemViewTwo)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
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
            headerView.heightAnchor.constraint(equalToConstant: 210),

            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)

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

extension UserInfoViewController: RepoItemViewControllerDelegate {
    func didTapGitHubProfile(for user: User) {

        guard let url = URL(string: user.htmlUrl) else {

            presentGHFAlert(title: "Invalid URL", message: "The url attached to this user is invalid", buttonTitle: "Ok")
            return
        }

        presentSafariViewController(with: url)
    }
}

extension UserInfoViewController: FollowerItemViewControllerDelegate {
    func didTapGetFollowers(for user: User) {

        //dismissVC
        //tell follower list screen the new user

        guard user.followers != 0 else {

            presentGHFAlert(title: "No followers", message: "This user has 0 followers", buttonTitle: "Ok")
            return
        }

        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
}
