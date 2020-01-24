//
//  ItemCell.swift
//  local
//
//  Created by Nozomi Okada on 12/14/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit
import FirebaseUI

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemPriceLabel: ItemPriceLabel!
    
    var imageDownloadTask: StorageDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageDownloadTask?.cancel()
        itemImageView.image = LOADING_IMAGE
    }
    
    func customizeView() {
        itemImageView.layer.cornerRadius = 5
    }
    
    func update(item: Item) {
        itemPriceLabel.text = " \(CURRENCY_SYMBOL)\(item.price) "
        imageDownloadTask = item.photo.download() { (image) in
            self.itemImageView.image = image
        }
    }
}
