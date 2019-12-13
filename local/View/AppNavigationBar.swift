//
//  AppNavigationBar.swift
//  local
//
//  Created by Nozomi Okada on 12/13/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit

@IBDesignable
class AppNavigationBar: UINavigationBar {

    let fontName = MAIN_FONT_MEDIUM
    let fontSize: CGFloat = 20

    override func awakeFromNib() {
        customizeView()
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    func customizeView() {
        self.barTintColor = MAIN_COLOR
        self.isTranslucent = false
        self.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            NSAttributedString.Key.font: UIFont(name: fontName, size: fontSize)!]
    }
}
