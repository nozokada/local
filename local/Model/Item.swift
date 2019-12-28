//
//  Item.swift
//  local
//
//  Created by Nozomi Okada on 12/14/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit

class Item {
    
    var title: String
    var price: String
    var description: String
    var imagePaths: [String]
    var photo: ItemPhoto
    
    init(title: String, price: String, description: String, imagePaths: [String]) {
        self.title = title
        self.price = price
        self.description = description
        self.imagePaths = imagePaths
        self.photo = ItemPhoto(path: imagePaths.first!)
    }
}
