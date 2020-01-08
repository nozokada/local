//
//  OfferCell.swift
//  local
//
//  Created by Nozomi Okada on 1/7/20.
//  Copyright © 2020 RIR. All rights reserved.
//

import UIKit

class OfferCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    override func awakeFromNib() {
        customizeView()
    }
    
    func customizeView() {
        itemImageView.layer.cornerRadius = 5
    }
    
    func update(item: Item) {
        itemTitleLabel.text = item.title
        item.photo.download() { (image) in
            self.itemImageView.image = image
        }
    }
}