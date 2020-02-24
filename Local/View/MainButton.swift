//
//  MainButton.swift
//  local
//
//  Created by Nozomi Okada on 12/12/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit

@IBDesignable
class MainButton: UIButton {

    let fontName = MAIN_FONT_MEDIUM
    let fontSize: CGFloat = 18
    let cornerRadius: CGFloat = 5

    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    func customizeView() {
        layer.cornerRadius = cornerRadius
        self.backgroundColor = MAIN_COLOR
        self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        self.titleLabel?.font = UIFont(name: fontName, size: fontSize)
    }
    
    func enable() {
        self.alpha = 1.0
        isEnabled = true
    }
    
    func disable() {
        self.alpha = 0.5
        isEnabled = false
    }
}
