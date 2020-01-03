//
//  Message.swift
//  local
//
//  Created by Nozomi Okada on 1/1/20.
//  Copyright © 2020 RIR. All rights reserved.
//

import Foundation

class Message {
    
    public private(set) var itemId: String
    public private(set) var content: String
    public private(set) var senderId: String
    
    
    init(itemId: String, content: String, senderId: String) {
        self.itemId = itemId
        self.content = content
        self.senderId = senderId
    }
}
