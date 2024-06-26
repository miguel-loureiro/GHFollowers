//
//  GHFDataLoadingViewController.swift
//  GHFollowers
//
//  Created by António Loureiro on 08/04/2024.
//

import UIKit

class GHFDataLoadingViewController: UIViewController {

    var containerView: UIView!

    func showloadingView() {

        containerView = UIView(frame: view.bounds) //a container view vai ocupar todo o ecran
        view.addSubview(containerView)

        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0

        UIView.animate(withDuration: 0.25) {

            self.containerView.alpha = 0.8
        }

        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints =  false

        NSLayoutConstraint.activate([

            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        activityIndicator.startAnimating()
    }

    func dismissLoadingView() {

        //a remoção da container view deve ser feita na main thread pois esta func vai ser chamada numa background thread
        //e só podemos remover views a partir da main thread
        DispatchQueue.main.async {

            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }

    func showEmptyStateView(with message: String, in view: UIView) {

        let emptyStateView = GHFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
