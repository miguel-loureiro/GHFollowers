//
//  UIHelper.swift
//  GHFollowers
//
//  Created by António Loureiro on 07/03/2024.
//

import UIKit

struct UIHelper {

    //usa-se o static pois assim posso fazer UIHelper.createThreeColumnFlowLayout()
    //senão não fosse static tinha de criar um objeto do tipo UIHelper , ex. let exemplo = UIHelper()
    //e depois podia chamar o método create... assim exemplo.createThreeColumnFlowLayout()
    //com o static acedo ao método através do tipo e não através de uma instância da classe/struct
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {

        //como não temos view (onde as contas das width se baseiam) tenho que adicionar como argumento da func
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

        return flowLayout
    }
}
