//
//  UIViewController+Safari.swift
//  GHFollowers
//
//  Created by António Loureiro on 04/04/2024.
//

import Foundation
import SafariServices

extension UIViewController {

    func presentSafariViewController(with url: URL) {

        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .systemGreen
        present(safariViewController, animated: true)
    }
}
