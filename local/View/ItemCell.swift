//
//  ItemCell.swift
//  local
//
//  Created by Nozomi Okada on 12/14/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit

@IBDesignable
class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    let cornerRadius: CGFloat = 5
    
    override func awakeFromNib() {
        customizeView()
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    func customizeView() {
        itemImageView.layer.cornerRadius = cornerRadius
        itemPriceLabel.layer.cornerRadius = cornerRadius
        itemPriceLabel.clipsToBounds = true
    }
    
    func update(item: Item) {
        itemPriceLabel.text = " $\(item.price) "
        item.photo.download() { (image) in
            self.itemImageView.image = image
        }
    }
}
