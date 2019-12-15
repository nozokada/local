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
    
    var itemImage: UIImage?
    var itemTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemImageView.image = itemImage
        itemTitleLabel.text = itemTitle
    }
    
    func initItem(item: Item) {
        itemImage = UIImage(named: item.imageName)
        itemTitle = item.title
    }
}
