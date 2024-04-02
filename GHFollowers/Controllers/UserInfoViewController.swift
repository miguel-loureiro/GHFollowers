//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 27/03/2024.
//

import UIKit

class UserInfoViewController: UIViewController {

    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()

    var username: String!
    var itemViews: [UIView] = []

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

                        self.addVCToContainer(childViewController: GHFUserInfoHeaderViewController(user: user), to: self.headerView)
                        self.addVCToContainer(childViewController: GHFRepoItemViewController(user: user), to: self.itemViewOne)
                        self.addVCToContainer(childViewController: GHFFollowerItemViewController(user: user), to: self.itemViewTwo)
                    }

                case .failure(let error):
                    self.presentGHFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    func layoutUI() {

        let padding: CGFloat = 20
        let itemHeight: CGFloat = 120

        itemViews = [headerView, itemViewOne, itemViewTwo]

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
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight)

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
