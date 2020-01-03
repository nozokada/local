//
//  ItemVC.swift
//  local
//
//  Created by Nozomi Okada on 12/15/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit

class ItemVC: UIViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: ItemPriceLabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    
    var itemPhoto: ItemPhoto!
    var itemTitle: String!
    var itemPrice: String = ""
    var itemDescription: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemPhoto.download() { (image) in
            self.itemImageView.image = image
        }
        itemTitleLabel.text = itemTitle
        itemPriceLabel.text = " \(CURRENCY_SYMBOL)\(itemPrice) "
        itemDescriptionLabel.text = itemDescription
        
        itemPriceLabel.layer.cornerRadius = 5
        itemPriceLabel.clipsToBounds = true
    }
    
    func initItem(item: Item) {
        itemPhoto = item.photo
        itemTitle = item.title
        itemPrice = item.price
        itemDescription = item.description
    }
}
