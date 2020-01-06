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
    public private(set) var senderId: String
    
    init(id: String, itemId: String, senderId: String) {
        self.id = id
        self.itemId = itemId
        self.senderId = senderId
    }
}
