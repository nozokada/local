//
//  MainTextField.swift
//  local
//
//  Created by Nozomi Okada on 1/19/20.
//  Copyright © 2020 RIR. All rights reserved.
//

import UIKit

@IBDesignable
class MainTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
