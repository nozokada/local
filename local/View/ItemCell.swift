//
//  ItemCell.swift
//  local
//
//  Created by Nozomi Okada on 12/14/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemPriceLabel: ItemPriceLabel!
    
    override func awakeFromNib() {
        customizeView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.itemImageView.image = LOADING_IMAGE
    }
    
    func customizeView() {
        itemImageView.layer.cornerRadius = 5
    }
    
    func update(item: Item) {
        itemPriceLabel.text = " \(CURRENCY_SYMBOL)\(item.price) "
        item.photo.download() { (image) in
            self.itemImageView.image = image
        }
    }
}
