//
//  Item.swift
//  local
//
//  Created by Nozomi Okada on 12/14/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit

class Item {
    private(set) public var title: String
    private(set) public var price: String
    private(set) public var description: String?
    private(set) public var imageName: String
    
    init(title: String, price: String, imageName: String, description: String?) {
        self.title = title
        self.price = price
        self.imageName = imageName
        self.description = description
    }
}
