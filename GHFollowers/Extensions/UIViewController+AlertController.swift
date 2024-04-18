//
//  UIViewController+AlertController.swift
//  GHFollowers
//
//  Created by António Loureiro on 02/03/2024.
//

import UIKit

extension UIViewController {
    
    func presentGHFAlert(title: String, message: String, buttonTitle: String) {
        
        let alertViewController = GHFAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        present(alertViewController, animated: true)
    }

    func presentDefaultError() {

        let alertViewController = GHFAlertViewController(title: "Something went wrong",
                                                         message: "Unable to complte your task. Try again.",
                                                         buttonTitle: "Ok")
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        present(alertViewController, animated: true)
    }
}
