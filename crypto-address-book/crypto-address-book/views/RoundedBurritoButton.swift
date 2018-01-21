//
//  RoundedBurritoButton.swift
//  mamawhatscooking
//
//  Created by Mario Lin on 5/13/17.
//  Copyright © 2017 Mario Lin. All rights reserved.
//

import Foundation
import UIKit

typealias TouchBlock = (_ sender: Any) -> ()

private enum Constants {
    static let extraWidth: CGFloat = 20
    static let defaultBorderRadius: CGFloat = 4.5
}

class RoundedBurritoButton: UIButton {
    var touchUpInsideBlock: TouchBlock?
    
    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + Constants.extraWidth
        return CGSize(width: width, height: superContentSize.height)
    }
    
    // MARK: init
    init(text: String, fontSize: CGFloat, backgroundColor: UIColor, titleColor: UIColor, borderRadius: CGFloat = Constants.defaultBorderRadius) {
        super.init(frame: .zero)
        layer.cornerRadius = borderRadius
        addTarget(self, action: #selector(touchedUpInside), for: .touchUpInside)
        
        layer.borderWidth = 0.5
        layer.borderColor = titleColor.cgColor

        titleLabel?.font = UIFont(name: "HelveticaNeue", size: fontSize)
        setTitle(text, for: .normal)
        setTitleColor(titleColor, for: .normal)    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = Constants.defaultBorderRadius
        addTarget(self, action: #selector(touchedUpInside), for: .touchUpInside)
    }
    
    @objc func touchedUpInside() {
        guard let touchBlock = touchUpInsideBlock else {
            return
        }
        touchBlock(self)
    }
}

// MARK:
private var associationKey = "UIButtonBlock"
extension UIButton {
    var block: (() -> ())? {
        get {
            return objc_getAssociatedObject(self, &associationKey) as? () -> ()
        }
        set(newValue) {
            objc_setAssociatedObject(self, &associationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func setTouchBlock(_ block: @escaping () -> ()) {
        self.block = block
        addTarget(self, action: #selector(touched), for: .touchUpInside)
    }
    
    @objc private func touched() {
        self.block?()
    }
}

