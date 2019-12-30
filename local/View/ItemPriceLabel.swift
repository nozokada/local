//
//  ItemPriceLabel.swift
//  local
//
//  Created by Nozomi Okada on 12/29/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit

@IBDesignable
class ItemPriceLabel: UILabel {

    override func awakeFromNib() {
        customizeView()
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }

    func customizeView() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}
