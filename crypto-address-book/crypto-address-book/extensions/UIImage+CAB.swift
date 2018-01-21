//
//  UIImage+CAB.swift
//  crypto-address-book
//
//  Created by Mario Lin on 1/21/18.
//  Copyright © 2018 Mario Lin. All rights reserved.
//

import UIKit

// derived from https://stackoverflow.com/questions/31803157/how-to-color-a-uiimage-in-swift
extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        if let img = UIGraphicsGetImageFromCurrentImageContext() {
            image = img
        }
        UIGraphicsEndImageContext()
        return image
    }
}

