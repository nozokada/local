//
//  Offer.swift
//  local
//
//  Created by Nozomi Okada on 1/5/20.
//  Copyright © 2020 RIR. All rights reserved.
//

import Foundation

class Offer {
    
    public private(set) var id: String
    public private(set) var itemId: String
    public private(set) var to: String
    public private(set) var from: String
    
    init(id: String, itemId: String, to: String, from: String) {
        self.id = id
        self.itemId = itemId
        self.to = to
        self.from = from
    }
}
