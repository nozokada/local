//
//  ItemCell.swift
//  local
//
//  Created by Nozomi Okada on 12/14/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    func updateViews(item: Item) {
        itemImage.image = UIImage(named: item.imageName)
        itemTitle.text = item.title
        itemPrice.text = item.price
    }
}
