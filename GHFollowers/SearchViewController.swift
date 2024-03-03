//
//  SearchViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 01/03/2024.
//

import UIKit

class SearchViewController: UIViewController {

    let logoImageView = UIImageView()
    let userNameTextField = GHFTextField()
    let callToActionButton = GHFButton(backgroundColor: .systemGreen, title: "Get Followers")

    var isUsernameEntered: Bool {

        guard let text = userNameTextField.text else {
            return false
        }
        return !text.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureImageLogoView()
        configureTextField()
        configureCallToActionButtonButton()
        createDismissKeyboardTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true //sempre que a view aparece a navbar não é visivel
                                                           //é colocado aqui e não no viewDidLoad pois o viewDidLoad apenas iria não mostrar a nav bar na 1a vez que
                                                           //a view aparece. Ao clicar no Favorites e depois ir novamente à Search a nav bar já ia aparecer.
    }

    func createDismissKeyboardTapGesture() {

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    //coloca-se o @objc pois o selector é uma func de objective-c e tem que se expor esse selector em obj-c
    @objc func pushFollowersListViewController() {

        guard isUsernameEntered else {

            presentGHFAlertOnMainThread(title: "Empty username", message: "Please enter a username. Need to know who to look for 😊", buttonTitle: "OK")
            return
        }

        let followersListViewController = FollowersListViewController()
        followersListViewController.username = userNameTextField.text
        followersListViewController.title = userNameTextField.text
        navigationController?.pushViewController(followersListViewController, animated: true)
    }

    func configureImageLogoView() {

        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints =  false
        logoImageView.image = UIImage(named: "gh-logo")!

        NSLayoutConstraint.activate([

            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80.0),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200.0),
            logoImageView.widthAnchor.constraint(equalToConstant: 200.0)
        ])
    }

    func configureTextField() {

        view.addSubview(userNameTextField)
        userNameTextField.delegate = self

        NSLayoutConstraint.activate([

            userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }

    func configureCallToActionButtonButton() {

        view.addSubview(callToActionButton)
        callToActionButton.addTarget(self, action: #selector(pushFollowersListViewController), for: .touchUpInside)

        NSLayoutConstraint.activate([

            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
}

extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        pushFollowersListViewController()
        return true
    }
}
