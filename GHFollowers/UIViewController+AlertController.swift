//
//  UIViewController+AlertController.swift
//  GHFollowers
//
//  Created by António Loureiro on 02/03/2024.
//

import UIKit

extension UIViewController {

    //estes "alertas" são chamados muitas vezes depois de network calls e isso é numa background thread
    //e para mostrar os "alertas" têm de ser na main thread, pois é ilegal apresentar um elemento UI duma background thread
    //na main thread. Se não o fizer aqui teria que sempre que chamasse este VC teria de o wrappar e movê-lo para a main thread
    //Ao fazê-lo (main thread) aqui, sempre que chamar este VC vai ser sempre apresentado na main thread
    func presentGHFAlertOnMainThread(title: String, message: String, buttonTitle: String) {

        DispatchQueue.main.async {

            let alertViewController = GHFAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve
            self.present(alertViewController, animated: true)
        }
    }
}
