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
    var sentByMe: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leadingConstraint.isActive = false
        trailingConstraint.isActive = false
    }
    
    func update(message: Message, userId: String) {
        contentLabel.text = message.content
        sentByMe = message.from == userId
        configureViews(from: message.from, userId: userId)
    }
    
    func configureViews(from: String, userId: String) {
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        if sentByMe {
            contentLabel.setColors(textColor: .white, backgroundColor: MAIN_COLOR)
            leadingConstraint = contentLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: MESSAGE_MARGIN * 2)
            trailingConstraint = contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -MESSAGE_MARGIN)
        } else {
            contentLabel.setColors(textColor: MAIN_COLOR, backgroundColor: .white)
            leadingConstraint = contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: MESSAGE_MARGIN)
            trailingConstraint = contentLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -MESSAGE_MARGIN * 2)
        }
        trailingConstraint.isActive = true
        leadingConstraint.isActive = true
    }
}
