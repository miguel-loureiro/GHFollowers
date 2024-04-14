//
//  UIView+Extension.swift
//  GHFollowers
//
//  Created by António Loureiro on 10/04/2024.
//

import UIKit

extension UIView {
    //variadic parameter, ao colocar ... estou a dizer que posso colocar vários itens e deste modo views passa a ser um Array
    func addsubViews(_ views: UIView...) {

        for view in views {

            addSubview(view)
        }
    }
}
