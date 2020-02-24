//
//  Message.swift
//  local
//
//  Created by Nozomi Okada on 1/1/20.
//  Copyright © 2020 RIR. All rights reserved.
//

import Foundation

class Message {
    
    public private(set) var id: String
    public private(set) var offerId: String
    public private(set) var content: String
    public private(set) var to: String
    public private(set) var from: String
    
    init(id: String, offerId: String, content: String, to: String, from: String) {
        self.id = id
        self.offerId = offerId
        self.content = content
        self.to = to
        self.from = from
    }
}
