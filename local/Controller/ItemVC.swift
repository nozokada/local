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
    
    var itemImage: UIImage!
    var itemTitle: String = ""
    var itemPrice: String = ""
    var itemDescription: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemImageView.image = itemImage
        itemTitleLabel.text = itemTitle
        itemPriceLabel.text = " $\(itemPrice) "
        itemDescriptionLabel.text = itemDescription
        
        itemPriceLabel.layer.cornerRadius = 5
        itemPriceLabel.clipsToBounds = true
    }
    
    func initItem(item: Item) {
        itemImage = item.photo.image
        itemTitle = item.title
        itemPrice = item.price
        itemDescription = item.description
    }
}
