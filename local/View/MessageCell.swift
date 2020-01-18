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
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leadingConstraint = contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: MESSAGE_MARGIN)
        trailingConstraint = contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -MESSAGE_MARGIN)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leadingConstraint.isActive = false
        leadingConstraint.isActive = false
    }
    
    func update(message: Message, userId: String) {
        contentLabel.text = message.content
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        if message.from == userId {
            trailingConstraint.isActive = true
        } else {
            leadingConstraint.isActive = true
        }
    }
}
