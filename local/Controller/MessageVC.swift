//
//  MessageVC.swift
//  local
//
//  Created by Nozomi Okada on 1/8/20.
//  Copyright © 2020 RIR. All rights reserved.
//

import UIKit

class MessageVC: UIViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    var offer: Offer!
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        item.photo.download() { (image) in
            self.itemImageView.image = image
        }
        itemTitleLabel.text = item.title
    }
    
    func initData(offer: Offer, item: Item) {
        self.offer = offer
        self.item = item
    }
}
