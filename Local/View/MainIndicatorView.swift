//
//  MainIndicatorView.swift
//  local
//
//  Created by Nozomi Okada on 1/15/20.
//  Copyright © 2020 RIR. All rights reserved.
//

import UIKit

class MainIndicatorView: UIActivityIndicatorView {

    init(parentView: UIView) {
        super.init(frame: CGRect.zero)
        let screenSize = UIScreen.main.bounds
        center = CGPoint(x: screenSize.width / 2 - frame.width / 2, y: parentView.frame.height / 2 - frame.height / 2)
        style = .large
        color = MAIN_COLOR
        parentView.addSubview(self)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
