//
//  MessageCell.swift
//  local
//
//  Created by Nozomi Okada on 1/12/20.
//  Copyright © 2020 RIR. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var contentLabel: MessageContentLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(message: Message, userId: String) {
        contentLabel.text = message.content
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        if message.from == userId {
            contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -MESSAGE_MARGIN).isActive = true
        } else {
            contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: MESSAGE_MARGIN).isActive = true
        }
    }
}
