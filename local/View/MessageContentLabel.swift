//
//  MessageContentLabel.swift
//  local
//
//  Created by Nozomi Okada on 1/12/20.
//  Copyright © 2020 RIR. All rights reserved.
//

import UIKit

@IBDesignable
class MessageContentLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 6.0
    @IBInspectable var bottomInset: CGFloat = 6.0
    @IBInspectable var leftInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 10.0
    @IBInspectable var borderWidth: CGFloat = 1.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override func awakeFromNib() {
        customizeView()
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }

    func customizeView() {
        setColors(textColor: .white, backgroundColor: MAIN_COLOR)
        self.layer.borderColor = MAIN_COLOR.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = topInset + bottomInset + borderWidth * 2
        self.clipsToBounds = true
        self.numberOfLines = 0
    }
    
    func setColors(textColor: UIColor, backgroundColor: UIColor) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
}
