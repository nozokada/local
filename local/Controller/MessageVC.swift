//
//  MessageVC.swift
//  local
//
//  Created by Nozomi Okada on 1/8/20.
//  Copyright © 2020 RIR. All rights reserved.
//

import UIKit

class MessageVC: UIViewController {

    var offer: Offer!
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initData(offer: Offer, item: Item) {
        self.offer = offer
        self.item = item
    }
}
