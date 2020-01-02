//
//  Message.swift
//  local
//
//  Created by Nozomi Okada on 1/1/20.
//  Copyright © 2020 RIR. All rights reserved.
//

import Foundation

class Message {
    
    public private(set) var content: String
    public private(set) var senderId: String
    
    init(content: String, senderId: String) {
        self.content = content
        self.senderId = senderId
    }
}