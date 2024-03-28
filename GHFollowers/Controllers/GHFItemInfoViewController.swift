//
//  GHFItemInfoViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 28/03/2024.
//

import UIKit

class GHFItemInfoViewController: UIViewController {

    let stackView = UIStackView()
    let itemInfoViewOne = GHFItemInfoView()
    let itemInfoViewTwo = GHFItemInfoView()
    let actionButton = GHFButton()

    override func viewDidLoad() {

        super.viewDidLoad()
        configureBackgroundView()

    }

    private func configureBackgroundView() {

        view.layer.cornerRadius = 16
        view.backgroundColor = .secondarySystemBackground
    }

    private func configureStackView() {

        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing

        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
    }

    private func layoutUI() {

        view.addSubview(stackView)
        view.addSubview(actionButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 8

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),

            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
