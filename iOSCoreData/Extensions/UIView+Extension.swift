//
//  UIView+Extensions.swift
//  iOSCoreData
//
//  Created by nguyen.van.duyb on 4/10/24.
//

import UIKit

extension UIView {
    func addShadow(color: UIColor = UIColor.black,
                   opacity: Float = 0.5,
                   offSet: CGSize = CGSize(width: 0, height: 2),
                   radius: CGFloat = 4) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
}
