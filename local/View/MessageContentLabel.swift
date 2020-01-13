//
//  MessageContentLabel.swift
//  local
//
//  Created by Nozomi Okada on 1/12/20.
//  Copyright © 2020 RIR. All rights reserved.
//

import UIKit

@IBDesignable
class MessageContentLabel: UILabel {

    override func awakeFromNib() {
        customizeView()
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }

    func customizeView() {
        self.textColor = .white
        self.backgroundColor = MAIN_COLOR
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}
