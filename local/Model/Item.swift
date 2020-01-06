//
//  Item.swift
//  local
//
//  Created by Nozomi Okada on 12/14/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit

class Item {
    
    public private(set) var id: String
    public private(set) var title: String
    public private(set) var price: String
    public private(set) var description: String
    public private(set) var imagePaths: [String]
    public private(set) var photo: ItemPhoto
    
    init(id: String, title: String, price: String, description: String, imagePaths: [String]) {
        self.id = id
        self.title = title
        self.price = price
        self.description = description
        self.imagePaths = imagePaths
        self.photo = ItemPhoto(path: imagePaths.first!)
    }
}
