//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 27/03/2024.
//

import UIKit

class UserInfoViewController: UIViewController {

    let headerView = UIView()

    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton

        NetworkManager.shared.getUserInfo(username: username) { [weak self] result in

            guard let self = self else { return }

            switch result {

                case .success(let user):
                    print(user)

                    DispatchQueue.main.async {

                        self.addVCToContainer(childViewController: GHFUserInfoHeaderViewController(user: user), to: self.headerView)
                    }

                case .failure(let error):
                    self.presentGHFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }

        layoutUI()
    }

    func layoutUI() {

        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
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
