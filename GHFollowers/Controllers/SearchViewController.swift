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
    //como se vai puxar o placeholder do search para cima, e este vai ser relativo ao logo então
    //como temos screens de alturas diferentes(iPhoneSE ou Iphone11, etc..)
    var logoImageViewTopConstraint: NSLayoutConstraint!

    var isUsernameEntered: Bool {

        guard let text = userNameTextField.text else {
            return false
        }
        return !text.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addsubViews(logoImageView, userNameTextField, callToActionButton)
        configureImageLogoView()
        configureTextField()
        configureCallToActionButtonButton()
        createDismissKeyboardTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        userNameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func createDismissKeyboardTapGesture() {

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    //coloca-se o @objc pois o selector é uma func de objective-c e tem que se expor esse selector em obj-c
    //ver a func configureCallToActionButtonButton() abaixo
    @objc func pushFollowersListViewController() {

        guard isUsernameEntered else {

            presentGHFAlertOnMainThread(title: "Empty username", message: "Please enter a username. Need to know who to look for 😊", buttonTitle: "OK")
            return
        }

        userNameTextField.resignFirstResponder()

        let followersListViewController = FollowersListViewController(username: userNameTextField.text!)
        navigationController?.pushViewController(followersListViewController, animated: true)
    }

    func configureImageLogoView() {

        logoImageView.translatesAutoresizingMaskIntoConstraints =  false
        logoImageView.image = Images.ghLogo

        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80

        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant)
        logoImageViewTopConstraint.isActive = true

        NSLayoutConstraint.activate([

            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200.0),
            logoImageView.widthAnchor.constraint(equalToConstant: 200.0)
        ])
    }

    func configureTextField() {

        userNameTextField.delegate = self

        NSLayoutConstraint.activate([

            userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }

    func configureCallToActionButtonButton() {

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
